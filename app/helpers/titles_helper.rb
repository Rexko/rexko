module TitlesHelper
  def htmlize_title title
    sanitize \
    "<i>#{"<a href=\"" + h(title.url) + "\">" if title.url}#{title.name}#{"</a>" if title.url}</i>" \
    "#{" (#{title.publication_year})" if title.publication_year}"                                   \
    "#{", #{title.publication_place}#{": " if title.publisher}" if title.publication_place }"       \
    "#{"#{", " unless title.publication_place}#{title.publisher}" if title.publisher }"             \
    "."
  end
end
