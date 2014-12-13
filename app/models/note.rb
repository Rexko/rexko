class Note < ActiveRecord::Base
  belongs_to :language
  belongs_to :annotatable, :polymorphic => true
  translates :content
end
