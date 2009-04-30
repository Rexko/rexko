class LociController < ApplicationController
  # GET /loci
  # GET /loci.xml
  def index
    @loci = Locus.find(:all)

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
    @title = @authorship.title if @authorship
    @author = @authorship.author if @authorship

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @locus }
    end
  end

  # GET /loci/1/edit
  def edit
    @locus = Locus.find(params[:id])
    @source = @locus.source
    @authorship = @source.authorship
    @title = @authorship.title
    @author = @authorship.author
    
#    @new_attestation = Attestation.new
#    @new_parses = Array.new
#    @locus.attestations.each { |attestation| @new_parses << attestation.parses.build }
  end

  # POST /loci
  # POST /loci.xml
  def create
    @locus = Locus.new(params[:locus])
    @source = @locus.build_source(params[:source])
    @authorship = @source.build_authorship(params[:authorship])
    
    @title = params[:authorship][:title_id].empty? ? @authorship.build_title(params[:new_title]) : Title.find(params[:authorship][:title_id])
    @author = params[:authorship][:author_id].empty? ? @authorship.build_author(params[:new_author]) : Author.find(params[:authorship][:author_id])

    to_break = params[:locus][:example]
    broken = to_break.scan(/\[\[.+?\]\]/)
    broken.each do |entry|
      entry.delete!("[]")

      attested = entry.include?("|") ? entry.gsub(/.+\|/, '') : entry
      att = Attestation.new(:attested_form => attested)
      att.save
      @locus.attestations << att

      parsed = entry.include?("|") ? entry.gsub(/\|.+/, '') : entry
      parse = Parse.new(:parsed_form => parsed)
      parse.save
      att.parses << parse
      
      # And we'll make an Interpretation later (or once we ajaxify)
      
      # => left off here: modify the form to list and edit attestations. 
      # =>                also, modify 'update' to do likewise.
    end

    respond_to do |format|
      if [@source, @locus, @authorship].all?(&:save!) #FIX
        flash[:notice] = 'Locus was successfully created.'
        format.html do
          case params[:commit]
          when "Create and continue editing" then render :action => 'edit'
          else redirect_to(@locus) 
          end
        end
        format.xml  { render :xml => @locus, :status => :created, :location => @locus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @locus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /loci/1
  # PUT /loci/1.xml
  def update
    @locus = Locus.find(params[:id])
    @source = @locus.source
    @authorship = @source.authorship
      @title = @authorship.title
      @author = @authorship.author

    @title = params[:authorship][:title_id].empty? ? @authorship.build_title(params[:new_title]) : Title.find(params[:authorship][:title_id])
    @author = params[:authorship][:author_id].empty? ? @authorship.build_author(params[:new_author]) : Author.find(params[:authorship][:author_id])

    records_to_update = []

    params[:new_interpretation_for_parse].each do |id, attributes|
      records_to_update << build_if_valid(Interpretation, Parse.find_by_id(id).interpretations, attributes)
    end

    new_att = build_if_valid(Attestation, @locus.attestations, params[:new_attestation])
    records_to_update << new_att

    records_to_update << build_if_valid(Parse, new_att.parses, params[:new_parse]) if new_att

    records_to_update << @locus

    respond_to do |format|
      if records_to_update.compact.all?(&:save!) && @source.update_attributes(params[:source]) &&  @locus.update_attributes(params[:locus]) && @authorship.update_attributes(params[:authorship])
        flash[:notice] = 'Locus was successfully updated.'
        format.html do
          case params[:commit]
          when "Update and continue editing" then render :action => "edit"
          else redirect_to(@locus) 
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @locus.errors, :status => :unprocessable_entity }
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
  def build_if_valid klass, collection, options = {}
    new_record = klass.new(options)
    if new_record.valid?
      new_record.save  # Furf?
      collection << new_record 
      return new_record
    else
      return nil
    end
  end
end
