class DictionariesController < ApplicationController
  layout '1col_layout'
  # GET /dictionaries
  # GET /dictionaries.xml
  def index
    @dictionaries = Dictionary.includes([:language, :source_language, :target_language]).all.sort_by {|d| d.title }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dictionaries }
    end
  end

  # GET /dictionaries/1
  # GET /dictionaries/1.xml
  def show
    @dictionary = Dictionary.find(params[:id])
    @source_language = (@dictionary.source_language || Language::UNDETERMINED)
    unsorted_lexemes = @dictionary.lexemes.includes([{:dictionaries => [:source_language]}, {:headwords => [:phonetic_forms, :language]}, {:subentries => [{:senses => [{:glosses => :language}, :notes, :language]}, {:etymologies => [:notes, :original_language, {:next_etymon => [:notes, :original_language, :next_etymon] }]}, {:notes => :language}, :language]}])
    @lexemes = @source_language.sort(unsorted_lexemes, by: :primary_headword)
    @page_title = @dictionary.title

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
    @dictionary = Dictionary.includes(:language).find(params[:id])
  end

  # POST /dictionaries
  # POST /dictionaries.xml
  def create
    @dictionary = Dictionary.new(params[:dictionary])

    respond_to do |format|
      if @dictionary.save
        flash[:notice] = t('dictionaries.create.success')
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
        flash[:notice] = t('dictionaries.update.success')
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
end
