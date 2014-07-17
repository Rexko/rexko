class LociController < ApplicationController
  layout '1col_layout'
  # GET /loci
  # GET /loci.xml
  def index
    @loci = if params[:loci]
      @loci = Locus.where(:id => params[:loci].split('/').collect(&:to_i))
    else
      @loci = Locus.sorted
    end.includes([{:source => {:authorship => [:author, :title]}}, :parses => {:interpretations => :sense}]).paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @loci }
    end
  end

  # GET /loci/1
  # GET /loci/1.xml
  def show
    @locus = Locus.includes(:parses => {:interpretations => :sense}).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @locus }
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

    @authors = Author.find(:all, :order => "name")
    @titles = Title.find(:all, :order => "name")

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @locus }
    end
  end

  # GET /loci/1/edit
  def edit
    @locus = Locus.where(:id => params[:id]).includes(:attestations => {:parses => :interpretations}).first
    @source = @locus.source
    @authorship = @source.authorship if @source
    @nests = {}

    # Find all lexemes with headwords corresponding to this locus' parses
    all_headwords = Lexeme.lookup_all_by_headwords(Parse.forms_of(@locus.parses), :include => :headwords)
    
    @headwords = @locus.parses.inject({}) do |memo, parse|
      swapform = parse.parsed_form.dup
      swapform[0,1] = swapform[0,1].swapcase
    
      memo.merge({ parse.parsed_form => all_headwords.find do |lex| 
        (lex.headword_forms.include? parse.parsed_form) || (lex.headword_forms.include? swapform)
      end })
    end

    # Find all potential interpretations of this locus' parses
    all_interpretations = Sense.select('DISTINCT "senses".*, "headwords"."form" AS hw_form').joins(['INNER JOIN "subentries" ON "subentries".id = "senses".subentry_id INNER JOIN "lexemes" ON "lexemes".id = "subentries".lexeme_id INNER JOIN "headwords" ON "headwords".lexeme_id = "lexemes".id INNER JOIN "parses" ON "parses"."parsed_form" = "headwords"."form" INNER JOIN "attestations" ON ("parses"."parsable_id" = "attestations"."id" AND "parses"."parsable_type" = \'Attestation\')']).where(['"attestations"."locus_id" = ?', @locus.id]).includes(:subentry => {:lexeme => :dictionaries})
    @interpretations = {}
    @locus.parses.each do |parse|
        @interpretations[parse.parsed_form] = all_interpretations.select{|ip| ip.hw_form == parse.parsed_form}
      end
    
    @wantedparse = @locus.most_wanted_parse
    @potential_constructions = @locus.potential_constructions
    
    @authors = Author.find(:all, :order => "name")
    @titles = @authorship ? Title.joins(:authors).where(:authors => { :id => @authorship.author}).order(:name) : Title.find(:all, :order => "name")
  end

  # POST /loci
  # POST /loci.xml
  def create
    @locus = Locus.new(params[:locus])

    each_wikilink(params[:locus][:example]) do |linked, shown|
      att = @locus.attestations.build(:attested_form => shown)
      att.parses.build(:parsed_form => linked)
    end

    respond_to do |format|
      if @locus.save
        flash[:notice] = 'Locus was successfully created.'
        format.html do
          case params[:commit]
          when "Create and continue editing" then redirect_to :action => 'edit', :id => @locus.id, :status => 303
          else redirect_to(@locus)
          end
        end
        format.xml { render :xml => @locus, :status => :created, :location => @locus }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @locus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /loci/1
  # PUT /loci/1.xml
  def update
    @locus = Locus.find(params[:id])

		atesute = params[:locus][:attestations_attributes]
		atesute.each {|att_k, att_v|
			paasu = att_v[:parses_attributes]
			paasu.each {|par_k, par_v|
				intah = par_v[:interpretations_attributes]
				intah.each {|int_k, int_v|
					if int_v[:sense_id].try(:slice, "new")
						int_v[:sense_attributes][:subentry_id] = int_v[:sense_id].split('-')[1]
						int_v.delete(:sense_id)
					end
				} if intah
			} if paasu
		} if atesute
		
    @locus.attributes = params[:locus]

    respond_to do |format|
      if @locus.save
        flash[:notice] = 'Locus was successfully updated.'
        format.html do
          case params[:commit]
          when "Update and continue editing" then redirect_to :action => "edit", :status => 303
          else redirect_to(@locus)
          end
        end
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @locus.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /loci/1
  # DELETE /loci/1.xml
  def destroy
    @locus = Locus.find(params[:id])
    @locus.destroy

    respond_to do |format|
      format.html { redirect_to(loci_url) }
      format.xml  { head :ok }
    end
  end
  
  # TODO: Replace references to this with direct references to parsable/index
  def unattached
  	if params[:forms] 
  		forms = [params[:forms]]
  	else
	    lexeme = Lexeme.where(:id => params[:id]).includes(:headwords).first
 		 	forms = lexeme.headword_forms
 		end

  	@parsables = Parse.unattached_to(forms).paginate(:page => params[:page], :per_page => 5)
  	@page_title = "Unattached to %s" % forms.to_sentence
    
    render "parsable/index"
  end
  
  def matching
    authors = Author.where(["name LIKE ?", "%" + params[:author] + "%"])
    if authors
      author_loci = Locus.sorted.includes([{:source => {:authorship => [:author, :title]}}, :parses => {:interpretations => :sense}]).authored_by(authors)

	    @page_title = "Loci - #{author_loci.length} results for \"#{params[:author]}\""
      @loci = author_loci.paginate(:page => params[:page])
    end
    
    render "index"
  end
  
  def show_by_author
    redirect_to :action => 'matching', :author => params[:author]
  end

  
protected
  def each_wikilink to_break
    to_break.scan(/\[\[.+?\]\]\w*/).each do |entry|
      shown = entry.sub(/.+?\|/, '').sub(/\[\[/, '').sub(/\]\]/, '')
      linked = entry.gsub(/\|.+/, '').sub(/\[\[/, '').sub(/\]\].*/, '')

      shown = shown.empty? ? linked.gsub(/ \(.+\)\z/, '') : shown

      yield(linked, shown)
    end
  end
end
