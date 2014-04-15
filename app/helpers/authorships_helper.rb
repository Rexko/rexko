module AuthorshipsHelper
  def cited_name authorship, options = {}
    return "" if authorship.new_record? 
    
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
end
