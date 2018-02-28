class LexemesController < ApplicationController
  layout '1col_layout'
  # GET /lexemes
  # GET /lexemes.xml
  def index
    @lexemes = Lexeme.sorted.includes(Lexeme::INCLUDE_TREE[:lexemes]).paginate(:page => params[:page])
    @page_title = t('lexemes.index.page_title')
    @all_langs = Hash[@lexemes.collect do |lex|
      [lex, Dictionary.langs_hash_for(lex.dictionaries)]
    end]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lexemes }
    end
  end

  # Lexemes whose headwords match the string in params[:headword].
  # params[:matchtype] should be either Lexeme::SUBSTRING or Lexeme::EXACT; defaults to the former.
  # (#190: This shouldn't exist; it should either belong to index action or possibly a search controller)
  def matching
    @lexeme = Lexeme.lookup_all_by_headword(params[:headword], :matchtype => params[:matchtype] || Lexeme::SUBSTRING)
    
    @page_title = t('lexemes.matching.results', count: @lexeme.length, query: params[:headword])
    @lexemes = @lexeme.paginate(:page => params[:page]).includes(Lexeme::INCLUDE_TREE[:lexemes])

    @all_langs = Hash[@lexemes.collect do |lex|
      [lex, Dictionary.langs_hash_for(lex.dictionaries)]
    end]

    respond_to do |format|
      format.html { render :index, :layout => '1col_layout' }
    end
  end

  # GET /lexemes/1
  # GET /lexemes/1.xml
  def show
    @lexeme = Lexeme.includes(Lexeme::INCLUDE_TREE[:lexemes]).find(params[:id])
    @loci = @lexeme.loci(:include => {:source => {:authorship => [:author, :title]}})
    @constructions = @lexeme.constructions
    @unattached = Parse.count_unattached_to @lexeme.headword_forms
    @loci_for = @lexeme.headword_forms.inject({}) {|hsh, headword| hsh.merge headword => @loci.attesting(headword) }
    @external_addresses = @lexeme.dictionaries.collect(&:external_address).uniq.delete_if {|addy| addy.blank? }
    @loci_for_sense = Hash[@lexeme.senses.collect { |sense| [sense, Locus.attesting(sense)] }]
    @authors_of = Lexeme.authors_hash(@constructions) 
    @loci_by = Hash[@authors_of.collect { |construction, authors| [construction, Hash[authors.collect {|author| [author, Locus.where(:id => construction.loci).attesting([construction, @lexeme]).authored_by(author)] }]]}]
    @page_title = view_context.titleize_headwords_for @lexeme
    @langs = Dictionary.langs_hash_for(@lexeme.dictionaries)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lexeme }
      format.json { 
        case params[:data] 
        when "langs" 
          hsh = Dictionary.langs_hash_for(@lexeme.dictionaries)
          hsh = hsh.collect do |categ, langs| 
            [categ, langs.collect {|lang| { tab: lang.to_s, code: lang.iso_639_code }}]
          end
          
          render json: Hash[hsh]
        else render nothing: true, status: 403
        end
      }
    end
  end

  # Find lexemes matching a given headword
  # If :matchtype is Lexeme::CREATE or there are no results, return the new entry form.
  # Otherwise, list any/all matching lexemes.
  def show_by_headword
    @lexeme = Lexeme.lookup_all_by_headword(params[:headword], :matchtype => params[:matchtype])
    
    if params[:matchtype] == Lexeme::CREATE || @lexeme.blank?
      flash[:notice] = t('lexemes.show_by_headword.new_lexeme_prompt_html', headword: params[:headword])
      flash[:headword] = params[:headword]
      respond_to do |format|
        format.html { redirect_to :action => 'new' }
        format.xml { render :nothing => true, :status => '404 Not Found' }
      end
    else
      respond_to do |format|
        format.html { redirect_to :action => 'matching', :headword => params[:headword], :matchtype => params[:matchtype] }
      end
    end
  end

  # GET /lexemes/new
  # GET /lexemes/new.xml
  def new
    @lexeme = Lexeme.new(:dictionaries => [Dictionary.first])
    @lexeme.headwords.build
    @lexeme.subentries.build
    @page_title = flash[:headword].present? ? 
      t('lexemes.new.page_title_with_headwords', headwords: flash[:headword]) :
      t('lexemes.new.page_title')

   @langs = Dictionary.langs_hash_for(@lexeme.dictionaries)

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @lexeme }
    end
  end

  # GET /lexemes/1/edit
  def edit
    @lexeme = Lexeme.find(params[:id])
    @lexeme.headwords.build if @lexeme.headwords.empty?
    @lexeme.subentries.build if @lexeme.subentries.empty?
    @nests = {}

    @dictionaries = @lexeme.dictionaries
    @langs = Dictionary.langs_hash_for(@dictionaries)
    @page_title = t('lexemes.edit.page_title', headwords: Globalize.with_locale(@langs[:source].first.try(:iso_639_code)){view_context.titleize_headwords_for(@lexeme)})
  end

  # POST /lexemes
  # POST /lexemes.xml
  def create
    @lexeme = Lexeme.new(params[:lexeme].permit(allowed_params))
    @page_title = t('lexemes.edit.page_title', headwords: view_context.titleize_headwords_for(@lexeme))

