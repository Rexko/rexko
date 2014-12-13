class Author < ActiveRecord::Base
  has_many :authorships
  has_many :titles, :through => :authorships
  has_many :sources, :through => :authorships
  translates :name, :short_name, :romanized_name, :sort_key
end
