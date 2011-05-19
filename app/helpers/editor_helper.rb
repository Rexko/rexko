module EditorHelper
  def ten_most_wanted
    ('<ul><li>%s</li></ul>' % [
      Parse.most_wanted(10).collect{|parse| new_headword_link(parse)}.join("</li><li>")
    ]).html_safe
  end
  
  def expandlist
    unattested = Headword.unattested.offset(rand(Headword.unattested.count.nonzero? || 1)).first

    list = '<ul><li>%s</li><li>%s</li></ul>' % [
      ("0 " << link_to(unattested.form, :controller => :lexemes, :action => :show, :id => unattested.lexeme.id) if unattested && unattested.lexeme),
      [[1, 4], [5, 9], [10, 49], [50, 100]].collect {|num|
        Parse.popularity_between(num[0], num[1]).sample
      }.flatten.collect{|parse|
        parse.count_all.to_s << " " << headword_link(parse) if parse
      }.join("</li><li>") 
    ] 
    
    list.html_safe
  end
end
