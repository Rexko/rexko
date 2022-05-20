Given(/^languages for testing$/) do
  Language::DEFAULT.save
end

Given(/^a test dictionary$/) do
  Dictionary.create(title: "Test", language: Language.first, source_language: Language.first, target_language: Language.first)
end

Given(/^there are (\d+) entries containing "(.*?)"$/) do |num, hw|
  num.to_i.times do
    lex = Lexeme.create 
    headwords = lex.headwords
    headwords.create(form: hw)
  end
  
  assert_equal num, Headword.where(form: hw).count
  assert_equal num, Lexeme.lookup_all_by_headword(hw).count
end

Given(/^I am on the home page$/) do
  visit root_path
end

When(/^I search for "(.*?)"$/) do |term|
  visit exact_lexeme_path(headword: term)
end

When(/^I am looking at the entry for "(.*?)"$/) do |term|
  visit exact_lexeme_path(headword: term)
  click_link(I18n.t('lexemes.index.show'))
end

When(/^I select "(.*?)" as my search option$/) do |arg1|
  within "div#header" do
    page.select arg1, from: "matchtype"
  end
end

When(/^I enter "(.*?)" into the query field$/) do |arg1|
  within "div#header" do
    page.fill_in I18n.t('editor.index.find_or_create_a_lexeme'), with: arg1 << "\n"
  end
end

Then(/^I should get a new entry page$/) do
  assert_equal new_lexeme_path(locale: I18n.default_locale), current_path
end

Then(/^I should be on a search results page with (\d+) results for "(.*?)"$/) do |count, query|
  page.assert_text(:visible, I18n.t('lexemes.matching.results', count: count.to_i, query: query))
end

Then(/^I should see a link to create a new entry$/) do
  assert page.has_link?(I18n.t('lexemes.index.new_lexeme'))
end

Then(/^I should see search options "(.*?)", "(.*?)", and "(.*?)"$/) do |arg1, arg2, arg3|
  assert_equal [arg1, arg2, arg3], Lexeme::SEARCH_OPTIONS
  assert page.has_select?("matchtype", options: I18n.t('lexeme.search.options'))
end
