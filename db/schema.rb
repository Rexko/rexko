# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_07_063425) do

  create_table "attestations", force: :cascade do |t|
    t.integer "locus_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "attested_form", limit: 255
    t.index ["locus_id"], name: "index_attestations_on_locus_id"
  end

  create_table "author_translations", force: :cascade do |t|
    t.integer "author_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.string "short_name", limit: 255
    t.string "romanized_name", limit: 255
    t.string "sort_key", limit: 255
    t.index ["author_id"], name: "index_author_translations_on_author_id"
    t.index ["locale"], name: "index_author_translations_on_locale"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "romanized_name", limit: 255
    t.string "short_name", limit: 255
    t.string "sort_key", limit: 255
  end

  create_table "authorship_type_translations", force: :cascade do |t|
    t.integer "authorship_type_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.index ["authorship_type_id"], name: "index_authorship_type_translations_on_authorship_type_id"
    t.index ["locale"], name: "index_authorship_type_translations_on_locale"
  end

  create_table "authorship_types", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorships", force: :cascade do |t|
    t.integer "author_id"
    t.integer "title_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "year", limit: 255
    t.integer "authorship_type_id"
  end

  create_table "dictionaries", force: :cascade do |t|
    t.string "title", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "language_id"
    t.integer "source_language_id"
    t.integer "target_language_id"
    t.integer "sort_order_id"
    t.string "external_address", limit: 255
  end

  create_table "dictionary_scopes", force: :cascade do |t|
    t.integer "dictionary_id"
    t.integer "lexeme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["dictionary_id"], name: "index_dictionary_scopes_on_dictionary_id"
    t.index ["lexeme_id"], name: "index_dictionary_scopes_on_lexeme_id"
  end

  create_table "etymologies", force: :cascade do |t|
    t.string "etymon", limit: 255
    t.string "gloss", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "language_id"
    t.integer "next_etymon_id"
    t.integer "original_language_id"
  end

  create_table "etymology_translations", force: :cascade do |t|
    t.integer "etymology_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "gloss", limit: 255
    t.index ["etymology_id"], name: "index_etymology_translations_on_etymology_id"
    t.index ["locale"], name: "index_etymology_translations_on_locale"
  end

  create_table "etymotheses", force: :cascade do |t|
    t.integer "etymology_id"
    t.integer "subentry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "source_id"
  end

  create_table "gloss_translations", force: :cascade do |t|
    t.integer "gloss_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "gloss", limit: 255
    t.index ["gloss_id"], name: "index_gloss_translations_on_gloss_id"
    t.index ["locale"], name: "index_gloss_translations_on_locale"
  end

  create_table "glosses", force: :cascade do |t|
    t.string "gloss", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "language_id"
    t.integer "sense_id"
  end

  create_table "headword_translations", force: :cascade do |t|
    t.integer "headword_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "form", limit: 255
    t.index ["form"], name: "index_headword_translations_on_form"
    t.index ["headword_id"], name: "index_headword_translations_on_headword_id"
    t.index ["locale"], name: "index_headword_translations_on_locale"
  end

  create_table "headwords", force: :cascade do |t|
    t.string "form", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "language_id"
    t.integer "lexeme_id"
    t.integer "acceptance"
    t.index ["form"], name: "index_headwords_on_form"
    t.index ["lexeme_id"], name: "index_headwords_on_lexeme_id"
  end

  create_table "interpretations", force: :cascade do |t|
    t.integer "parse_id"
    t.integer "sense_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parse_id"], name: "index_interpretations_on_parse_id"
    t.index ["sense_id"], name: "index_interpretations_on_sense_id"
  end

  create_table "language_translations", force: :cascade do |t|
    t.integer "language_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "default_name", limit: 255
    t.index ["language_id"], name: "index_language_translations_on_language_id"
    t.index ["locale"], name: "index_language_translations_on_locale"
  end

  create_table "languages", force: :cascade do |t|
    t.string "iso_639_code", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "default_name", limit: 255
    t.integer "sort_order_id"
  end

  create_table "lexemes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loci", force: :cascade do |t|
    t.integer "source_id"
    t.text "example"
    t.text "example_translation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_translations", force: :cascade do |t|
    t.integer "note_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "content"
    t.index ["locale"], name: "index_note_translations_on_locale"
    t.index ["note_id"], name: "index_note_translations_on_note_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.integer "language_id"
    t.integer "annotatable_id"
    t.string "annotatable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orthographs", force: :cascade do |t|
    t.integer "headword_id"
    t.integer "phonetic_form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parse_translations", force: :cascade do |t|
    t.integer "parse_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "parsed_form", limit: 255
    t.index ["locale"], name: "index_parse_translations_on_locale"
    t.index ["parse_id"], name: "index_parse_translations_on_parse_id"
    t.index ["parsed_form"], name: "index_parse_translations_on_parsed_form"
  end

  create_table "parses", force: :cascade do |t|
    t.integer "parsable_id"
    t.string "parsed_form", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "parsable_type", limit: 255
    t.index ["parsable_id"], name: "index_parses_on_attestation_id"
    t.index ["parsed_form"], name: "index_parses_on_parsed_form"
  end

  create_table "phonetic_form_translations", force: :cascade do |t|
    t.integer "phonetic_form_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "form", limit: 255
    t.index ["locale"], name: "index_phonetic_form_translations_on_locale"
    t.index ["phonetic_form_id"], name: "index_phonetic_form_translations_on_phonetic_form_id"
  end

  create_table "phonetic_forms", force: :cascade do |t|
    t.string "form", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sense_translations", force: :cascade do |t|
    t.integer "sense_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "definition"
    t.index ["locale"], name: "index_sense_translations_on_locale"
    t.index ["sense_id"], name: "index_sense_translations_on_sense_id"
  end

  create_table "senses", force: :cascade do |t|
    t.integer "subentry_id"
    t.text "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "language_id"
    t.index ["subentry_id"], name: "index_senses_on_subentry_id"
  end

  create_table "sort_order_translations", force: :cascade do |t|
    t.integer "sort_order_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.index ["locale"], name: "index_sort_order_translations_on_locale"
    t.index ["sort_order_id"], name: "index_sort_order_translations_on_sort_order_id"
  end

  create_table "sort_orders", force: :cascade do |t|
    t.string "name", limit: 255
    t.text "substitutions"
    t.text "orderings"
    t.integer "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["language_id"], name: "index_sort_orders_on_language_id"
  end

  create_table "source_translations", force: :cascade do |t|
    t.integer "source_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "pointer", limit: 255
    t.index ["locale"], name: "index_source_translations_on_locale"
    t.index ["source_id"], name: "index_source_translations_on_source_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "pointer", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "authorship_id"
  end

  create_table "subentries", force: :cascade do |t|
    t.integer "lexeme_id"
    t.string "paradigm", limit: 255
    t.string "part_of_speech", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "language_id"
    t.index ["lexeme_id"], name: "index_subentries_on_lexeme_id"
  end

  create_table "subentry_translations", force: :cascade do |t|
    t.integer "subentry_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "paradigm", limit: 255
    t.string "part_of_speech", limit: 255
    t.index ["locale"], name: "index_subentry_translations_on_locale"
    t.index ["subentry_id"], name: "index_subentry_translations_on_subentry_id"
  end

  create_table "title_translations", force: :cascade do |t|
    t.integer "title_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.string "publisher", limit: 255
    t.string "publication_place", limit: 255
    t.string "url", limit: 255
    t.index ["locale"], name: "index_title_translations_on_locale"
    t.index ["title_id"], name: "index_title_translations_on_title_id"
  end

  create_table "titles", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "publication_year", limit: 255
    t.string "publisher", limit: 255
    t.string "publication_place", limit: 255
    t.string "url", limit: 255
    t.date "access_date"
  end

end
