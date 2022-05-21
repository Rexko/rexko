class Language < ApplicationRecord
  attribute :default_name

  has_many :dictionaries
  has_many :etymologies
  has_many :glosses
  has_many :headwords
  has_many :senses
  has_many :subentries
  belongs_to :sort_order, optional: true # The language's default sort order
  has_many :sort_orders # All sort orders defined for this language
  translates :default_name

  accepts_nested_attributes_for :sort_order, allow_destroy: true, reject_if: :all_blank

  DEFAULT = new(default_name: I18n.t('helpers.language.default'), iso_639_code: I18n.default_locale.to_s)
  MULTIPLE_LANGUAGES = new(default_name: 'Multiple languages', iso_639_code: 'mul')
  UNDETERMINED = new(default_name: 'Undetermined', iso_639_code: 'und')
  NO_LINGUISTIC_CONTENT = new(default_name: 'No linguistic content', iso_639_code: 'zxx')
  UNKNOWN_LANGUAGE = 'Unknown language %d'

  def self.safe_params
    %i[default_name iso_639_code]
  end

  # Return the name of a language plus its ISO code if present.
  def to_s
    if iso_639_code.present?
      I18n.t('language.name_with_code', name: default_name, code: iso_639_code,
                                        default: '%{name} (%{code})')
    else
      default_name
    end
  end

  # Return the best short name of the language
  def name
    (default_name if default_name.present?) ||
      (iso_639_code if iso_639_code.present?) ||
      (id ? UNKNOWN_LANGUAGE % id : '')
  end

  # Return the best sort order for the language
  def default_order
    (sort_order if sort_order.present?) ||
      (sort_orders.try(:first) if sort_orders.present?) ||
      SortOrder::DEFAULT
  end

  # lang_for: Returns the Language used in the element or array.
  #
  # Will return:
  # * 'und' (ISO 639: 'undetermined') if no languages are found for
  #   any of the content
  # * 'mul' (ISO 639: 'multiple languages') if more than one
  #   language is found in the array's content
  # * the Language associated to the content, if they all use the same
  def self.lang_for(content, lang_attr = nil)
    [*content].inject(nil) do |memo, elem|
      lang = elem ? elem.send(lang_attr || :language) || UNDETERMINED : NO_LINGUISTIC_CONTENT
      if memo
        lang == memo ? memo : (break MULTIPLE_LANGUAGES)
      else
        lang
      end
    end || UNDETERMINED
  end

  # langs_for: Returns an array of languages used in the element or array.
  # Like lang_for, but doesn't collapse multiple languages to 'mul'.
  def self.langs_for(content, lang_attr = nil)
    [*content].collect do |item|
      item ? item.send(lang_attr || :language) || UNDETERMINED : NO_LINGUISTIC_CONTENT
    end.uniq
  end

  # langs_hash_for: Returns a hash for multiple langs_for calls.
  # lang_attrs can be an array of symbols (the returned hash will use those
  # symbols as keys) or of arrays
  def self.langs_hash_for(content, lang_attrs = {})
    Hash[lang_attrs.collect do |lang_name, lang_method|
      [lang_name, langs_for(content, lang_method)]
    end]
  end

  def self.code_for(content, subtags = {})
    lang_for(content).iso_639_code.tap do |code|
      code += '-' + subtags[:variant] unless subtags[:variant].blank?
    end
  end

  # Sort ordinandum
  # Options:
  # :by - attribute to sort by
  # :sub - substitutions, a hash like { "J" => "I" }
  # :order - exceptions to default order, a hash like { "Ñ" => "N" }
  def sort(ordinandum, options = {})
    substs = options[:sub] || default_order.substitutions
    substs.keys.each { |k| substs[k.mb_chars.downcase.to_s] ||= substs[k] }
    orders = options[:order] || default_order.orderings
    orders.keys.each do |k|
      orders[k] = "#{orders[k]}\u{FFFF}"
      orders[k.mb_chars.downcase.to_s] ||= orders[k]
    end
    changes = substs.merge(orders)

    ordinandum.sort_by do |o|
      key = (options[:by] ? o.send(options[:by]) : o).dup

      key.gsub!(Regexp.new(Regexp.union(changes.keys).source, Regexp::IGNORECASE), changes)
      key.mb_chars.downcase
    end
  end

  # Determine language of ordinandum and sort by its sort
  def self.sort_using_lang_for(ordinandum, options = {})
    lang_for(ordinandum, options[:lang_attr]).sort(ordinandum, options)
  end

  # Returns the language itself.
  def language
    self
  end

  # Return an array of the language codes defined in the system.
  def self.defined_language_codes
    all.collect(&:iso_639_code)
  end

  # Given a string +query+,
  # return all languages where each word in +query+ appears as a substring
  # of either the name or the language code (or both)
  def self.matching(query)
    terms = query.split.inject(true) do |sumquery, term|
      %i[default_name iso_639_code]
        .collect { |attrib| Language.arel_table[attrib].matches("%#{term.chomp ','}%") }
        .inject(:or)
        .and(sumquery)
    end

    Language.includes([:translations]).where(terms)
  end

  # Return all Languages given in an object's translations.
  # Initializes new Language objects if none exists for a particular locale.
  def self.of_translations_of(obj)
    return nil unless obj.respond_to? :translations

    obj.translations.collect { |xlat| find_or_initialize_by(iso_639_code: xlat.locale.to_s) }
  end
end
