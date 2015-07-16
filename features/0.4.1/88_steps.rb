EXAMPLE_TEXT = "Verbum in contextu adhibitum"

Given(/^a locus for testing$/) do
  @locus = Locus.create(
    example: EXAMPLE_TEXT, 
    example_translation: "A word used in context"
  )
  
  atts = @locus.attestations
  att = atts.create(attested_form: "Verbum")
  
  parses = att.parses
  @parse = parses.create(parsed_form: "verbum")
end

Given(/^a lexeme for it to be listed on$/) do
  @lex = Lexeme.create
  subentry = @lex.subentries.create
  sense = subentry.senses.create(definition: "a word")
  
  @terp = Interpretation.create(parse: @parse, sense: sense)
end
      
When(/^I can see the locus on the lexeme page$/) do
  visit url_for(
    controller: :lexemes, 
    action: :show, 
    id: @lex, 
    locale: I18n.default_locale, 
    host: "127.0.0.1", 
    port: 7787
  )
  page.assert_text(:visible, EXAMPLE_TEXT)
end

Then(/^there should be a permalink to the locus$/) do
  assert page.has_link?("", href: url_for(
    controller: :loci, 
    action: :show, 
    id: @locus, 
    locale: I18n.default_locale, 
    only_path: true
  ))
end

Then(/^there should be a link to edit the locus$/) do
  assert page.has_link?(I18n.t('loci.index.edit'), href: url_for(
    controller: :loci,
    action: :edit,
    id: @locus, 
    locale: I18n.default_locale, 
    only_path: true
  ))
end

Then(/^there should be a link to unlink the locus from the lexeme$/) do
  assert page.has_link?(I18n.t('interpretations.index.destroy'), href: url_for(
    controller: :interpretations,
    action: :destroy,
    id: @terp, 
    locale: I18n.default_locale, 
    only_path: true
  ))
end

Then(/^there should be a link to delete the locus$/) do
  assert page.has_link?(I18n.t('loci.index.destroy'), href: url_for(
    controller: :loci,
    action: :destroy,
    id: @locus, 
    locale: I18n.default_locale, 
    only_path: true
  ))
end

Then(/^I should be prompted before deleting the (\w+)$/) do |item|
  items = item.pluralize
  
  prompt = accept_confirm do
      page.click_link(I18n.t("#{items}.index.destroy"), href: url_for(
      controller: items,
      action: :destroy,
      id: case items
          when "loci" then @locus
          when "interpretations" then @terp
          end, 
      locale: I18n.default_locale, 
      only_path: true
    ))
  end
  
  assert_equal prompt, I18n.t("#{items}.index.confirm_destroy")
end
     