class Parse < ApplicationRecord
  attribute :parsed_form

  has_many :interpretations
  belongs_to :parsable, :polymorphic => true, :optional => true
  translates :parsed_form, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => (Language.defined_language_codes | [I18n.default_locale])  
  validate :any_form_present?
  
  # Returns parses without entries (determined by comparing parsed_form to headword forms).
  scope :without_entries, -> { 
    joins([:translations]).joins("LEFT OUTER JOIN 'headword_translations' ON 'headword_translations'.'form' IN (LOWER(SUBSTR('parse_translations'.'parsed_form', 1, 1)) || SUBSTR('parse_translations'.'parsed_form', 2), UPPER(SUBSTR('parse_translations'.'parsed_form', 1, 1)) || SUBSTR('parse_translations'.'parsed_form', 2))").where({:headword_translations => {:form => nil}})
  }
  
  # Returns Parses not linked to a Sense by an Interpretation.
  scope :uninterpreted, -> { includes(:interpretations).where(Interpretation::NOT_INTERPRETING).references(:interpretations) }

  # Returns the most commonly appearing parses without entries.
  # count = number of results to return (defaults to 1)
  scope :most_wanted, ->(count = 1) { 
    select(['"parse_translations"."parsed_form"', Parse::Translation.arel_table[:parsed_form].count.as('count_all')]).
    without_entries.
    group('"parse_translations"."parsed_form"').
    order('count_all DESC').
    limit(count) 
  }

  # Return the most commonly appearing parses without an entry that are attested in the given loci.
  scope :most_wanted_in, ->(loci, count = 1) do
    most_wanted(count).
    joins('LEFT OUTER JOIN "attestations" ON ("parses"."parsable_id" = "attestations".id AND "parses"."parsable_type" = \'Attestation\')').
    joins('LEFT OUTER JOIN (SELECT "parsed_form" AS "pf", "locus_id" AS "lid" FROM "parses" AS "p2" INNER JOIN "attestations" AS "a2" ON ("p2"."parsable_id" = "a2"."id" AND "p2"."parsable_type" = \'Attestation\' AND "a2"."locus_id" IN (' + connection.quote(loci) + '))) ON "parses"."parsed_form" = "pf"').
    having('"lid" NOT NULL')
  end

  accepts_nested_attributes_for :interpretations, :allow_destroy => true, :reject_if => proc { |attributes| attributes[:sense_id].blank? }
     
  def self.safe_params
    [:id, :parsed_form, *Parse.globalize_attribute_names, :interpretations_attributes => Interpretation.safe_params]
  end
  
  def interpretation=(terp_params)
    terp_params.each do |id, attributes|
      this_terp = Interpretation.find(id)
      if attributes
        this_terp.update(attributes)
      else
        interpretations.delete(this_terp)
      end
    end
  end
  
  def lookup_headword
    Headword.find_by_form(parsed_form)
  end

  def lookup_all_headwords
    Headword.find_all_by_form(parsed_form)
  end

  # Return all senses belonging to words with parsed_form as headword if parsed_form exists
  def potential_interpretations
    parsed_form && Sense.lookup_all_by_headword(parsed_form)
  end
  
  def count
    Parse.where(parsed_form: parsed_form).count
  end

  # Return an array of all the parsed_forms in the supplied array of parses
  def self.forms_of parse_array
    result = Parse.where(:id => parse_array).includes(:translations)
    result.collect(&:parsed_form)
  end
  
  # Return a count of all uninterpreted parses whose parsed form matches the given headwords
  def self.count_unattached_to headwords
    uninterpreted.where(:parsed_form => headwords).count(:id)
  end
  
  # Return all uninterpreted parses whose parsed form matches the given headwords
  def self.unattached_to headwords
    uninterpreted.where(:parsed_form => headwords)
  end
  
  def self.less_popular_than times, count=nil
    Parse.find(:all, :select => '"parses"."parsed_form", COUNT("parsed_form") AS count_all', :group => '"parses"."parsed_form"', :order => 'count_all DESC', :limit => count, :having => ['"count_all" < ?', times])
  end
  
  def self.popularity_between low_bound, high_bound
    Parse.select('"parses"."parsed_form", COUNT("parsed_form") AS count_all').group('"parses"."parsed_form"').order('count_all DESC').having(['"count_all" <= ? AND count_all >= ?', high_bound, low_bound])
  end
  
  # Determine whether we should hit reject_if when something accepts_nested_attributes_for parses.
  def self.rejectable?(attributes)
    attributes.all? {|k, v| v.blank? || !k.start_with?("parsed_form") }
  end
  
  
  def any_form_present?
    if parsed_form.blank? && globalize_attribute_names.select {|k| k.to_s.start_with?("parsed_form")}.all? {|k| self[k].blank? }
      errors.add(:parsed_form, I18n.t('errors.messages.blank'))
    end
  end
end