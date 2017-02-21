class SensesController < ApplicationController
  # GET /senses
  # GET /senses.xml
  def index
    @senses = Sense.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @senses }
    end
  end

  # GET /senses/1
  # GET /senses/1.xml
  def show
    @sense = Sense.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sense }
    end
  end

  # GET /senses/new
  # GET /senses/new.xml
  def new
    @sense = Sense.build_from_only_valid(params)
    @path = params[:path].try(:sub, /(sense.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    @dictionaries = Dictionary.where(id: params[:dictionaries]).all
    @langs = Dictionary.langs_hash_for(@dictionaries)
    
    respond_to do |format|
      format.html do
      	if request.xhr?
      		render :partial => "form"
      	end
      end
      format.xml  { render :xml => @sense }
    end
  end

  # GET /senses/1/edit
  def edit
    @sense = Sense.find(params[:id])
  end

  # POST /senses
  # POST /senses.xml
  def create
    @sense = Sense.new(params[:sense])

    respond_to do |format|
      if @sense.save
        flash[:notice] = 'Sense was successfully created.'
        format.html { redirect_to(@sense) }
        format.xml  { render :xml => @sense, :status => :created, :location => @sense }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sense.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /senses/1
  # PUT /senses/1.xml
  def update
    @sense = Sense.find(params[:id])

    respond_to do |format|
      if @sense.update_attributes(params[:sense])
        flash[:notice] = 'Sense was successfully updated.'
        format.html { redirect_to(@sense) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sense.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /senses/1
  # DELETE /senses/1.xml
  def destroy
    @sense = Sense.find(params[:id])
    @sense.destroy

    respond_to do |format|
      format.html { redirect_to(senses_url) }
      format.xml  { head :ok }
    end
  end
end
