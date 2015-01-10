class ParsesController < ApplicationController
  # GET /parses
  # GET /parses.xml
  def index
    @parses = Parse.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @parses }
    end
  end

  # GET /parses/1
  # GET /parses/1.xml
  def show
    @parse = Parse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @parse }
    end
  end

  # GET /parses/new
  # GET /parses/new.xml
  def new
    @parse = Parse.new(params.slice(Parse.new.attribute_names))
    @path = params[:path].try(:sub, /(parse.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    @dictionaries = Dictionary.where(id: params[:dictionaries])
    @langs = Dictionary.langs_hash_for @dictionaries
    
    respond_to do |format|
      format.html do
      	if request.xhr?
          if params[:path].include? "locus"
            render :partial => "interlinear_form"
          else
            render :partial => "form"
          end 
      	end
      end
      format.xml  { render :xml => @parse }
    end
  end

  # GET /parses/1/edit
  def edit
    @parse = Parse.find(params[:id])
  end

  # POST /parses
  # POST /parses.xml
  def create
    @parse = Parse.new(params[:parse])

    respond_to do |format|
      if @parse.save
        flash[:notice] = 'Parse was successfully created.'
        format.html { redirect_to(@parse) }
        format.xml  { render :xml => @parse, :status => :created, :location => @parse }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @parse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /parses/1
  # PUT /parses/1.xml
  def update
    @parse = Parse.find(params[:id])

    respond_to do |format|
      if @parse.update_attributes(params[:parse])
        flash[:notice] = 'Parse was successfully updated.'
        format.html { redirect_to(@parse) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @parse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /parses/1
  # DELETE /parses/1.xml
  def destroy
    @parse = Parse.find(params[:id])
    @parse.destroy

    respond_to do |format|
      format.html { redirect_to(parses_url) }
      format.xml  { head :ok }
    end
  end
end
