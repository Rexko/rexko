module ApplicationHelper
  include ERB::Util
  
	HW_LINK = "<span class='hw-link%s'>%s</span>"
	NO_ENTRY_TEXT = "[No entry for <i>%s</i> &times;%d]"

  # lang_for: Builds a string with lang= and xml:lang= attributes usable in an 
  # XHTML element.  Takes as argument an element or an array.
  #
  # Will return: 
  # * 'und' (ISO 639: 'undetermined') if no languages are found for
  #   any of the content
  # * 'mul' (ISO 639: 'multiple languages') if more than one 
  #   language is found in the array's content
  # * the language value of the content, if they are all of one language
  # 
  # May also take a hash of subtags. At the moment the only one specifically
  # handled is 'variant'.
  def lang_for content, subtags = {}
    langtag = Language.code_for content, subtags

    "xml:lang=\"#{h langtag}\" lang=\"#{h langtag}\"".html_safe
  end
    
  # Link to the first lexeme whose headword matches a given parse's parsed form.
  # Passes to #new_headword_link if no such lexeme.
  def headword_link (parse)
    is_wanted = parse == @wantedparse
    head = @headwords ? @headwords[parse.parsed_form] : Lexeme.lookup_by_headword(parse.parsed_form)
		head = head.respond_to?(:lexeme) ? head.lexeme : head

    if head
      link_to((HW_LINK % [(" wanted" if is_wanted), html_escape(parse.parsed_form)]).html_safe, head )
    else
      new_headword_link parse, is_wanted
    end
  end
  
  # Verbose link to create a new lexeme based on a headword, which lists how many
  # times that headword is attested in the loci
  def new_headword_link (parse, is_wanted = false)
  	count = parse.respond_to?(:count_all) ? parse.count_all : parse.count
  	no_entry = NO_ENTRY_TEXT % [html_escape(parse.parsed_form), count]
  
    link_to((HW_LINK % [(" wanted" if is_wanted), no_entry]).html_safe, 
    	exact_lexeme_path(:headword => parse.parsed_form))
  end
  
  def sentence_case str
    str.dup.tap do |x|
      x[0,1] = x[0,1].upcase
    end
  end
  
  def nested_attributes_for(form_builder, *args)  
    @nests ||= {}
    
    content_for :javascript do  
      content = ""  
      args.each do |association| 
        association = Array(association) 
        assoc_key = association.join('$')
        content << "\nvar #{assoc_key}_template='#{generate_template(form_builder, association[0].to_sym)}';" unless @nests[assoc_key] 
        @nests[assoc_key] = true
      end  
      content.html_safe
    end  
  end  

  def generate_html(form_builder, method, options = {})  
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new  
    options[:partial] ||= method.to_s.singularize  
    options[:form_builder_local] ||= :f  

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|  
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })  
    end
  end  

  def generate_template(form_builder, method, options = {})  
    escape_javascript generate_html(form_builder, method, options)  
  end
  
  def remove_link_unless_new_record(form_builder)  
    unless form_builder.object.try(:new_record?)
      "<span class=\"type-check\">%s</span>" % [form_builder.check_box(:_destroy) + " " +  form_builder.label(:_destroy, 'Delete', :class => 'delete_label')]
    else
      form_builder.hidden_field(:_destroy) + " " + link_to("(remove)", "##{form_builder.object.class.name.underscore}", :class => 'remove delete_label')
    end
  end
  
  def label_with_remove_option_for label_name = "Section", form_builder
  	label = "%s &nbsp; %s" % [sanitize(label_name), remove_link_unless_new_record(form_builder)]
  	label.html_safe
	end

	# options[:class_name] - if the class is different, i.e. next_etymon is an Etymology
	# options[:limit_one] - if it is a has_one or belongs_to situation
	# options[:list_if] - only list children if true; if false just give addlink
	# options[:create_blank] - add a blank child to the list
	# options[:remote] - use AJAX
	def list_children_with_option_to_add child, form, options = {}
		class_name = (options[:class_name] || child).to_s
		child_or_children = options[:limit_one] ? form.object.send(child) : form.object.send(child.to_s.pluralize)
		had_child = child_or_children.present?
		subform_ref = ""
		printed_child = nil

    # Have to have a child to get the subform. We're only keeping it if options[:create_blank]
		unless had_child
			new_child = (options[:limit_one] ? form.object.send("build_%s" % child) : child_or_children.build) if child_or_children.blank? 
			instance_variable_set("@#{child}", new_child || child_or_children)
			created_blank = true
		end	

		child_ref = options[:limit_one] ? child : child.to_s.pluralize		
		output = form.fields_for(child_ref) do |subform|
			subform_ref = subform.object_name
      printed_child = if (options[:list_if].blank? || options[:list_if]) && (had_child || options[:create_blank])
				render :partial => class_name, :locals => { :f => subform } 
			end
		end
		
		output ||= "".html_safe
		
		link_class = [(options[:remote] ? "pull_nested" : "add_nested"), ("limit-one" if options[:limit_one])]
		
		link_path_options = { :path => subform_ref, child => form.object } 
		link_path = options[:remote] ? send('new_%s_path' % class_name, link_path_options) : "#%s" % child_ref
		
		link_options = { :class => link_class, :rel => (addlink_rel(subform_ref) unless subform_ref.blank?) }
		link_options[:remote] = true if options[:remote]
		
		unless options[:limit_one] && printed_child.present? 
	  	output << content_tag(:div, :class => "par") do
	  		link_to "Add %s" % child.to_s.humanize.downcase, link_path, link_options
	  	end 
	  end
	  
		output
	end
	
	# The rel attribute for the add links. Used by the JS to determine where things go.
	# This may be needlessly byzantine and there is probably a way to simplify the system.
	def addlink_rel child_ref
		# input is like:
		# locus[attestations_attributes][2][parses_attributes][0][interpretations_attributes][0]
		# output should be like:
		# [attestation][parses][interpretations]
		elements = child_ref.gsub(/\[(\d+|NEW_RECORD)\]/, '').scan(/\[(.*?)_attributes\]/).flatten
		elements[0] = elements.first.singularize
		elements.collect {|el| "[%s]" % el }.join
	end
  
  def spaced_render(options = {})
    coll = options[:collection].collect do |item|
      render :partial => options[:partial], :object => item, :locals => options[:locals]
    end
    
    sanitize(coll.to_sentence({
      :words_connector => options[:spacer] || ", ",
      :last_word_connector => options[:last_spacer] || options[:spacer] || ", ",
      :two_words_connector => options[:dual_spacer] || options[:spacer] || ", "
    }))
  end
  
  # Create a <li> link suitable for the navbar, unless we are already on the page.
  # Modified form of #link_to_unless.
  def navlink_unless_current name, options = {}, html_options = {}, &block
    output = if current_page?(options)
      "<li class=\"active\"><strong>%s</strong></li>" % [
        if block_given?
          block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options_ & block)
        else
          name
        end
      ]
    else
      "<li>%s</li>" % [link_to(name, options, html_options)]
    end
    
    sanitize(output)
  end
  
  # Return @page_title, or a default of "Controller -  action".
  def page_title
    html_escape (@page_title || [params[:controller].camelize, params[:action]].join(" - "))
  end
  
  # Translate a string in wiki format into HTML
  def wh text, highlight = []
    output = html_escape(text).to_str
    output.gsub!(/&\#x27;&\#x27;&\#x27;(.+?)&\#x27;&\#x27;&\#x27;/, '<b>\1</b>')
    output.gsub!(/&\#x27;&\#x27;(.+?)&\#x27;&\#x27;/, '<i>\1</i>')
    output.gsub!(/\[\[([^|]+?)\]\](\w*)/) do |match|
      bold = highlight.include?($1)
      '<a href="/html/%{lexeme}" title="%{lexeme}">%{bb}%{lexeme}%{ending}%{eb}</a>' % { :lexeme => $1, :ending => $2, :bb => ('<b>' if bold), :eb => ('</b>' if bold) }
    end
    output.gsub!(/\[\[(.+?)\|(.+?)\]\](\w*)/) do |match|
      bold = highlight.include?($1)
      '<a href="/html/%{lexeme}" title="%{lexeme}">%{bb}%{stem}%{ending}%{eb}</a>' % { :lexeme => $1, :stem => $2, :ending => $3, :bb => ('<b>' if bold), :eb => ('</b>' if bold) }
    end
    output.html_safe
  end  
end
