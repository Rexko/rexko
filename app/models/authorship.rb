class Authorship < ActiveRecord::Base
  belongs_to :author
  belongs_to :title
  has_many :sources
  
  def cited_name # isn't this Helper material?
    authorname = author.nil? || author.name.nil? ? "Anonymous" : author.name
    titlename = title.nil? || title.name.nil? ? "Untitled" : title.name
    case 
    when primary_author then "#{authorname}, #{titlename}"
    when contributor then "#{authorname}, in #{titlename}"
    when quoted then "#{authorname}, quoted in #{titlename}"
    else "#{authorname}, #{titlename}"
    end
  end
end
