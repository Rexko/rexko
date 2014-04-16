module TitlesHelper
  def htmlize_title title
    return "".html_safe unless title.present?
    
    sanitize \
    "<i>#{"<a href=\"" + h(title.url) + "\">" if title.url.present?}#{title.name}#{"</a>" if title.url.present?}</i>" \
    "#{" (#{title.publication_year})" if title.publication_year.present?}"                                            \
    "#{", #{title.publication_place}#{": " if title.publisher.present?}" if title.publication_place.present? }"       \
    "#{"#{", " unless title.publication_place.present?}#{title.publisher}" if title.publisher.present? }"             \
    "."
  end
end
