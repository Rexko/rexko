class GlossesController < ApplicationController
  # GET /glosses
  # GET /glosses.xml
  def index
    @glosses = Gloss.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @glosses }
    end
  end

  # GET /glosses/1
  # GET /glosses/1.xml
  def show
    @gloss = Gloss.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gloss }
    end
  end

  # GET /glosses/new
  # GET /glosses/new.xml
  def new
    @gloss = Gloss.new(params.slice(Gloss.new.attribute_names))
    @path = params[:path].try(:sub, /(gloss.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    @dictionaries = Dictionary.where(id: params[:dictionaries]).all
    @langs = Dictionary.langs_hash_for(@dictionaries)
    
    respond_to do |format|
      format.html do
      	if request.xhr?
      		render :partial => "form"
      	end
      end
      format.xml  { render :xml => @gloss }
    end
  end

  # GET /glosses/1/edit
  def edit
    @gloss = Gloss.find(params[:id])
  end

  # POST /glosses
  # POST /glosses.xml
  def create
    @gloss = Gloss.new(params[:gloss])

    respond_to do |format|
      if @gloss.save
        flash[:notice] = 'Gloss was successfully created.'
        format.html { redirect_to(@gloss) }
        format.xml  { render :xml => @gloss, :status => :created, :location => @gloss }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gloss.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /glosses/1
  # PUT /glosses/1.xml
  def update
    @gloss = Gloss.find(params[:id])

    respond_to do |format|
      if @gloss.update_attributes(params[:gloss])
        flash[:notice] = 'Gloss was successfully updated.'
        format.html { redirect_to(@gloss) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gloss.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /glosses/1
  # DELETE /glosses/1.xml
  def destroy
    @gloss = Gloss.find(params[:id])
    @gloss.destroy

    respond_to do |format|
      format.html { redirect_to(glosses_url) }
      format.xml  { head :ok }
    end
  end
end
