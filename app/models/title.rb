class Title < ActiveRecord::Base
  has_many :authorships
  has_many :authors, :through => :authorships
  has_many :sources, :through => :authorships # 'sources' could use a better name
end
