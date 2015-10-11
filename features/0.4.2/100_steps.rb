Language::DEFAULT.save

Given "I am on the lexeme edit form" do  
  # At this point in time lexemes#new fails when there's no dictionaries present
  Dictionary.create(title: "Test", language: Language.first, source_language: Language.first, target_language: Language.first)

  visit url_for(
    controller: :lexemes, 
    action: :new, 
    locale: I18n.default_locale, 
    host: "127.0.0.1", 
    port: 7787
  )
  
  @note_link_count = page.all('a', text: I18n.t("helpers.link_to_add.note")).size
end

When "I have added a phonetic form" do 
  page.click_link(I18n.t("helpers.link_to_add.phonetic form"))
end

Then "I should see a link to add a note" do
  page.all('a', text: I18n.t("helpers.link_to_add.note"), minimum: @note_link_count + 1)
end
  