module EtymologiesHelper
  def html_format etym, parent = nil
    wiki_format etym, nil, nil, true
  end
  
  # Given an Etymology, format it and all its ancestors into a convenient text format.
  # The additional arguments 'parent' and 'tree' are used by the method when calling itself recursively.
  # 'Parent' should be the previous word in the etymology (which is not necessarily the ancestor word, I think)
  # 'tree' is all further etyma in the ancestry that will need to be recursed this round through.
  def wiki_format etym, parent = nil, tree = nil, use_html = false # FIX: "use_html" is kludgy
		# On first run-through, assert we're at the top level and define the 'tree' variable as etym's ancestor hash with etym removed.
    unless tree
      top_level = true
			tree = etym.try(:ancestor_map)
    end
    
    # Different actions based on what we're working with.
    # On initial run etym should only be an Etymology.
    # On subsequent runs, etym will be a Hash if there is no next_etymon; otherwise it will be an Array.
    case etym
    # If the tree to recurse does not have a next_etymon
    # e.g. { parent_etym => { grandparent_etym => {}}}
    # or   { parent_etym => [{ grandparent_etym => {}}, { next_grandparent_etym => {}}]
    # Then get the wiki_format of the parent_etym, keeping the value of parent, and using the value of parent_etym as the tree.
    # We should get ", from [etymology of parent_etym]"
    when Hash
      each_tree = etym.collect do |key, value|
        wiki_format key, parent, value, use_html
      end
      
      # pre_note = ", from " if parent
      # pre_note = (pre_note || "") << each_tree.to_sentence
      ancestors = each_tree.to_sentence(locale: @dictionary.try(:definition_language) || I18n.locale)
      pre_note = parent ? t('helpers.etymology.from_ancestors', ancestors: ancestors) : ancestors
    # If the tree to recurse has a next_etymon
    # e.g. [ {{} => { parent_etym => { grandparent_etym => {} } }}, { next_etym => {} } ]
    # or   [ {{} => { parent_etym => { grandparent_etym => {} } }}, [{ next_etym => {} }, { third_etym => {} }] ]
    # or   [ {{} => { parent_etym => [ {grandparent_etym => {} }}, {next_grandparent_etym => {} }], [{ next_etym => {}}, {third_etym => {} }]]
    # or   [ {{} => { parent_etym => {} }}, [{ next_etym => {} }, { third_etym => {} ]] 
    # etc.
    when Array
      parent_ancestor = etym.shift
      orig_parent = parent_ancestor.keys[0]
      orig_ancestor = parent_ancestor.values[0]
      parent_ancestor = parent_ancestor.keys[0]
      pre_note = ""
      add_from = true if parent
          			# pre_note = (pre_note || "") << ", from " if add_from #DEBUG
      #pre_note << wiki_format(parent_ancestor, parent, "", use_html)
      format_ancestor = wiki_format(parent_ancestor, parent, "", use_html)
      pre_note = add_from ? t('helpers.etymology.from_ancestors', ancestors: format_ancestor) : format_ancestor

      parent_ancestor = wiki_format parent_ancestor.keys[0], parent, parent_ancestor.values[0], use_html unless (parent_ancestor.blank? || parent_ancestor.is_a?(Etymology))
      parent = orig_parent

      etym.flatten!
      peers = etym.collect do |peer_hash|
        wiki_format peer_hash.keys[0], parent, "", use_html
      end

      peers.each do |peer|
        pre_note = t('helpers.etymology.peerX_plus_peerY', peerX: pre_note, peerY: peer, default: "%{peerX} + %{peerY}")