=begin
    params[:lexeme][:dictionary_ids].each do |d_id|
      @lexeme.dictionary_scopes << DictionaryScope.find_or_create_by_dictionary_id_and_lexeme_id(:dictionary_id => d_id, :lexeme_id => params[:id])
    end
=end

    respond_to do |format|
      if @lexeme.save
        flash[:notice] = t('lexemes.create.successful_create')
        format.html do
          case params[:commit]
          when t('lexemes.form.save_and_continue_editing') 
            @dictionaries = @lexeme.dictionaries
            @langs = Dictionary.langs_hash_for(@dictionaries)
            render :action => 'edit'
          else
            flash[:notice] = t('lexemes.create.create_another_prompt', default: "%{success} %{link}", success: flash[:notice], link: view_context.link_to(t('lexemes.create.create_another'), controller: 'lexemes', action:'new'))
            redirect_to(@lexeme)
          end
        end
        format.xml { render :xml => @lexeme, :status => :created, :location => @lexeme }
      else
        @dictionaries = @lexeme.dictionaries
        @langs = Dictionary.langs_hash_for(@dictionaries)
        
        format.html { render :action => "new" }
        format.xml { render :xml => @lexeme.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /lexemes/1
  # PUT /lexemes/1.xml
  def update
    @lexeme = Lexeme.find(params[:id])
    @lexeme.update(params[:lexeme].permit(allowed_params))
    @page_title = t('lexemes.edit.page_title', headwords: view_context.titleize_headwords_for(@lexeme))

=begin
    params[:lexeme][:dictionary_ids].each do |d_id|
      @lexeme.dictionary_scopes << DictionaryScope.find_or_create_by_dictionary_id_and_lexeme_id(:dictionary_id => d_id, :lexeme_id => params[:id])
    end
=end

    respond_to do |format|
      if @lexeme.save
        flash[:notice] = t('lexemes.update.successful_update')
        format.html do
          case params[:commit]
          when t('lexemes.form.save_and_continue_editing') 
            @dictionaries = @lexeme.dictionaries
            @langs = Dictionary.langs_hash_for(@dictionaries)
            render :action => "edit"
          else
            flash[:notice] = t('lexemes.create.create_another_prompt', default: "%{success} %{link}", success: flash[:notice], link: view_context.link_to(t('lexemes.update.create_new'), controller: 'lexemes', action:'new'))
            redirect_to(@lexeme)
          end
        end
        format.xml { head :ok }
      else
        @dictionaries = @lexeme.dictionaries
        @langs = Dictionary.langs_hash_for(@dictionaries)
        format.html { render :action => "edit" }
        format.xml { render :xml => @lexeme.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /lexemes/1
  # DELETE /lexemes/1.xml
  def destroy
    @lexeme = Lexeme.find(params[:id])
    @lexeme.destroy
    
    # Redirect to referer if there is one and if it's not the lexeme link
    # Otherwise send to main lexemes_url
    redirect_target = request.env["HTTP_REFERER"].blank? || 
      request.env["HTTP_REFERER"] == request.env["REQUEST_URI"] ? 
      lexemes_url : request.env["HTTP_REFERER"]
    
    respond_to do |format|
      format.html { redirect_to(redirect_target) }
      format.xml  { head :ok }
    end
  end

  private
  def allowed_params
    Lexeme.safe_params
  end
end
