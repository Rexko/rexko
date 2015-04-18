class Array
  # Localized to_sentence, but for sentences with "or" instead of "and".
  # If a locale is not supplied, it will use I18n.locale. 
  # Locale keys are in support.array and similar to to_sentence's:
  #   :options_connector
  #   :two_options_connector
  #   :last_option_connector 
  # This is "inclusive or" - if xor is needed we'll define to_alternatives_sentence
  def to_options_sentence(locale = I18n.locale)
    connectors = {
      words_connector:     I18n.t('support.array.options_connector', locale: locale, default: ", "),
      two_words_connector: I18n.t('support.array.two_options_connector', locale: locale),
      last_word_connector: I18n.t('support.array.last_option_connector', locale: locale)      
    }
    
    to_sentence(connectors)
  end
end
