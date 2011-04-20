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
  
  def wiki_format etym, parent = nil, tree = nil
    unless tree
      top_level = true
      map = etym.ancestor_map
      if map.is_a? Hash
        tree = map[etym]
      else
        until map[0].is_a? Hash
          map = map[0]
        end
        
        map[0] = map[0][etym]
        tree = map
      end
    end
    
    case etym
    when Hash
      each_tree = etym.collect do |key, value|
        wiki_format key, parent, value
      end
      
      pre_note = ", from " + each_tree.to_sentence
    when Array
      parent_ancestor = etym.shift
      parent_ancestor = wiki_format parent_ancestor.keys[0], parent, parent_ancestor.values[0] unless parent_ancestor.blank?

      peers = etym.collect do |peer_hash|
        wiki_format peer_hash.keys[0], parent, ""
      end

      each_etym = etym.collect do |peer_hash|
        peer_hash.collect do |key, value|
          wiki_format key, parent, value
        end
      end.flatten(1)

      pre_note = ""
      peers.each do |peer|
        pre_note << " + #{peer}"
      end
      unless parent_ancestor.blank?
        pre_note << "; where #{parent} is from #{parent_ancestor}"
      end
      etym.each do |peer_hash|
        peer = peer_hash.keys[0]
        ancestor = peer_hash.values[0]
        unless ancestor.blank?
          ancestry = wiki_format ancestor.keys[0], peer, ancestor.values[0]
          pre_note << ", and where #{peer} is from #{ancestry}"
        end
      end
    when Etymology
      language = html_escape(etym.original_language.name) if 
        etym.original_language unless
        parent && parent.original_language == etym.original_language

      etymon = html_escape etym.etymon

      gloss = html_escape('"' << etym.primary_gloss << '"') if etym.primary_gloss

      pre_note = [language, etymon, gloss].compact.join(" ") 

      unless tree.blank?
        tree_note = wiki_format tree, etym, tree 
        pre_note = pre_note + tree_note
      end
    end
    
    pre_note << "." if top_level
    pre_note 
  end
end
