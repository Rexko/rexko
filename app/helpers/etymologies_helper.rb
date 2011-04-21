module EtymologiesHelper
  def html_format etym, parent = nil
    wiki_format etym, nil, nil, true
  end
  
  def wiki_format etym, parent = nil, tree = nil, use_html = false # FIX: "use_html" is kludgy
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
        wiki_format key, parent, value, use_html
      end
      
      pre_note = ", from " + each_tree.to_sentence
    when Array
      parent_ancestor = etym.shift
      parent_ancestor = wiki_format parent_ancestor.keys[0], parent, parent_ancestor.values[0], use_html unless parent_ancestor.blank?

      peers = etym.collect do |peer_hash|
        wiki_format peer_hash.keys[0], parent, "", use_html
      end

      each_etym = etym.collect do |peer_hash|
        peer_hash.collect do |key, value|
          wiki_format key, parent, value, use_html
        end
      end.flatten(1)

      pre_note = ""
      peers.each do |peer|
        pre_note << " + #{peer}"
      end
      unless parent_ancestor.blank?
        short_parent = if use_html 
          language = content_tag :span, :class => "lexform-source-language" do
            html_escape parent.original_language.name
          end if parent.original_language 

          etymon = content_tag :span, :class => "lexform-etymon" do
            wh parent.etymon
          end
          
          [language, etymon].compact.join(" ")
        else
          parent.to_s
        end
        pre_note << "; where #{short_parent} is from #{parent_ancestor}"
      end
      etym.each do |peer_hash|
        peer = peer_hash.keys[0]
        ancestor = peer_hash.values[0]
        unless ancestor.blank?
          short_peer = if use_html 
            language = content_tag :span, :class => "lexform-source-language" do
              html_escape peer.original_language.name
            end if peer.original_language 

            etymon = content_tag :span, :class => "lexform-etymon" do
              wh peer.etymon
            end

            [language, etymon].compact.join(" ")
          else
            peer.to_s
          end

          ancestry = wiki_format ancestor.keys[0], peer, ancestor.values[0], use_html
          pre_note << ", and where #{short_peer} is from #{ancestry}"
        end
      end
    when Etymology
      if use_html
        language = content_tag :span, :class => "lexform-source-language" do
          html_escape etym.original_language.name
        end if etym.original_language unless
          parent && parent.original_language == etym.original_language

        etymon = content_tag :span, :class => "lexform-etymon" do
          wh etym.etymon
        end

        gloss = content_tag :span, :class => "lexform-etymon-gloss" do
          html_escape etym.primary_gloss
        end unless etym.primary_gloss.blank?
      else
        language = html_escape(etym.original_language.name) if 
          etym.original_language unless
          parent && parent.original_language == etym.original_language

        etymon = html_escape etym.etymon

        gloss = html_escape('"' << etym.primary_gloss << '"') if etym.primary_gloss
      end

      pre_note = [language, etymon, gloss].compact.join(" ") 

      unless tree.blank?
        tree_note = wiki_format tree, etym, tree, use_html
        pre_note = pre_note + tree_note
      end
    end
    
    pre_note << "." if top_level
    pre_note 
  end
end
