module ApplicationHelper
  include ERB::Util
  
	HW_LINK = "<span class='hw-link%s'>%s</span>"

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
    is_wanted = parse.try(:parsed_form) == @wantedparse.try(:parsed_form)
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
  	no_entry = t('lexeme.no_entry_linktext', headword: html_escape(parse.parsed_form), count: count)
  
    link_to((HW_LINK % [(" wanted" if is_wanted), no_entry]).html_safe, 
    	exact_lexeme_path(:headword => parse.parsed_form))
  end
  
  def sentence_case str
    str.dup.tap do |x|
      x[0,1] = x[0,1].mb_chars.upcase
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
      "<span class=\"type-check\">#{form_builder.check_box(:_destroy)} #{form_builder.label(:_destroy, t("helpers.delete_checkbox"), :class => 'delete_label')}</span>"
    else
      "#{form_builder.hidden_field(:_destroy)} #{link_to(t("helpers.remove_link"), "##{form_builder.object.class.name.underscore}", :class => 'remove delete_label')}"
    end
  end
  
  def label_with_remove_option_for label_name = "Section", form_builder
  	"#{sanitize(label_name)} &nbsp; #{remove_link_unless_new_record(form_builder)}".html_safe
	end

	# options[:class_name] - if the class is different, i.e. next_etymon is an Etymology
	# options[:limit_one] - if it is a has_one or belongs_to situation
	# options[:list_if] - only list children if true; if false just give addlink
	# options[:create_blank] - add a blank child to the list
	# options[:remote] - use AJAX
	# options[:locals] - pass variables to partial
  # options[:display_name] - what to put in the "Add _____" link (default is child)
	def list_children_with_option_to_add child, form, options = {}
		class_name = (options[:class_name] || child).to_s
		child_or_children = options[:limit_one] ? form.object.send(child) : form.object.send(child.to_s.pluralize)
		had_child = child_or_children.present?
		subform_ref = ""
		printed_child = nil

    # Have to have a child to get the subform. We're only keeping it if options[:create_blank]
		unless had_child
			new_child = (options[:limit_one] ? form.object.send("build_#{child}") : child_or_children.build) if child_or_children.blank? 
			instance_variable_set("@#{child}", new_child || child_or_children)
			created_blank = true
		end	

		child_ref = options[:limit_one] ? child : child.to_s.pluralize		
		output = form.fields_for(child_ref) do |subform|
			subform_ref = subform.object_name
      printed_child = if (options[:list_if].blank? || options[:list_if]) && (had_child || options[:create_blank])
        locals = { :f => subform }
        locals.update(options[:locals]) if options[:locals]
				render :partial => class_name, :locals => locals
			end
		end
		
		output ||= "".html_safe
		
		link_class = [(options[:remote] ? "pull_nested" : "add_nested"), ("limit-one" if options[:limit_one])]
		
		link_path_options = { :path => subform_ref, child => form.object }.merge(options[:locals] || {})
		link_path = options[:remote] ? send("new_#{class_name}_path", link_path_options) : "##{child_ref}"
		
		link_options = { :class => link_class, :rel => (addlink_rel(subform_ref) unless subform_ref.blank?) }
		link_options[:remote] = true if options[:remote]
		
		unless options[:limit_one] && printed_child.present? 
	  	output << content_tag(:div, :class => "par") do
        addendum = options[:display_name] || child.to_s.humanize.downcase
	  		link_to t("helpers.link_to_add.#{addendum}", default: "Add #{addendum}"), link_path, link_options
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
		elements.collect {|el| "[#{el}]" }.join
	end
  
  def spaced_render(options = {})
    coll = options[:collection].collect do |item|
      render :partial => options[:partial], :object => item, :locals => options[:locals]
    end
    
    sanitize(coll.to_sentence({
      :words_connector => options[:spacer] || t('helpers.spaced_render.words_connector', default: ", "),
      :last_word_connector => options[:last_spacer] || options[:spacer] || t('helpers.spaced_render.last_word_connector', default: ", "),
      :two_words_connector => options[:dual_spacer] || options[:spacer] || t('helpers.spaced_render.two_words_connector', default: ", ")
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
      "<li>#{link_to(name, options, html_options)}</li>"
    end
    
    sanitize(output)
  end
  
  # Return @page_title, or a default of "Controller -  action".
  def page_title
    html_escape (@page_title || I18n.t("#{params[:controller]}.#{params[:action]}.page title"))
  end
  
  # Translate a string in wiki format into HTML
  def wh text, highlight = []
    output = html_escape(text).to_str
    output.gsub!(/&\#x27;&\#x27;&\#x27;(.+?)&\#x27;&\#x27;&\#x27;/, '<b>\1</b>')
    output.gsub!(/&\#x27;&\#x27;(.+?)&\#x27;&\#x27;/, '<i>\1</i>')
    output.gsub!(/\[\[(?<lexeme>[^|]+?)\]\](?<ending>\w*)|\[\[(?<lexeme>.+?)\|(?<stem>.+?)\]\](?<ending>\w*)/).with_index do |match, index|
      bold = highlight.include?($~[:lexeme])
      bb, eb = ('<b>' if bold), ('</b>' if bold)
      parse = yield $~[:lexeme], index if block_given?
      parse = "" << ":"" #{parse}" if parse.present?
      "<a href=\"/#{I18n.locale}/html/#{$~[:lexeme]}\" title=\"#{$~[:lexeme]}#{parse}\">#{bb}#{$~[:stem] || $~[:lexeme]}#{$~[:ending]}#{eb}</a>"
    end
    output.html_safe 
  end
  
  # Generate an autocomplete text field for +child+ in +form+.
  # +options[:custom_search]+ - what will be shown in the search field (if different from #name)
  # +options[:prompt]+        - placeholder text of empty search field
  # +options[:as]+            - class, if differs from attribute name
  def autocomplete child, form, options = {}
    child_obj = form.object.send(child).present? ? form.object.send(child) : form.object.send("build_#{child}")
    klass = (options[:as] || child).to_s
    
    form.fields_for child, child_obj do |child_form|
      ref = child_form.object_name
      
      label_tag("#{ref}_search", t("activerecord.models.#{child}")) <<
    
      if options[:custom_search]
        text_field_tag(:search, options[:custom_search], id: "#{ref}_search", placeholder: options[:prompt])
      else
        child_form.text_field(:name, id: "#{ref}_search", placeholder: options[:prompt]) 
      end <<
      
      content_tag(:span, id: "#{ref}-search-indicator", style: "display: none") do
        tag :img, src: asset_path('icons/throbber.gif'), style: "vertical-align:middle", width: 16, height: 16
      end <<

      child_form.hidden_field(:id, id: "#{ref}_id") <<
      
      content_tag(:div, nil, id: "#{ref}_choices", class: 'autocomplete', data: { ref: ref, plural: klass.pluralize }) <<

      content_tag(:div, id: "#{ref}_new", style: "display: none") do
        render partial: "#{klass.pluralize}/form", locals: { "#{klass}_form".to_sym => child_form } 
      end
    end
  end
  
  # Editing multiple languages - tabs to indicate the current language being worked on.
  # languages = an array of language names.
  def language_tabs languages
    languages = [*languages]
    
    content_tag(:div, class: "language-list") do
      content_tag(:ul) do
        languages.each_with_index do |lang, index|
          concat(content_tag(:li, {class: [("selected" if index == 0), ("solo" if languages.length == 1), ("default" if lang == Language::DEFAULT)]}) {
            h lang
            })
        end
      end
    end
  end
  
  def translatable_tag form, field, attribute, languages = [], html_options = {}
    content_tag(:div, {class: "translatable", data: { languages: languages }}) do
      default_locale = I18n.default_locale.to_s
      languages = @langs ? [*@langs[languages]] : []
    
      # we should add default if it exists and isn't listed (the fallback 
      # for legacy users whose data isn't in the right translation)
      if (form.object.send("#{attribute}_#{default_locale.underscore}").present? && !languages.collect(&:iso_639_code).include?(default_locale)) 
        languages = [Language::DEFAULT] | languages
      end
    
      output = ActiveSupport::SafeBuffer.new
    
      output << content_tag(:div, class: "language-content") do
        languages.each do |lang|
          code = lang.iso_639_code
          html_options[:data] = (html_options[:data] || {}).merge(language: code.underscore)
          Globalize.with_locale(code) do
            concat(form.send(field, "#{attribute}_#{code.underscore}", html_options))
          end if form.object.respond_to? "#{attribute}_#{code.underscore}"
        end
      end
    
      output << language_tabs(languages)
    end
  end 
  
  # Given a Language and a block, return the contents of that block globalized 
  # appropriately for the Language.
  def source lang = (@langs[:source].first if @langs), &block
    Globalize.with_locale(lang.try(:iso_639_code)) do
      yield
    end
  end
end
