class PhoneticFormsController < ApplicationController
  # GET /phonetic_forms
  # GET /phonetic_forms.xml
  def index
    @phonetic_forms = PhoneticForm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @phonetic_forms }
    end
  end

  # GET /phonetic_forms/1
  # GET /phonetic_forms/1.xml
  def show
    @phonetic_form = PhoneticForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @phonetic_form }
    end
  end

  # GET /phonetic_forms/new
  # GET /phonetic_forms/new.xml
  def new
    @phonetic_form = PhoneticForm.build_from_only_valid(params)
    @dictionaries = Dictionary.where(id: params[:dictionaries])
    @langs = Dictionary.langs_hash_for(@dictionaries)

    respond_to do |format|
      format.html do
        if request.xhr?
          @path = params[:path].sub(/(headword.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
        	render :partial => "form"
        end
      end
      format.xml  { render :xml => @phonetic_form }
    end
  end

  # GET /phonetic_forms/1/edit
  def edit
    @phonetic_form = PhoneticForm.find(params[:id])
  end

  # POST /phonetic_forms
  # POST /phonetic_forms.xml
  def create
    @phonetic_form = PhoneticForm.new(params[:phonetic_form])

    respond_to do |format|
      if @phonetic_form.save
        flash[:notice] = 'PhoneticForm was successfully created.'
        format.html { redirect_to(@phonetic_form) }
        format.xml  { render :xml => @phonetic_form, :status => :created, :location => @phonetic_form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @phonetic_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /phonetic_forms/1
  # PUT /phonetic_forms/1.xml
  def update
    @phonetic_form = PhoneticForm.find(params[:id])

    respond_to do |format|
      if @phonetic_form.update_attributes(params[:phonetic_form])
        flash[:notice] = 'PhoneticForm was successfully updated.'
        format.html { redirect_to(@phonetic_form) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @phonetic_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /phonetic_forms/1
  # DELETE /phonetic_forms/1.xml
  def destroy
    @phonetic_form = PhoneticForm.find(params[:id])
    @phonetic_form.destroy

    respond_to do |format|
      format.html { redirect_to(phonetic_forms_url) }
      format.xml  { head :ok }
    end
  end
end
