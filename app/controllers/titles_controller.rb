# frozen_string_literal: true

class TitlesController < ApplicationController
  layout '1col_layout'
  # GET /titles
  # GET /titles.xml
  def index
    @titles = Title.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @titles }
    end
  end

  def matching
    @titles = Title.where(Title.arel_table[:name].matches("%#{params[:value]}%")).order(:name)
    @ref = params[:ref]

    respond_to do |format|
      format.js { render partial: 'autocomplete' }
    end
  end

  # GET /titles/1
  # GET /titles/1.xml
  def show
    @title = Title.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @title }
    end
  end

  # GET /titles/new
  # GET /titles/new.xml
  def new
    @title = Title.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @title }
    end
  end

  # GET /titles/1/edit
  def edit
    @title = Title.find(params[:id])
  end

  # POST /titles
  # POST /titles.xml
  def create
    @title = Title.new(params[:title])

    respond_to do |format|
      if @title.save
        flash[:notice] = 'Title was successfully created.'
        format.html { redirect_to(@title) }
        format.xml  { render xml: @title, status: :created, location: @title }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @title.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /titles/1
  # PUT /titles/1.xml
  def update
    @title = Title.find(params[:id])

    respond_to do |format|
      if @title.update(params.fetch(:title, {}))
        flash[:notice] = 'Title was successfully updated.'
        format.html { redirect_to(@title) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @title.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /titles/1
  # DELETE /titles/1.xml
  def destroy
    @title = Title.find(params[:id])
    @title.destroy

    respond_to do |format|
      format.html { redirect_to(titles_url) }
      format.xml  { head :ok }
    end
  end
end