#        pre_note << " + #{peer}"
      end
      
      appended_ancestor = false
      unless parent_ancestor.blank?
        short_parent = if use_html 
          language = content_tag :span, :class => "lexform-source-language" do
            html_escape orig_parent.original_language.name
          end if orig_parent && orig_parent.original_language 

          etymon = content_tag :span, :class => "lexform-etymon" do
            wh orig_parent.etymon
          end
          
          #[language, etymon].compact.join(" ")
          if language && etymon then
            t('helpers.etymology.language_etymon', language: language, etymon: etymon, default: "#{language} #{etymon}")
          else
            language || etymon
          end
        else
          orig_parent.to_s
        end
        orig_ancestry = wiki_format(orig_ancestor.keys[0], parent, orig_ancestor.values[0], use_html) if orig_ancestor.values[0]
        # pre_note << "; where #{short_parent} is from #{orig_ancestry}" if orig_ancestry
        pre_note = t('helpers.etymology.etym_where_word_is_from_ancestors', etyms: pre_note, word: short_parent, ancestors: orig_ancestry) if orig_ancestry
        appended_ancestor = true if orig_ancestry
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

            #[language, etymon].compact.join(" ")
            if language && etymon then
              t('helpers.etymology.language_etymon', language: language, etymon: etymon, default: "#{language} #{etymon}")
            else
              language || etymon
            end
          else
            peer.to_s
          end

          case ancestor
          when Hash
#            pre_note = ", from " + pre_note if add_from
            ancestry = wiki_format ancestor.keys[0], peer, ancestor.values[0], use_html
          when Array
            ancestry = wiki_format ancestor, peer, (ancestor.size == 1 ? nil : ancestor[1..-1]), use_html
          end
        #pre_note << (appended_ancestor ? ", and " : "; ") << "where #{short_peer} is from #{ancestry}"
        pre_note = appended_ancestor ? 
          t('helpers.etymology.etym_and_where_word_is_from_ancestors', etyms: pre_note, word: short_peer, ancestors: ancestry) :
          t('helpers.etymology.etym_where_word_is_from_ancestors', etyms: pre_note, word: short_peer, ancestors: ancestry)
        end
      end
    # When 'etym' is an etymology set pre_note to 'Language etymon "gloss"' and recurse, 
    # using 'tree' as both the etymon and the tree, and using the etymon as the parent.
   when Etymology
     initial_etymon_same_language = Language.lang_for(Lexeme.with_etymology(etym)) == etym.original_language unless parent

      if use_html
        language = content_tag :span, :class => "lexform-source-language" do
          html_escape etym.original_language.name
        end if etym.original_language unless
          (parent && parent.original_language == etym.original_language) || initial_etymon_same_language       
        etymon = content_tag :span, :class => "lexform-etymon" do
          wh etym.etymon
        end

        gloss = content_tag :span, :class => "lexform-etymon-gloss" do
          html_escape etym.gloss
        end unless etym.gloss.blank?
      else
        language = html_escape(etym.original_language.name) if 
          etym.original_language unless
          (parent && parent.original_language == etym.original_language) || initial_etymon_same_language

        etymon = sanitize etym.etymon

        # gloss = html_escape('"' << etym.gloss << '"') if etym.gloss.present?
        gloss = html_escape(t('helpers.etymology.quoted_gloss', gloss: etym.gloss, default: "\"#{etym.gloss}\"")) if etym.gloss.present?
      end unless top_level

      # pre_note = [language, etymon, gloss].compact.join(" ") 
      etym_hash = {language: language, etymon: etymon, gloss: gloss}.select{|k,v| !v.nil? }
      pre_note = if etym_hash.length > 1 then
        t("helpers.etymology.#{etym_hash.keys.join("_")}", language: language, etymon: etymon, gloss: gloss, default: etym_hash.values.join(" "))
      else
        language || etymon || gloss
      end

      unless tree.blank?
        tree_note = wiki_format tree, (etym unless top_level), tree, use_html
        # pre_note = pre_note + tree_note
        pre_note = t('helpers.etymology.etym_predicate', etyms: pre_note, predicate: tree_note, default: "#{pre_note}#{tree_note}")
      end
    end
    
    #pre_note = (pre_note || "") << "." if top_level
    pre_note ||= ""
    pre_note = t('helpers.etymology.etym_fullstop', etyms: pre_note, default: "#{pre_note}.") if top_level
    pre_note 
  end
end
