class LanguagesController < ApplicationController
  layout '1col_layout'
  # GET /languages
  # GET /languages.xml
  def index
    @languages = Language.all.sort_by{|l| l.to_s}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @languages }
    end
  end

  # GET /languages/1
  # GET /languages/1.xml
  def show
    @language = Language.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @languages }
    end
  end

  # GET /languages/new
  # GET /languages/new.xml
  def new
    @language = Language.new
    @locale_name = Language.where(iso_639_code: I18n.locale).first.name

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @languages }
    end
  end

  # GET /languages/1/edit
  def edit
    @language = Language.find(params[:id])
    @locale_name = Language.where(iso_639_code: I18n.locale).first.name
  end

  # POST /languages
  # POST /languages.xml
  def create
    @language = Language.new(params[:language])

    respond_to do |format|
      if @language.save
        update_accessors
        
        flash[:notice] = t('languages.new.success')
        format.html { redirect_to(@language) }
        format.xml  { render :xml => @language, :status => :created, :location => @language }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /languages/1
  # PUT /languages/1.xml
  def update
    @language = Language.includes(:sort_order).find(params[:id])

    respond_to do |format|
      if @language.update_attributes(params[:language])
        update_accessors
        
        flash[:notice] = t('languages.edit.success')
        format.html { redirect_to(@language) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /languages/1
  # DELETE /languages/1.xml
  def destroy
    @language = Language.find(params[:id])
    @language.destroy

    respond_to do |format|
      format.html { redirect_to(languages_url) }
      format.xml  { head :ok }
    end
  end
  
  def matching
    @languages = Language.matching(params[:value]).sort_by {|lang| lang.to_s }
    @ref = params[:ref]
    
    respond_to do |format|
      format.js { render :partial => "autocomplete" }
    end
  end
  
  private

  # Update accessors for models that have accessors defined
  def update_accessors
    ActiveRecord::Base.descendants.each do |c|
      c.globalize_accessors(locales: Language.defined_language_codes) if c.respond_to?(:globalize_locales)
    end
  end
end
