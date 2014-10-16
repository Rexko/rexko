module AuthorshipsHelper
  def cited_name authorship, options = {}
    return "" if authorship.nil? or authorship.new_record? 
    
    authorname = authorship.author.try(:name) || "Anonymous"
    titlename = htmlize_title(authorship.title)
    
    name = case authorship.authorship_type.try(:name)
    when "primary author" then "#{authorname}, #{titlename}"
    when "contributor" then "#{authorname}, in #{titlename}"
    when "quoted" then "#{authorname}, quoted in #{titlename}"
    else "#{authorname}, #{titlename}"
    end.html_safe
    
    options[:format] == :text ? strip_tags(name) : name
  end
  
  def short_cite authorship
    return "" if authorship.nil? or authorship.new_record? 

    author = [authorship.author.try(:short_name), authorship.author.try(:name), t('helpers.authorship.anonymous')].detect(&:present?)
    year = [authorship.year, authorship.title.try(:publication_year)].detect(&:present?)
    
    year.present? ? t('helpers.authorship.author_with_year', author: author, year: year) : author
  end
end
