class LociController < ApplicationController
  # GET /loci
  # GET /loci.xml
  def index
    @loci = Locus.paginate(:page => params[:page], :include => {:source => {:authorship => [:author, :title]}})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @loci }
    end
  end

  # GET /loci/1
  # GET /loci/1.xml
  def show
    @locus = Locus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @locus }
    end
  end

  # GET /loci/new
  # GET /loci/new.xml
  def new
    @locus = Locus.new
    @source = @locus.source
    @authorship = @source.authorship if @source

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @locus }
    end
  end

  # GET /loci/1/edit
  def edit
    @locus = Locus.find(params[:id], :include => {:attestations => {:parses => :interpretations}})
    @source = @locus.source
    @authorship = @source.authorship

    # Find all headwords corresponding to this locus' parses
    all_headwords = Headword.find(:all, :joins => ['INNER JOIN "parses" ON "parses"."parsed_form" LIKE "headwords"."form" INNER JOIN "attestations" ON "attestations"."id" = "parses"."attestation_id"'], :include => :lexeme, :conditions => ['"attestations"."locus_id" = ?', @locus.id])
    @headwords = Hash[*@locus.parses.collect do |parse| 
        [parse.parsed_form, all_headwords.find{|hw| hw.form == parse.parsed_form}]
      end.flatten]
    
    # Find all potential interpretations of this locus' parses
    all_interpretations = Sense.find(:all, :select => ['DISTINCT "senses".*, "headwords"."form" AS hw_form'], :joins => ['INNER JOIN "subentries" ON "subentries".id = "senses".subentry_id INNER JOIN "lexemes" ON "lexemes".id = "subentries".lexeme_id INNER JOIN "headwords" ON "headwords".lexeme_id = "lexemes".id INNER JOIN "parses" ON "parses"."parsed_form" LIKE "headwords"."form" INNER JOIN "attestations" ON "parses"."attestation_id" = "attestations"."id"'], :conditions => ['"attestations"."locus_id" = ?', @locus.id])
    @interpretations = {}
    @locus.parses.each do |parse|
        @interpretations[parse.parsed_form] = all_interpretations.select{|ip| ip.hw_form == parse.parsed_form}
      end
    
    @wantedparse = @locus.most_wanted_parse
  end

  # POST /loci
  # POST /loci.xml
  def create
    @locus = Locus.new(params[:locus])
    @source = @locus.build_source(params[:source])
    @authorship = @source.build_authorship(params[:authorship])

    @authorship.title = params[:authorship][:title_id].empty? ? @authorship.build_title(params[:new_title]) : Title.find(params[:authorship][:title_id])
    @authorship.author = params[:authorship][:author_id].empty? ? @authorship.build_author(params[:new_author]) : Author.find(params[:authorship][:author_id])

    each_wikilink(params[:locus][:example]) do |linked, shown|
      att = @locus.attestations.build(:attested_form => shown)
      att.parses.build(:parsed_form => linked)
    end

    respond_to do |format|
      if [@source, @locus, @authorship].all?(&:save) #FIX
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
    @source = @locus.source
    @authorship = @source.authorship

    @authorship.title = params[:authorship][:title_id].empty? ? @authorship.build_title(params[:new_title]) : Title.find(params[:authorship][:title_id])
    @authorship.author = params[:authorship][:author_id].empty? ? @authorship.build_author(params[:new_author]) : Author.find(params[:authorship][:author_id])

    @locus.attributes = params[:locus]
    @source.attributes = params[:source]
    @authorship.attributes = params[:authorship]

    respond_to do |format|
      if [@source, @locus, @authorship].all?(&:save)
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
  
protected
  def each_wikilink to_break
    to_break.scan(/\[\[.+?\]\]\w*/).each do |entry|
      shown = entry.sub(/.+?\|/, '').sub(/\[\[/, '').sub(/\]\]/, '')
      linked = entry.gsub(/\|.+/, '').sub(/\[\[/, '').sub(/\]\].*/, '')

      yield(linked, shown)
    end
  end
end
