class EtymologiesController < ApplicationController
  # GET /etymologies
  # GET /etymologies.xml
  def index
    @etymologies = Etymology.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @etymologies }
    end
  end

  # GET /etymologies/1
  # GET /etymologies/1.xml
  def show
    @etymology = Etymology.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @etymology }
    end
  end

  # GET /etymologies/new
  # GET /etymologies/new.xml
  def new
    @etymology = Etymology.new(params.slice(Etymology.new.attribute_names))
    if params[:path].include? "next_etymon"
    	@path = params[:path]
    else
     	pos = params[:path].rpartition(/(etymolog.*)\[\d*\]/)
    	pos[1].sub!(/\[\d*\]/, '['+Time.now.to_i.to_s+']')
    	@path = pos.join
    end
    
    respond_to do |format|
      format.html do
      	if request.xhr?
      		render :partial => "form"
      	end
      end
      format.xml  { render :xml => @etymology }
    end
  end

  # GET /etymologies/1/edit
  def edit
    @etymology = Etymology.find(params[:id])
  end

  # POST /etymologies
  # POST /etymologies.xml
  def create
    @etymology = Etymology.new(params[:etymology])

    respond_to do |format|
      if @etymology.save
        flash[:notice] = 'Etymology was successfully created.'
        format.html { redirect_to(@etymology) }
        format.xml  { render :xml => @etymology, :status => :created, :location => @etymology }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @etymology.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /etymologies/1
  # PUT /etymologies/1.xml
  def update
    @etymology = Etymology.find(params[:id])

    respond_to do |format|
      if @etymology.update_attributes(params[:etymology])
        flash[:notice] = 'Etymology was successfully updated.'
        format.html { redirect_to(@etymology) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @etymology.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /etymologies/1
  # DELETE /etymologies/1.xml
  def destroy
    @etymology = Etymology.find(params[:id])
    @etymology.destroy

    respond_to do |format|
      format.html { redirect_to(etymologies_url) }
      format.xml  { head :ok }
    end
  end
end
