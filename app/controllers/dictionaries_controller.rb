class DictionariesController < ApplicationController
  # GET /dictionaries
  # GET /dictionaries.xml
  def index
    @dictionaries = Dictionary.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dictionaries }
    end
  end

  # GET /dictionaries/1
  # GET /dictionaries/1.xml
  def show
    @dictionary = Dictionary.find(params[:id])
    # 'sort_latin(@dictionary.lexemes).paginate' is pretty bad, I think 
    @lexemes = (
      @dictionary.source_language.iso_639_code == 'la' ?
        sort_latin(@dictionary.lexemes) : 
        @dictionary.lexemes
      ).paginate(:page => params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dictionary }
    end
  end

  # GET /dictionaries/new
  # GET /dictionaries/new.xml
  def new
    @dictionary = Dictionary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dictionary }
    end
  end

  # GET /dictionaries/1/edit
  def edit
    @dictionary = Dictionary.find(params[:id])
  end

  # POST /dictionaries
  # POST /dictionaries.xml
  def create
    @dictionary = Dictionary.new(params[:dictionary])

    respond_to do |format|
      if @dictionary.save
        flash[:notice] = 'Dictionary was successfully created.'
        format.html { redirect_to(@dictionary) }
        format.xml  { render :xml => @dictionary, :status => :created, :location => @dictionary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dictionary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dictionaries/1
  # PUT /dictionaries/1.xml
  def update
    @dictionary = Dictionary.find(params[:id])

    respond_to do |format|
      if @dictionary.update_attributes(params[:dictionary])
        flash[:notice] = 'Dictionary was successfully updated.'
        format.html { redirect_to(@dictionary) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dictionary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dictionaries/1
  # DELETE /dictionaries/1.xml
  def destroy
    @dictionary = Dictionary.find(params[:id])
    @dictionary.destroy

    respond_to do |format|
      format.html { redirect_to(dictionaries_url) }
      format.xml  { head :ok }
    end
  end
  
  def sort_latin collection
    collection.sort_by do |x|
      sub_latin(x.headwords[0].form).downcase
    end
  end

protected
  def sub_latin str
    str.gsub(/[jvw]/i) do |unkosher|
      case unkosher
      when /j/i then "i"
      when /v/i then "u"
      when /w/i then "uu"
      end
    end
  end
end
