# frozen_string_literal: true

require 'active_support/concern'

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
      words_connector: I18n.t('support.array.options_connector', locale:, default: ', '),
      two_words_connector: I18n.t('support.array.two_options_connector', locale:),
      last_word_connector: I18n.t('support.array.last_option_connector', locale:)
    }

    to_sentence(connectors)
  end
end

# Strip_attributes gem will strip leading/trailing whitespace from
# translated attributes.
Globalize::ActiveRecord::Translation.class_eval do
  strip_attributes
end

# Pass a whole params hash but only build from valid attributes
module BuildOnlyFromValid
  extend ActiveSupport::Concern

  module ClassMethods
    def build_from_only_valid(attrs = {})
      new(attrs.slice(attribute_names))
    end
  end
end

ActiveRecord::Base.include BuildOnlyFromValid
