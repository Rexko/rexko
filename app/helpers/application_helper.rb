# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def lang_for languable, subtags = {}
    if (languable.is_a? Array)
      langset = languable.each {|lb| lb.language if lb.language}.compact.uniq
      case langset.size
      when 0: langtag = "und"
      when 1: langtag = langset[0]
      else langtag = "mul"
      end
    else
      langtag = languable.try(:language) || "und"
    end
    langtag += "-" + subtags[:variant] unless subtags[:variant].nil?
    "lang=\"#{langtag}\""
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