class AttestationsController < ApplicationController
  # GET /attestations
  # GET /attestations.xml
  def index
    @attestations = Attestation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @attestations }
    end
  end

  # GET /attestations/1
  # GET /attestations/1.xml
  def show
    @attestation = Attestation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @attestation }
    end
  end

  # GET /attestations/new
  # GET /attestations/new.xml
  def new
    @attestation = Attestation.build_from_only_valid(params)
    @path = params.fetch(:path, '').sub(/(attestation.*)\[\d*\]/,
                                        "\\1[#{Time.now.to_i}]")

    respond_to do |format|
      format.html do
        render partial: 'form' if request.xhr?
      end
      format.xml { render xml: @attestation }
    end
  end

  # GET /attestations/1/edit
  def edit
    @attestation = Attestation.find(params[:id])
  end

  # POST /attestations
  # POST /attestations.xml
  def create
    @attestation = Attestation.new(params[:attestation].permit(allowed_params))

    respond_to do |format|
      if @attestation.save
        flash[:notice] = 'Attestation was successfully created.'
        format.html { redirect_to(@attestation) }
        format.xml do
          render xml: @attestation, status: :created, location: @attestation
        end
      else
        format.html { render action: 'new' }
        format.xml do
          render xml: @attestation.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PUT /attestations/1
  # PUT /attestations/1.xml
  def update
    @attestation = Attestation.find(params[:id])

    respond_to do |format|
      if @attestation.update(params.fetch(:attestation, {}))
        flash[:notice] = 'Attestation was successfully updated.'
        format.html { redirect_to(@attestation) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml do
          render xml: @attestation.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /attestations/1
  # DELETE /attestations/1.xml
  def destroy
    @attestation = Attestation.find(params[:id])
    @attestation.destroy

    respond_to do |format|
      format.html { redirect_to(attestations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def allowed_params
    Attestation.safe_params
  end
end
