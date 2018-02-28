class HeadwordsController < ApplicationController
  # GET /headwords
  # GET /headwords.xml
  def index
    @headwords = Headword.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @headwords }
    end
  end

  # GET /headwords/1
  # GET /headwords/1.xml
  def show
    @headword = Headword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @headword }
    end
  end

  # GET /headwords/new
  # GET /headwords/new.xml
  def new
    @headword = Headword.build_from_only_valid(params)
    @path = params[:path].try(:sub, /(lexeme.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    @dictionaries = Dictionary.where(id: params[:dictionaries])
    @langs = Dictionary.langs_hash_for(@dictionaries)
    
    respond_to do |format|
      format.html do
      	if request.xhr?
      		render :partial => "form"
      	end
      end
      format.xml  { render :xml => @headword }
    end
  end

  # GET /headwords/1/edit
  def edit
    @headword = Headword.find(params[:id])
  end

  # POST /headwords
  # POST /headwords.xml
  def create
    @headword = Headword.new(params[:headword].permit(allowed_params))

    respond_to do |format|
      if @headword.save
        flash[:notice] = 'Headword was successfully created.'
        format.html { redirect_to(@headword) }
        format.xml  { render :xml => @headword, :status => :created, :location => @headword }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @headword.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /headwords/1
  # PUT /headwords/1.xml
  def update
    @headword = Headword.find(params[:id])

    respond_to do |format|
      if @headword.update_attributes(params[:headword].permit(allowed_params))
        flash[:notice] = 'Headword was successfully updated.'
        format.html { redirect_to(@headword) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @headword.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /headwords/1
  # DELETE /headwords/1.xml
  def destroy
    @headword = Headword.find(params[:id])
    @headword.destroy

    respond_to do |format|
      format.html { redirect_to(headwords_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def allowed_params
    Headword.safe_params
  end
end
