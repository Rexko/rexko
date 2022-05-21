# frozen_string_literal: true

class LociController < ApplicationController
  layout '1col_layout'
  # GET /loci
  # GET /loci.xml
  def index
    @loci = @loci = if params[:loci]
                      Locus.where(id: params[:loci].collect(&:to_i))
                    else
                      Locus.sorted
                    end.includes([
                                   { source: [:translations,
                                              { authorship: [{ author: :translations },
                                                             { title: :translations }] }] }, parses: [:translations, { interpretations: { sense: :translations } }]
                                 ]).paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @loci }
    end
  end

  # GET /loci/1
  # GET /loci/1.xml
  def show
    @locus = Locus.includes(parses: { interpretations: :sense }).find(params[:id])
    @page_title = t('loci.show.page title_html', source: view_context.cited_name(@locus.source.authorship)).html_safe

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @locus }
    end
  end

  # GET /loci/new
  # GET /loci/new.xml
  def new
    @locus = Locus.new
    @source = @locus.build_source
    @authorship = @source.build_authorship
    @authorship.build_author
    @authorship.build_title

    @authors = Author.order(:name)
    @titles = Title.order(:name)

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render xml: @locus }
    end
  end

  # GET /loci/1/edit
  def edit
    @locus = Locus.where(id: params[:id]).includes(attestations: { parses: :interpretations },
                                                   parses: :translations).first
    @locale_name = Language.where(iso_639_code: I18n.locale).first.try(:name)
    @source = @locus.source
    @authorship = @source.authorship if @source
    @nests = {}

    # Find all lexemes with headwords corresponding to this locus' parses
    all_headwords = Lexeme.lookup_all_by_headwords(Parse.forms_of(@locus.parses),
                                                   include: { headwords: :translations })

    @headwords = @locus.parses.inject({}) do |memo, parse|
      swapform = parse.parsed_form.dup
      swapform[0, 1] = swapform[0, 1].swapcase

      memo.merge({ parse.parsed_form => all_headwords.find do |lex|
        (lex.headword_forms.include? parse.parsed_form) || (lex.headword_forms.include? swapform)
      end })
    end

    # Find all potential interpretations of this locus' parses
    all_interpretations = Sense.lookup_all_by_parses_of @locus
    @interpretations = {}
    @locus.parses.each do |parse|
      @interpretations[parse.parsed_form] = all_interpretations.select { |ip| ip.hw_form == parse.parsed_form }
    end

    @wantedparse = @locus.most_wanted_parse
    @potential_constructions = @locus.potential_constructions

    @authors = Author.order(:name)
    @titles = @authorship ? Title.joins(:authors).where(authors: { id: @authorship.author }).order(:name) : Title.order(:name)
  end

  # POST /loci
  # POST /loci.xml
  def create
    @locus = Locus.new(params[:locus].permit(allowed_params))

    each_wikilink(params[:locus][:example]) do |linked, shown|
      att = @locus.attestations.build(attested_form: shown)
      att.parses.build(parsed_form: linked)
    end

    respond_to do |format|
      if @locus.save
        flash[:notice] = t('loci.create.success')
        format.html do
          case params[:commit]
          when I18n.t('loci.form.save_and_continue_editing')
            @locale_name = Language.where(iso_639_code: I18n.locale).first.name
            redirect_to action: 'edit', id: @locus.id, status: 303
          else redirect_to(@locus)
          end
        end
        format.xml { render xml: @locus, status: :created, location: @locus }
      else
        format.html { render action: 'new' }
        format.xml { render xml: @locus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /loci/1
  # PUT /loci/1.xml
  def update
    @locus = Locus.find(params[:id])

    # FIXME: Because of the way a new sense is added under an existing subentry,
    # we have to tweak params so that it is appropriately associated.
    atesute = params[:locus][:attestations_attributes]
    atesute&.each do |_, att_v|
      paasu = att_v[:parses_attributes]
      next unless paasu

      paasu.each do |_, par_v|
        intah = par_v[:interpretations_attributes]
        next unless intah

        intah.each do |_, int_v|
          int_v[:sense_attributes][:subentry_id] = int_v[:sense_id].split('-')[1] if int_v[:sense_id].try(:slice, 'new')
        end
      end
    end

    @locus.attributes = params[:locus].permit(allowed_params)

    respond_to do |format|
      if @locus.save
        flash[:notice] = t('loci.update.success')
        format.html do
          case params[:commit]
          when I18n.t('loci.form.save_and_continue_editing')
            @locale_name = Language.where(iso_639_code: I18n.locale).first.name
            redirect_to action: 'edit', status: 303
          else redirect_to(@locus)
          end
        end
        format.xml { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml { render xml: @locus.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loci/1
  # DELETE /loci/1.xml
  def destroy
    @locus = Locus.find(params[:id])
    @locus.destroy

    respond_to do |format|
      format.html { redirect_to(params[:back] || loci_url) }
      format.xml  { head :ok }
    end
  end

  # TODO: Replace references to this with direct references to parsable/index
  def unattached
    if params[:forms]
      forms = [params[:forms]]
    else
      lexeme = Lexeme.where(id: params[:id]).includes(:headwords).first
      forms = lexeme.headword_forms
    end

    @parsables = Parse.unattached_to(forms).paginate(page: params[:page], per_page: 5)
    @page_title = I18n.t('loci.unattached.unattached_to', forms: forms.to_sentence)

    render 'parsable/index'
  end

  def matching
    authors = Author.where(['name LIKE ?', "%#{params[:author]}%"])
    if authors
      author_loci = Locus.sorted.includes([{ source: { authorship: %i[author title] } },
                                           parses: { interpretations: :sense }]).authored_by(authors)

      @page_title = "Loci - #{author_loci.length} results for \"#{params[:author]}\""
      @loci = author_loci.paginate(page: params[:page])
    end

    render 'index'
  end

  def show_by_author
    redirect_to action: 'matching', author: params[:author]
  end

  protected

  def each_wikilink(to_break)
    to_break.scan(/\[\[.+?\]\]\w*/).each do |entry|
      shown = entry.sub(/.+?\|/, '').sub(/\[\[/, '').sub(/\]\]/, '')
      linked = entry.gsub(/\|.+/, '').sub(/\[\[/, '').sub(/\]\].*/, '')

      shown = shown.empty? ? linked.gsub(/ \(.+\)\z/, '') : shown

      yield(linked, shown)
    end
  end

  private

  def allowed_params
    Locus.safe_params
  end
end
