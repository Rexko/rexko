class ParsableController < ApplicationController
  layout '1col_layout'

  def index
  	forms = Parse.forms_of(Parse.uninterpreted.first)
  	@parsables = Parse.unattached_to(forms).paginate(:page => params[:page], :per_page => 5)
  	@page_title = "Unattached to %s" % forms.to_sentence
  end

end
