class NotesController < ApplicationController
  def new
    @note = Note.new(params.slice(Note.new.attribute_names))
    @path = params[:path].sub(/(attestation.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    
    respond_to do |format|
      format.html do
      	if request.xhr?
      		render :partial => "form"
      	end
      end
      format.xml  { render :xml => @note }
    end
  end
end
