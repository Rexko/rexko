module EtymologiesHelper
  def html_format etym, parent = nil
    language = content_tag :span, :class => "lexform-source-language" do
      html_escape(etym.source_language || '<Unknown source>') 
    end unless parent && parent.source_language == etym.source_language
    
    etymon = content_tag :span, :class => "lexform-etymon" do
      wh(etym.etymon || '<Unknown etymon>')
    end
    
    gloss = content_tag :span, :class => "lexform-etymon-gloss" do
      html_escape(etym.gloss || '<Unknown gloss>')
    end
  
    next_etym = html_format(etym.next_etymon, etym) if etym.next_etymon
    
    pre_note = [language, etymon, gloss, next_etym].compact.join(" ") 
    pre_note = pre_note << "." unless etym.next_etymon
    pre_note = "+ " << pre_note if parent
        
    notes = etym.notes.collect do |note|
       "<span class=\"lexform-note\" #{lang_for(note)}>#{wh note.content}</span>"
    end
    notes = notes.join(" ") 
    notes = notes.blank? ? nil : notes
    
    [pre_note, notes].compact.join(" ")
  end
  
  def wiki_format etym, parent = nil
    language = html_escape(etym.source_language || '<Unknown source>') unless
      parent && parent.source_language == etym.source_language
    
    etymon = html_escape(etym.etymon || '<Unknown etymon>')
    
    gloss = html_escape('"' << etym.gloss << '"' || '<Unknown gloss>')
  
    next_etym = wiki_format(etym.next_etymon, etym) if etym.next_etymon
    
    pre_note = [language, etymon, gloss, next_etym].compact.join(" ") 
    pre_note = pre_note << "." unless etym.next_etymon
    pre_note = "+ " << pre_note if parent
        
    notes = etym.notes.collect(&:content).join(" ") 
    notes = notes.blank? ? nil : notes
    
    [pre_note, notes].compact.join(" ")
  end
end
