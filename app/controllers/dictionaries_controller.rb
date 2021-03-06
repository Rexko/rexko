class DictionariesController < ApplicationController
  layout '1col_layout'
  # GET /dictionaries
  # GET /dictionaries.xml
  def index
    @dictionaries = (params[:dictionaries].present? \
      ? Dictionary.where(id: params[:dictionaries])
      : Dictionary).includes([:language, :source_language, :target_language]).all.sort_by {|d| d.title }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dictionaries }
      format.json { 
        case params[:data] 
        when "langs" 
          hsh = Dictionary.langs_hash_for(@dictionaries)
          hsh = hsh.collect do |categ, langs| 
            [categ, langs.collect {|lang| { tab: lang.to_s, code: lang.iso_639_code, underscore_code: lang.iso_639_code.underscore }}]
          end
          
          render json: Hash[hsh]
        else render nothing: true, status: 403
        end
      }
    end
  end

  # GET /dictionaries/1
  # GET /dictionaries/1.xml
  def show
    @dictionary = Dictionary.find(params[:id])
    @source_language = (@dictionary.source_language || Language::UNDETERMINED)
    unsorted_lexemes = @dictionary.lexemes.includes(Lexeme::INCLUDE_TREE[:lexemes])
    @lexemes = @source_language.sort(unsorted_lexemes, by: :primary_headword)
    @page_title = @dictionary.title
    @langs = Dictionary.langs_hash_for(@dictionary)

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
