class Authorship < ActiveRecord::Base
  belongs_to :author
  belongs_to :title
  has_many :sources
  
  def cited_name # isn't this Helper material?
    authorname = author.try(:name) || "Anonymous"
    titlename = title.try(:name) || "Untitled"
    case 
    when primary_author then "#{authorname}, #{titlename}"
    when contributor then "#{authorname}, in #{titlename}"
    when quoted then "#{authorname}, quoted in #{titlename}"
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
end
