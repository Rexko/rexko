module EtymologiesHelper
  def html_format etym, parent = nil
    language = content_tag :span, :class => "lexform-source-language" do
      html_escape etym.original_language.name
    end if etym.original_language unless
      parent && parent.original_language == etym.original_language
    
    etymon = content_tag :span, :class => "lexform-etymon" do
      wh etym.etymon
    end
    
    gloss = content_tag :span, :class => "lexform-etymon-gloss" do
      html_escape etym.primary_gloss
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
    language = html_escape(etym.original_language.name) if 
      etym.original_language unless
      parent && parent.original_language == etym.original_language
    
    etymon = html_escape etym.etymon
    
    gloss = html_escape('"' << etym.primary_gloss << '"') if etym.primary_gloss
  
    next_etym = wiki_format(etym.next_etymon, etym) if etym.next_etymon
    
    pre_note = [language, etymon, gloss, next_etym].compact.join(" ") 
    pre_note = pre_note << "." unless etym.next_etymon
    pre_note = "+ " << pre_note if parent
        
    notes = etym.notes.collect(&:content).join(" ") 
    notes = notes.blank? ? nil : notes
    
    [pre_note, notes].compact.join(" ")
  end
end
