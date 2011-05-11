class LexemesController < ApplicationController
  layout '1col_layout'
  # GET /lexemes
  # GET /lexemes.xml
  def index
    @lexemes = Lexeme.paginate(:page => params[:page], :include => [{:headwords => :phonetic_forms}, {:subentries => [{:senses => [:glosses, :notes]}, {:etymologies => :notes}, :notes]}])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lexemes }
    end
  end

  def matching
    @lexeme = Lexeme.lookup_all_by_headword(params[:headword], :matchtype => Lexeme::SUBSTRING)
    
    @page_title = "Lexemes - #{@lexeme.length} results for \"#{params[:headword]}\""
    @lexemes = @lexeme.paginate(:page => params[:page], :include => [{:headwords => :phonetic_forms}, {:subentries => [{:senses => [:glosses, :notes]}, {:etymologies => :notes}, :notes]}])

    respond_to do |format|
      format.html { render :index, :layout => '1col_layout' }
    end
  end

  # GET /lexemes/1
  # GET /lexemes/1.xml
  def show
    @lexeme = Lexeme.find(params[:id], :include => [{:headwords => :phonetic_forms}, {:subentries => [{:senses => [:glosses, :notes]}, {:etymologies => :notes}, :notes]}, :dictionaries])
    @loci = @lexeme.loci(:include => {:source => {:authorship => [:author, :title]}})
    @constructions = @lexeme.constructions
    @unattached = Parse.count_unattached_to @lexeme.headword_forms
    @loci_for = Hash.new 
    @lexeme.headword_forms.each { |headword|
      @loci_for[headword] = @loci.find_all{ |locus| locus.attests?(headword) }
    }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lexeme }
    end
  end

  def show_by_headword
    @lexeme = Lexeme.lookup_all_by_headword(params[:headword], :matchtype => params[:matchtype])
    
    case @lexeme.length
    when 0
      flash[:notice] = "There is no lexeme with <i>#{params[:headword]}</i> as headword.  You can create one below."
      flash[:headword] = params[:headword]
      respond_to do |format|
        format.html { redirect_to :action => 'new' }
        format.xml { render :nothing => true, :status => '404 Not Found' }
      end
    when 1
      respond_to do |format|
        format.html { redirect_to @lexeme.first }
        format.xml { render :xml => @lexeme.first }
        # lexeme display in XML is currently useless, btw
      end
    else
      respond_to do |format|
        format.html { redirect_to :action => 'matching', :headword => params[:headword] }
      end
    end
  end

  # GET /lexemes/new
  # GET /lexemes/new.xml
  def new
    @lexeme = Lexeme.new(:dictionaries => [])
    @lexeme.headwords.build(:form => flash[:headword])
    @lexeme.subentries.build

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
  end

  # POST /lexemes
  # POST /lexemes.xml
  def create
    @lexeme = Lexeme.new(params[:lexeme])

=begin
    params[:lexeme][:dictionary_ids].each do |d_id|
      @lexeme.dictionary_scopes << DictionaryScope.find_or_create_by_dictionary_id_and_lexeme_id(:dictionary_id => d_id, :lexeme_id => params[:id])
    end
=end

    respond_to do |format|
      if @lexeme.save
        flash[:notice] = "Lexeme was successfully created."
        format.html do
          case params[:commit]
          when "Create and continue editing" then render :action => 'edit'
          else
            flash[:notice] += " <a href=\"#{ url_for :controller => 'lexemes', :action => 'new' }\">Create another?</a>"
            redirect_to(@lexeme)
          end
        end
        format.xml { render :xml => @lexeme, :status => :created, :location => @lexeme }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @lexeme.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /lexemes/1
  # PUT /lexemes/1.xml
  def update
    @lexeme = Lexeme.find(params[:id])
    @lexeme.attributes = params[:lexeme]

=begin
    params[:lexeme][:dictionary_ids].each do |d_id|
      @lexeme.dictionary_scopes << DictionaryScope.find_or_create_by_dictionary_id_and_lexeme_id(:dictionary_id => d_id, :lexeme_id => params[:id])
    end
=end

    respond_to do |format|
      if @lexeme.save
        flash[:notice] = "Lexeme was successfully updated."
        format.html do
          case params[:commit]
          when "Update and continue editing" then render :action => "edit"
          else
            flash[:notice] += " <a href=\"#{ url_for :controller => 'lexemes', :action => 'new' }\">Create a new lexeme?</a>"
            redirect_to(@lexeme)
          end
        end
        format.xml { head :ok }
      else
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

    respond_to do |format|
      format.html { redirect_to(lexemes_url) }
      format.xml  { head :ok }
    end
  end
end
