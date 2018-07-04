class DictionaryScopesController < ApplicationController
  # GET /dictionary_scopes
  # GET /dictionary_scopes.xml
  def index
    @dictionary_scopes = DictionaryScope.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dictionary_scopes }
    end
  end

  # GET /dictionary_scopes/1
  # GET /dictionary_scopes/1.xml
  def show
    @dictionary_scope = DictionaryScope.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dictionary_scope }
    end
  end

  # GET /dictionary_scopes/new
  # GET /dictionary_scopes/new.xml
  def new
    @dictionary_scope = DictionaryScope.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dictionary_scope }
    end
  end

  # GET /dictionary_scopes/1/edit
  def edit
    @dictionary_scope = DictionaryScope.find(params[:id])
  end

  # POST /dictionary_scopes
  # POST /dictionary_scopes.xml
  def create
    @dictionary_scope = DictionaryScope.new(params[:dictionary_scope].permit(allowed_params))

    respond_to do |format|
      if @dictionary_scope.save
        flash[:notice] = 'DictionaryScope was successfully created.'
        format.html { redirect_to(@dictionary_scope) }
        format.xml  { render :xml => @dictionary_scope, :status => :created, :location => @dictionary_scope }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dictionary_scope.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dictionary_scopes/1
  # PUT /dictionary_scopes/1.xml
  def update
    @dictionary_scope = DictionaryScope.find(params[:id])

    respond_to do |format|
      if @dictionary_scope.update_attributes(params.fetch(:dictionary_scope, {}))
        flash[:notice] = 'DictionaryScope was successfully updated.'
        format.html { redirect_to(@dictionary_scope) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dictionary_scope.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dictionary_scopes/1
  # DELETE /dictionary_scopes/1.xml
  def destroy
    @dictionary_scope = DictionaryScope.find(params[:id])
    @dictionary_scope.destroy

    respond_to do |format|
      format.html { redirect_to(dictionary_scopes_url) }
      format.xml  { head :ok }
    end
  end

  private
  def allowed_params
    DictionaryScope.safe_params
  end
end
