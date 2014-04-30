# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Authorship types
[
  "primary author", 
  "co-author",
  "contributor",
  "quoted",
  "editor",
  "illustrator",
  "translator"
].each {|at| AuthorshipType.find_or_create_by_name at }

