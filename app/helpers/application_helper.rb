# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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
    langtag = [*content].inject(nil) do |memo, elem| 
      lang = elem ? elem.language.try(:iso_639_code) || 'und' : 'zxx'
      memo ? if lang == memo then memo else break 'mul' end : lang
    end
    langtag += '-' + subtags[:variant] unless subtags[:variant].blank?
    "xml:lang=\"#{html_escape langtag}\" lang=\"#{html_escape langtag}\""
  end
    
  def headword_link (parse)
    is_wanted = parse == @wantedparse
    headword = @headwords ? @headwords[parse.parsed_form] : parse.lookup_headword

    if headword
      link_to("<span class='hw-link%s'>#{html_escape parse.parsed_form}</span>" % [
        (" wanted" if is_wanted),
      ], headword.lexeme)
    else
      new_headword_link parse, is_wanted
    end
  end
  
  def new_headword_link (parse, is_wanted = false)
    link_to("<span class='hw-link%s'>[No entry for <i>#{html_escape parse.parsed_form}</i> &times;#{parse.respond_to?(:count_all) ? parse.count_all : parse.count}]</span>" % [
      (" wanted" if is_wanted),
    ], exact_lexeme_path(:headword => parse.parsed_form))
  end
  
  def sentence_case str
    returning str.dup do |x|
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
      content  
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
      "<span class=\"type-check\">%s</span>" % [form_builder.check_box(:_delete) + " " +  form_builder.label(:_delete, 'Delete', :class => 'delete_label')]
    else  
      form_builder.hidden_field(:_delete) + " " + link_to("(remove)", "##{form_builder.object.class.name.underscore}", :class => 'remove delete_label')
    end  
  end
  
  def spaced_render(options = {})
    coll = options[:collection].collect do |item|
      render :partial => options[:partial], :object => item, :locals => options[:locals]
    end
    
    coll.to_sentence({
      :words_connector => options[:spacer] || ", ",
      :last_word_connector => options[:last_spacer] || options[:spacer] || ", ",
      :two_words_connector => options[:dual_spacer] || options[:spacer] || ", "
    })
  end
  
  # Create a <li> link suitable for the navbar, unless we are already on the page.
  # Modified form of #link_to_unless.
  def navlink_unless_current name, options = {}, html_options = {}, &block
    if current_page?(options)
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
  end
  
  # Return @page_title, or a default of "Controller -  action".
  def page_title
    html_escape (@page_title || [params[:controller].camelize, params[:action]].join(" - "))
  end
  
  # Translate a string in wiki format into HTML
  def wh text
    output = html_escape(text)
    output.gsub!(/'''(.+?)'''/, '<b>\1</b>')
    output.gsub!(/''(.+?)''/, '<i>\1</i>')
    output.gsub!(/\[\[([^|]+?)\]\](\w*)/, '<a href="/html/\1">\1\2</a>')
    output.gsub(/\[\[(.+?)\|(.+?)\]\](\w*)/, '<a href="/html/\1">\2\3</a>')    
  end
end