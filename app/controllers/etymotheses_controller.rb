class EtymothesesController < ApplicationController
  # GET /etymotheses
  # GET /etymotheses.xml
  def index
    @etymotheses = Etymothesis.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @etymotheses }
    end
  end

  # GET /etymotheses/1
  # GET /etymotheses/1.xml
  def show
    @etymothesis = Etymothesis.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @etymothesis }
    end
  end

  # GET /etymotheses/new
  # GET /etymotheses/new.xml
  def new
    @etymothesis = Etymothesis.new(params.slice(Etymothesis.new.attribute_names))
    @etymothesis.build_etymology
    @path = params[:path].sub(/(subentr.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')

    respond_to do |format|
      format.html do
      	if request.xhr?
          render :partial => "form"
      	end
      end
      format.xml  { render :xml => @etymothesis }
    end
  end

  # GET /etymotheses/1/edit
  def edit
    @etymothesis = Etymothesis.find(params[:id])
  end

  # POST /etymotheses
  # POST /etymotheses.xml
  def create
    @etymothesis = Etymothesis.new(params[:etymothesis])

    respond_to do |format|
      if @etymothesis.save
        flash[:notice] = 'Etymothesis was successfully created.'
        format.html { redirect_to(@etymothesis) }
        format.xml  { render :xml => @etymothesis, :status => :created, :location => @etymothesis }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @etymothesis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /etymotheses/1
  # PUT /etymotheses/1.xml
  def update
    @etymothesis = Etymothesis.find(params[:id])

    respond_to do |format|
      if @etymothesis.update_attributes(params[:etymothesis])
        flash[:notice] = 'Etymothesis was successfully updated.'
        format.html { redirect_to(@etymothesis) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @etymothesis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /etymotheses/1
  # DELETE /etymotheses/1.xml
  def destroy
    @etymothesis = Etymothesis.find(params[:id])
    @etymothesis.destroy

    respond_to do |format|
      format.html { redirect_to(etymotheses_url) }
      format.xml  { head :ok }
    end
  end
end
