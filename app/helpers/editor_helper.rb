module EditorHelper
  def ten_most_wanted
    '<ul><li>%s</li></ul>' % [
      Parse.most_wanted(10).collect{|parse| headword_link(parse)}.join "</li><li>"
    ]
  end
  
  def expandlist
    unattested = Headword.unattested.first
    
    '<ul><li>%s</li><li>%s</li></ul>' % [
      "0 " << link_to(unattested.form, unattested.lexeme),
      [5, 10, 50, 100].collect {|num|
        Parse.less_popular_than num, 1
      }.flatten.collect{|parse|
        parse.count_all << " " << headword_link(parse)
      }.join("</li><li>")
    ]
  end
end
