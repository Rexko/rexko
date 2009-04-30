class Author < ActiveRecord::Base
  has_many :authorships
  has_many :titles, :through => :authorships
  has_many :sources, :through => :authorships
end
