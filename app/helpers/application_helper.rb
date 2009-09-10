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
    "xml:lang=\"#{html_escape langtag}\" lang=\"#{html_escape langtag}\""
  end
    
  def headword_link (parse)
    is_wanted = parse == @wantedparse
    headword = parse.lookup_headword

    link_to("%s%s#{html_escape parse.parsed_form}%s%s" % [
      ("<span 'style=color:red'>" if is_wanted),
      ("[No entry for <i>" unless headword),
      ("</i> &times;#{parse.count}]" unless headword),
      ("</span>" if is_wanted) 
    ], headword.try(:lexeme) || {:controller => 'lexemes', :action => 'new'})
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
    escape_javascript generate_html(form_builder, method, options)  
  end
  
  def remove_link_unless_new_record(form_builder)  
    unless form_builder.object.new_record?  
      form_builder.check_box(:_delete) + form_builder.label(:_delete, 'Delete')  
    else  
      link_to("remove", "##{form_builder.object.class.name.underscore}", :class => 'remove')
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
end