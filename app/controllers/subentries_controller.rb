class SubentriesController < ApplicationController
  # GET /subentries
  # GET /subentries.xml
  def index
    @subentries = Subentry.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subentries }
    end
  end

  # GET /subentries/1
  # GET /subentries/1.xml
  def show
    @subentry = Subentry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subentry }
    end
  end

  # GET /subentries/new
  # GET /subentries/new.xml
  def new
    @subentry = Subentry.build_from_only_valid(params)
    @path = params[:path].try(:sub, /(lexeme.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    @dictionaries = Dictionary.where(id: params[:dictionaries])
    @langs = Dictionary.langs_hash_for(@dictionaries)
    
    respond_to do |format|
      format.html do
      	if request.xhr?
      		render :partial => "form"
      	end
      end
      format.xml  { render :xml => @subentry }
    end
  end

  # GET /subentries/1/edit
  def edit
    @subentry = Subentry.find(params[:id])
  end

  # POST /subentries
  # POST /subentries.xml
  def create
    @subentry = Subentry.new(params[:subentry].permit(allowed_params))

    respond_to do |format|
      if @subentry.save
        flash[:notice] = 'Subentry was successfully created.'
        format.html { redirect_to(@subentry) }
        format.xml  { render :xml => @subentry, :status => :created, :location => @subentry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subentry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subentries/1
  # PUT /subentries/1.xml
  def update
    @subentry = Subentry.find(params[:id])

    respond_to do |format|
      if @subentry.update_attributes(params[:subentry])
        flash[:notice] = 'Subentry was successfully updated.'
        format.html { redirect_to(@subentry) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subentry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subentries/1
  # DELETE /subentries/1.xml
  def destroy
    @subentry = Subentry.find(params[:id])
    @subentry.destroy

    respond_to do |format|
      format.html { redirect_to(subentries_url) }
      format.xml  { head :ok }
    end
  end

  private
  def allowed_params
    Subentry.safe_params
  end
end
