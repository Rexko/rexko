class SortOrdersController < ApplicationController
  def new
    @sort_order = SortOrder.build_from_only_valid(params)
    @path = params[:path].try(:sub, /(sort_order.*)\[\d*\]/, '\1['+Time.now.to_i.to_s+']')
    @locale_name = Language.where(iso_639_code: I18n.locale).first.name
    
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
