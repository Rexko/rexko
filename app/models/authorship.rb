class Authorship < ActiveRecord::Base
  belongs_to :author
  belongs_to :title
  belongs_to :authorship_type
  has_many :sources
  
  accepts_nested_attributes_for :author, reject_if: :all_blank
  accepts_nested_attributes_for :title, allow_destroy: true, reject_if: :all_blank
  
  def cited_name # isn't this Helper material?
    return "" if new_record? 
    
    authorname = author.try(:name) || "Anonymous"
    titlename = title.try(:name) || "Untitled"
    case authorship_type.try(:name)
    when "primary author" then "#{authorname}, #{titlename}"
    when "contributor" then "#{authorname}, in #{titlename}"
    when "quoted" then "#{authorname}, quoted in #{titlename}"
    else "#{authorname}, #{titlename}"
    end
  end
  
  # Given a string +query+, return all authorships where each word in +query+ 
  # appears as a substring of either the author or the title (or both) 
  def Authorship.matching query
    terms = query.split.inject(true) {|sumquery, term|
      [Author, Title].
        collect {|klass| klass.arel_table[:name].matches("%#{term.chomp ','}%")}.
        inject(:or).
        and(sumquery)
    }

    Authorship.includes(:author, :title).where(terms)
  end
  
  def author_attributes=(attributes)
    if attributes['id'].present?
      self.author = Author.find(attributes['id'])
    end
    assign_nested_attributes_for_one_to_one_association(:author, attributes)
  end
end
