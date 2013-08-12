class SortOrdersController < ApplicationController
  def new
    @sort_order = SortOrder.new(params.slice(SortOrder.new.attribute_names))
    @path = params[:path].try(:sub, /(sort_order.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    
    respond_to do |format|
      format.html do
      	if request.xhr?
      		render :partial => "form"
      	end
      end
      format.xml  { render :xml => @parse }
    end
  end
end
