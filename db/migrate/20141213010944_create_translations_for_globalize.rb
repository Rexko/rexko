class CreateTranslationsForGlobalize < ActiveRecord::Migration
  def up
    Author.create_translation_table!({
      name:                 :string, 
      short_name:           :string, 
      romanized_name:       :string,
      sort_key:             :string
    }, { migrate_data: true })

    AuthorshipType.create_translation_table!({
      name:                :string 
    }, { migrate_data: true })

    Etymology.create_translation_table!({
      etymon:              :string,
      gloss:               :string
    }, { migrate_data: true })

    Gloss.create_translation_table!({
      gloss:               :string
    }, { migrate_data: true })

    Headword.create_translation_table!({
      form:                 :string
    }, { migrate_data: true })

    Language.create_translation_table!({
      default_name:         :string
    }, { migrate_data: true })

    Locus.create_translation_table!({
      example:              :text,
      example_translation:  :text
    }, { migrate_data: true })

    Note.create_translation_table!({
      content:              :text
    }, { migrate_data: true })

    Parse.create_translation_table!({
      parsed_form:          :string
    }, { migrate_data: true })

    PhoneticForm.create_translation_table!({
      form:                 :string
    }, { migrate_data: true })

    Sense.create_translation_table!({
      definition:           :text
    }, { migrate_data: true })

    SortOrder.create_translation_table!({
      name:                 :string
    }, { migrate_data: true })

    Source.create_translation_table!({
      pointer:              :string
    }, { migrate_data: true })

    Subentry.create_translation_table!({
      paradigm:             :string,
      part_of_speech:       :string
    }, { migrate_data: true })

    Title.create_translation_table!({
      name:                 :string,
      publisher:            :string,
      publication_place:    :string,
      url:                  :string
    }, { migrate_data: true })
  end

  def down
    [Author, AuthorshipType, Etymology, Gloss, Headword, Language, Locus, Note, 
      Parse, PhoneticForm, Sense, SortOrder, Source, Subentry, Title].each do |klass|
      klass.drop_translation_table! migrate_data: true
    end
  end
end
