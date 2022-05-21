class Source < ApplicationRecord
  has_many :loci
  belongs_to :authorship, optional: true # , :include => [:title, :author]
  delegate :title, to: '(authorship or return nil)'
  delegate :author, to: '(authorship or return nil)'
  # => would be nice:
  # has_one :title, "through" => :authorship
  # has_one :author, "through" => :authorship
  translates :pointer

  accepts_nested_attributes_for :authorship, allow_destroy: false, reject_if: :all_blank

  def self.safe_params
    [:id, :_destroy, :pointer, { authorship_attributes: Authorship.safe_params }]
  end

  def authorship_attributes=(attributes)
    if attributes['id'].present?
      self.authorship = Authorship.find(attributes['id'])
    else
      assign_nested_attributes_for_one_to_one_association(:authorship, attributes)
    end
  end
end
