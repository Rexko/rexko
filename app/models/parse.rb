class Parse < ActiveRecord::Base
  has_many :interpretations
  validates_presence_of :parsed_form
  belongs_to :parsable, :polymorphic => true
  
  scope :without_entries, :conditions => ['NOT EXISTS (SELECT "form" FROM "headwords" WHERE headwords.form = parsed_form)']
  scope :uninterpreted, :include => :interpretations, :conditions => { "interpretations.parse_id" => nil }
  
  accepts_nested_attributes_for :interpretations, :allow_destroy => true, :reject_if => proc { |attributes| attributes.all? {|k,v| v.blank?} }
    
  def interpretation=(terp_params)
    terp_params.each do |id, attributes|
      this_terp = Interpretation.find(id)
      if attributes
        this_terp.update_attributes(attributes)
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
    Parse.count(:conditions => {:parsed_form => parsed_form})
  end
  
  # Return a count of all uninterpreted parses whose parsed form matches the given headwords
  def self.count_unattached_to *headwords
    uninterpreted.count(:id, :conditions => ["parsed_form IN (?)", *headwords])
  end
  
  def self.most_wanted count  
    Parse.find(:all, :select => '"parses"."parsed_form", COUNT("parsed_form") AS count_all', :joins => ['LEFT OUTER JOIN "headwords" ON "headwords"."form" = "parsed_form"'], :conditions => {:headwords => {:form => nil}}, :group => '"parses"."parsed_form"', :order => 'count_all DESC', :limit => count)
  end
  
  def self.less_popular_than times, count=nil
    Parse.find(:all, :select => '"parses"."parsed_form", COUNT("parsed_form") AS count_all', :group => '"parses"."parsed_form"', :order => 'count_all DESC', :limit => count, :having => ['"count_all" < ?', times])
  end
  
  def self.popularity_between low_bound, high_bound
    Parse.find(:all, :select => '"parses"."parsed_form", COUNT("parsed_form") AS count_all', :group => '"parses"."parsed_form"', :order => 'count_all DESC', :having => ['"count_all" <= ? AND count_all >= ?', high_bound, low_bound])
  end
end
