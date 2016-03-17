class NotesController < ApplicationController
  def new
    @note = Note.new(params.slice(Note.new.attribute_names))
    @path = params[:path].sub(/(note.*)\[\d*\]/, "\\1[#{(Time.now.to_f * rand).to_i}]")
    @dictionaries = Dictionary.where(id: params[:dictionaries])
    @langs = Dictionary.langs_hash_for(@dictionaries)
    
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
