# frozen_string_literal: true

class AuthorsController < ApplicationController
  layout '1col_layout'
  # GET /authors
  # GET /authors.xml
  def index
    @authors = Author.all.sort_by { |a| a.sort_key.present? ? a.sort_key : a.name }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @authors }
    end
  end

  def matching
    @authors = Author.where(Author.arel_table[:name].matches("%#{params[:value]}%")).order(:name)
    @ref = params[:ref]

    respond_to do |format|
      format.js { render partial: 'autocomplete' }
    end
  end

  # GET /authors/1
  # GET /authors/1.xml
  def show
    @author = Author.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @author }
    end
  end

  # GET /authors/new
  # GET /authors/new.xml
  def new
    @author = Author.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @author }
    end
  end

  # GET /authors/1/edit
  def edit
    @author = Author.find(params[:id])
  end

  # POST /authors
  # POST /authors.xml
  def create
    @author = Author.new(params[:author])

    respond_to do |format|
      if @author.save
        flash[:notice] = 'Author was successfully created.'
        format.html { redirect_to(@author) }
        format.xml  { render xml: @author, status: :created, location: @author }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /authors/1
  # PUT /authors/1.xml
  def update
    @author = Author.find(params[:id])

    respond_to do |format|
      if @author.update(params.fetch(:author, {}))
        flash[:notice] = 'Author was successfully updated.'
        format.html { redirect_to(@author) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.xml
  def destroy
    @author = Author.find(params[:id])
    @author.destroy

    respond_to do |format|
      format.html { redirect_to(authors_url) }
      format.xml  { head :ok }
    end
  end
end
