# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091031184526) do

  create_table "attestations", :force => true do |t|
    t.integer  "locus_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attested_form"
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorships", :force => true do |t|
    t.integer  "author_id"
    t.integer  "title_id"
    t.boolean  "primary_author"
    t.boolean  "contributor"
    t.boolean  "quoted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dictionaries", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
    t.integer  "source_language_id"
    t.integer  "target_language_id"
  end

  create_table "dictionary_scopes", :force => true do |t|
    t.integer  "dictionary_id"
    t.integer  "lexeme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "etymologies", :force => true do |t|
    t.string   "etymon"
    t.string   "source_language"
    t.string   "gloss"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
  end

  create_table "etymotheses", :force => true do |t|
    t.integer  "etymology_id"
    t.integer  "subentry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "glosses", :force => true do |t|
    t.string   "gloss"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
    t.integer  "sense_id"
  end

  create_table "headwords", :force => true do |t|
    t.string   "form"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
    t.integer  "lexeme_id"
  end

  create_table "interpretations", :force => true do |t|
    t.integer  "parse_id"
    t.integer  "sense_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "iso_639_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lexemes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loci", :force => true do |t|
    t.integer  "source_id"
    t.text     "example"
    t.text     "example_translation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "language_id"
    t.integer  "annotatable_id"
    t.string   "annotatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orthographs", :force => true do |t|
    t.integer  "headword_id"
    t.integer  "phonetic_form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parses", :force => true do |t|
    t.integer  "attestation_id"
    t.string   "parsed_form"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phonetic_forms", :force => true do |t|
    t.string   "form"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "senses", :force => true do |t|
    t.integer  "subentry_id"
    t.text     "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
  end

  create_table "sources", :force => true do |t|
    t.string   "pointer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "authorship_id"
  end

  create_table "subentries", :force => true do |t|
    t.integer  "lexeme_id"
    t.string   "paradigm"
    t.string   "part_of_speech"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
  end

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
