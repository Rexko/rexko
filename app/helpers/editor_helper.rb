module EditorHelper
  def ten_most_wanted
    '<ul><li>%s</li></ul>' % [
      Parse.most_wanted(10).collect{|parse| headword_link(parse)}.join "</li><li>"
    ]
  end
end
