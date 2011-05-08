class OrthographsController < ApplicationController
  # GET /orthographs
  # GET /orthographs.xml
  def index
    @orthographs = Orthograph.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orthographs }
    end
  end

  # GET /orthographs/1
  # GET /orthographs/1.xml
  def show
    @orthograph = Orthograph.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @orthograph }
    end
  end

  # GET /orthographs/new
  # GET /orthographs/new.xml
  def new
    @orthograph = Orthograph.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @orthograph }
    end
  end

  # GET /orthographs/1/edit
  def edit
    @orthograph = Orthograph.find(params[:id])
  end

  # POST /orthographs
  # POST /orthographs.xml
  def create
    @orthograph = Orthograph.new(params[:orthograph])

    respond_to do |format|
      if @orthograph.save
        flash[:notice] = 'Orthograph was successfully created.'
        format.html { redirect_to(@orthograph) }
        format.xml  { render :xml => @orthograph, :status => :created, :location => @orthograph }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @orthograph.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orthographs/1
  # PUT /orthographs/1.xml
  def update
    @orthograph = Orthograph.find(params[:id])

    respond_to do |format|
      if @orthograph.update_attributes(params[:orthograph])
        flash[:notice] = 'Orthograph was successfully updated.'
        format.html { redirect_to(@orthograph) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @orthograph.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orthographs/1
  # DELETE /orthographs/1.xml
  def destroy
    @orthograph = Orthograph.find(params[:id])
    @orthograph.destroy

    respond_to do |format|
      format.html { redirect_to(orthographs_url) }
      format.xml  { head :ok }
    end
  end
end
