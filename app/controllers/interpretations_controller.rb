class InterpretationsController < ApplicationController
  # GET /interpretations
  # GET /interpretations.xml
  def index
    @interpretations = Interpretation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interpretations }
    end
  end

  # GET /interpretations/1
  # GET /interpretations/1.xml
  def show
    @interpretation = Interpretation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interpretation }
    end
  end

  # GET /interpretations/new
  # GET /interpretations/new.xml
  def new
    @interpretation = Interpretation.new
    if params[:live_value].present? 
	    @interpretation.build_parse(:parsed_form => params[:live_value])
	  elsif params[:parse].present?
			@interpretation.parse = Parse.find(params[:parse])
		end
    @path = params[:path].sub(/(interpretation.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    
    respond_to do |format|
      format.html do
      	if request.xhr?
      		render :partial => "form"
      	end
      end
      format.xml  { render :xml => @interpretation }
    end
  end

  # GET /interpretations/1/edit
  def edit
    @interpretation = Interpretation.find(params[:id])
  end

  # POST /interpretations
  # POST /interpretations.xml
  def create
    @interpretation = Interpretation.new(params[:interpretation])

    respond_to do |format|
      if @interpretation.save
        flash[:notice] = 'Interpretation was successfully created.'
        format.html { redirect_to(@interpretation) }
        format.xml  { render :xml => @interpretation, :status => :created, :location => @interpretation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interpretation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interpretations/1
  # PUT /interpretations/1.xml
  def update
    @interpretation = Interpretation.find(params[:id])

    respond_to do |format|
      if @interpretation.update_attributes(params[:interpretation])
        flash[:notice] = 'Interpretation was successfully updated.'
        format.html { redirect_to(@interpretation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interpretation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interpretations/1
  # DELETE /interpretations/1.xml
  def destroy
    @interpretation = Interpretation.find(params[:id])
    @interpretation.destroy

    respond_to do |format|
      format.html { redirect_to(interpretations_url) }
      format.xml  { head :ok }
    end
  end
end
