# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /^(loc)us/i, '\1i'
  inflect.singular /^(loc)i/i, '\1us'
  inflect.plural /(.*etym)on/i, '\1a'
  inflect.singular /(.*etym)a/i, '\1on'
  inflect.plural /^(etymothes)is/i, '\1es'
  inflect.singular /^(etymothes)es/i, '\1is'
end
