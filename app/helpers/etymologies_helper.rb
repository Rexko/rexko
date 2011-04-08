module EtymologiesHelper
  def html_format etym, parent = nil
    language = content_tag :span, :class => "lexform-source-language" do
      html_escape(etym.source_language || '<Unknown source>') 
    end unless parent && parent.source_language == etym.source_language
    
    etymon = content_tag :span, :class => "lexform-etymon" do
      wh(etym.etymon || '<Unknown etymon>')
    end
    
    gloss = content_tag :span, :class => "lexform-etymon-gloss" do
      html_escape (etym.gloss || '<Unknown gloss>')
    end
  
    next_etym = html_format(etym.next_etymon, etym) if etym.next_etymon
    
    pre_note = [language, etymon, gloss, next_etym].compact.join(" ") 
    pre_note = pre_note << "." unless etym.next_etymon
    pre_note = "+ " << pre_note if parent
        
    notes = etym.notes.collect(&:content).join(" ") 
    notes = notes.blank? ? nil : notes
    
    [pre_note, notes].compact.join(" ")
  end
end
