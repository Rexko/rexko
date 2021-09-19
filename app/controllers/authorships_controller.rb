class AuthorshipsController < ApplicationController
  layout '1col_layout'
  
  # GET /authorships
  # GET /authorships.xml
  def index
    @authorships = Authorship.
      includes(:author, :title, { :sources => :loci }).
      order(Author.arel_table[:name].asc).order(Title.arel_table[:name].asc).
      paginate(:page => params[:page]).
      references(:author, :title)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authorships }
    end
  end
  
  def matching
    @authorships = Authorship.matching(params[:value]).sort_by {|as| view_context.cited_name as, format: :text }
    @ref = params[:ref]
    
    respond_to do |format|
      format.js { render :partial => "autocomplete" }
    end
  end

  # GET /authorships/1
  # GET /authorships/1.xml
  def show
    @authorship = Authorship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @authorship }
    end
  end

  # GET /authorships/new
  # GET /authorships/new.xml
  def new
    @authorship = Authorship.new
    @authorship.build_author
    @authorship.build_title

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @authorship }
    end
  end

  # GET /authorships/1/edit
  def edit
    @authorship = Authorship.find(params[:id])
  end

  # POST /authorships
  # POST /authorships.xml
  def create
    @authorship = Authorship.new(params[:authorship].permit(allowed_params))

    respond_to do |format|
      if @authorship.save
        flash[:notice] = 'Authorship was successfully created.'
        format.html { redirect_to(@authorship) }
        format.xml  { render :xml => @authorship, :status => :created, :location => @authorship }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @authorship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /authorships/1
  # PUT /authorships/1.xml
  def update
    @authorship = Authorship.find(params[:id])

    respond_to do |format|
      if @authorship.update(params.fetch(:authorship, {}).permit(allowed_params))
        flash[:notice] = 'Authorship was successfully updated.'
        format.html { redirect_to(@authorship) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @authorship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /authorships/1
  # DELETE /authorships/1.xml
  def destroy
    @authorship = Authorship.find(params[:id])
    @authorship.destroy

    respond_to do |format|
      format.html { redirect_to(authorships_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def allowed_params
    Authorship.safe_params
  end
end
