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
      lang = elem.language.try(:iso_639_code) || 'und'
      memo ? if lang == memo then memo else break 'mul' end : lang
    end
    langtag += '-' + subtags[:variant] unless subtags[:variant].blank?
    "xml:lang=\"#{langtag}\" lang=\"#{langtag}\""
  end
    
  def headword_link (parse)
    parse.lookup_headword.nil? ? 
      link_to("<span #{'style=color:red' if parse == @wantedparse }>[No entry for <i>#{parse.parsed_form}</i> &times;#{Parse.count(:conditions => {:parsed_form => parse.parsed_form})}]</span>", :controller => 'lexemes', :action => 'new') :
      link_to(parse.parsed_form, parse.lookup_headword.lexeme)
  end
  
  def attr_trail *args
    # if 3
    # top level arg is "#{arg.to_s}[\#{@#{arg.to_s}.id}]"
    # mid level arg is "[#{arg.to_s}][\#{@#{arg.to_s}.id}]"
    # last arg is "[#{arg.to_s}][]"
    
    # if 2
    # top level arg is "#{arg.to_s}[\#{@#{arg.to_s}.id}]"
    # last arg is "[#{arg.to_s}][]"

    # if 1 (shouldn't be, but...)
    # last arg is "#{arg.to_s}[]"

    case args.size
    when 1 then return "#{args.first}[]"
    when 2 then return "#{args.last}[#{args.first}][]"
    else 
      outputtail = "[#{args.first}][]"
      args.delete args.first
      output = "#{args.last}"
      args.delete args.last
      for arg in args
        outputtail = "[#{arg}][#{instance_variable_get("@#{arg}").id}]" + outputtail
      end
      return "#{output + outputtail}"
    end unless true
    
    case args.size
    when 1 then return "#{args.first}"
    else 
      output = "#{args.last}"
      args.delete args.last
      for arg in args
        outputtail = "[#{arg}_attributes][#{instance_variable_get("@#{arg}").id}]" + outputtail
      end
      return "#{output + outputtail}"
    end
  end
  
  def sentence_case str
    returning str.dup do |x|
      x[0,1] = x[0,1].upcase
    end
  end
  
  def nested_attributes_for(form_builder, *args)  
    content_for :javascript do  
      content = ""  
      args.each do |association|  
        content << "\nvar #{association}_template='#{generate_template(form_builder, association.to_sym)}';"  
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
    escape_javascript generate_html(form_builder, method, options = {})  
  end
  
  def remove_link_unless_new_record(form_builder)  
    unless form_builder.object.new_record?  
      form_builder.check_box(:_delete) + form_builder.label(:_delete, 'Delete')  
    else  
      link_to("remove", "##{form_builder.object.class.name.underscore}", :class => 'remove')
    end  
  end
end