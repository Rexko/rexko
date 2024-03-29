## Since 0.4.3
* [#239] Fixed an issue where glosses might not appear in wiki show
* [#253] Fixed an issue with some special characters in URLs
* [#241] Fixed an issue with adding new languages from the etymology form
* [#194, #195] Upgraded from Rails 3.1.11 & Ruby 1.9.3 to Rails 7.0.2 & Ruby 3.1.2

## Since 0.4.2
* [#94] Added delete link to Lexeme show page
* [#204] Fixed an issue where most wanted wasn't updating
* [#175] Will now strip leading and trailing whitespace
* [#212] Fixed an issue where principal parts and pronunciation were missing from lexeme index
* [#95] Deleting a lexeme should now return you to the page you were on, when practicable
* [#96, #222] Fixed an issue where loci of homographs might not be listed in wiki show
* [#97] Added a link to homographs when wiki show lists them (click "All entries")
* [#211] Fixed an issue where a lexeme's paradigm wasn't given in wiki show
* [#202] Fixed an issue with adding to the lexeme form when assigned to multiple dictionaries
* [#169] Short lists now only show the most acceptable headwords
* [#234] Fixed an issue with listing additional loci for potential constructions
* [#180] Fixed an issue that forced a restart to use newly-added languages 

## Since 0.4.1
* [#89] Lexeme form now arranges etymology horizontally instead of by nesting
* [#93] Changed language chooser for etymologies from a dropdown to an autocomplete
* [#92] Should be able to create a new language from the etymology form
* [#100] Should be able to add note to a phonetic form
* [#152] Replaced some borders on the lexeme edit form with whitespace to reduce nestiness
* [#159] Fixed an issue that prevented etymology sources from being edited or removed
* [#188] The lexeme edit form now shows all its existing data, not just associated dictionaries
* [#192] Fixed an issue with adding multiple notes to an item
* [#205] Fixed an issue with lexemes not showing in parse dropdowns
* [#187] Fixed an issue where principal parts and pronunciation were missing from search results
* [#206] Fixed an issue where glosses couldn't be added to lexeme edit
* [#215] Fixed an issue where specifying the language of an etymon would fail on save
* [#209] Fixed an error when viewing a lexeme with a homograph in wiki format 
* [#219] Fixed an error with the edit form for languages/sort orders

## Since 0.4.0
* [#78] New lexeme link always to be available on lexeme show and search pages
* [#85] Language of the first etymon in an etymology shouldn't be listed if it's the same as the lexeme's
* [#161] Fixed some issues where new subitems weren't being created
* [#143] Fixed an issue where unattached parses were being underreported
* [#88] Added options to work with loci on the lexeme show page
* [#176] Fixed an issue that prevented showing etymologies under unattached parses
* [#177] Fixed an issue with creating subentries from the lexeme form
* [#179] Fixed an error when viewing a dictionary whose lexemes are in multiple dictionaries

## Since 0.3.6
* [#142] Fixed failure of will_paginate on Locus search
* [#141] Fixed issue where interpretations and loci wouldn't save
* [#74, #119] Fixed issue where "most wanted parse" was not initial-case-insensitive.
* [#119] Fixed an issue where the "most wanted parse" was not necessarily so.
* [#140] Fields that default to blank (gloss, parsed form) should no longer inhibit saving lexemes
* [#125] Basic ability to specify dictionary sorting on language edit page 
* [#82] Ability to specify convenience link on dictionary edit page (TTT no longer hardcoded)
* [#37 (61)] Dictionary show page now shows full dictionary
* [#139] Fixed missing button images
* [#121] Loci now appear under their senses in lexeme view.
* [#127] Fixed association of constructions with authors in wiki view.
* [#10 (32)] Specify preferred headwords and allow annotations.
* [#12 (34)] Better bibliographic referencing.
* [#19 (44), #128] Locus edit form redesigned; locus display now includes definitions in mouseover info
* [#148] Added .ruby-version file
* [#147] Releasing under MIT license
* [#5] Rudiments of internationalization and globalization

## Since 0.3.5
* Updated code for Rails 3.1 
* [#137] Prevent blank interpretations from being saved (was breaking 'unattached' counts)
* [#136] URLs with certain Unicode characters should no longer fail
* [#138] Fixed issue where adding interpretations to new parses on the locus form would throw an error
* [#132] Glosses are now parsable
* [#60] Locus edit now autosuggests possible constructions based on existing loci.
* [#55] Phonetic forms should now appear only with the appopriate lexemes in the wiki format

## Since 0.3.4
* [#77] Headwords differing only by initial case should not be listed separately in wikiform.
* [#123] Add search box to every page
* [#129] Display message when no results found on unattached page
* [#134] Fixed issue where only the first etymon of a lexeme could be found on the unattached page
* [#135] Fixed missing text in etymologies
* [#103] Box for adding notes is no longer green
* [#109] Author search now displays what was queried in page title
* [#81] Added AJAX to edit views to lower the necessity of using "Create/Update and continue editing"
* [#122] Fixed issue where notes were being added to the wrong etymologies when using 'next etymon'

## Since 0.3.3
* [#124] Locus search by author should not be limited to one author
* [#117, #126] Rewrote etymology text generator
* [#86] Removed stray quotes in wiki format when part of speech absent
* [#133] Fixed issue where exact search with multiple results would return substring results instead
* [#76] Added link to unattached loci in lexeme edit form under each headword
* [#59] Loci browse and search are now sorted by Author, Title, and Pointer.
* [#131] Fixed issue where only the first page of loci search results were accessible

## Since 0.3.2
* [#69] Locus#attesting should not return duplicate loci
* [#118] Fixed crash of etymology formatter when a compound has 3+ components
* [#120] Fixed issue with creating note-only etymologies
* [#73], [#105] Display of unattached parses now shows more than just loci, resolving count discrepancy
* [#46] Can now create new senses from locus edit form
* [#116] Deleting attestation/parse from locus should lower count in addlist
* [#56] 'language' attribute of data now reports dictionary default instead of 'und' when unset

## Since 0.3.1
* Updated code for Rails 3
* [#102] Auto-select-all in lexeme show should now select the correct box when multiple
* [#98] Use simple sortkey in wiki heading ({{dict|Titlewords}} instead of just {{dict}})
* [#73] 'Unattached loci' in lexeme show corrected to read 'unattached parses' (see also #105)

## Since 0.3
* Fix several issues with handling missing data
* [#87] Fixed issue with /unattached crashing due to reference to removed column
* [#84] Formatting of errors and flash notices in main layout
* [#83] Fixed issue with saving lexeme with blank etymon subform
* [#26 (51)] Etymology in lexeme show now refers to the etymon's etymology, and so forth
* [#90] Fixed display of loci attesting a construction but not the main lexeme

## Since 0.2.6
* For [#26 (51)] Upgraded handling of etymologies.
* [#4 (25)] Etymologies now refer to Language objects instead of just storing the name 

## Since 0.2.5
* [#51] Locus edit form now better identifies what subentry the interpretation will point to
* [#75] Lexeme search now uses a fixed URL when there are multiple results.
* [#63] Fixed bugs with constructions not being listed correctly in lexeme views
* For [#44] Wikilink format now sets title attribute to the headword being linked to
* [#74] Fixed some issues with casing for headwords differing only by initial letter

## Since 0.2.4
* Revamped layout based on YAML.  
* For [#40] Text areas in the Lexeme view now select all on focus.
* [#22 (47)] Wikilinks, wikibold, and wikiitalic display in lexemes and loci
* [#55] In wiki layout, loci now only appear on pages for the spellings they attest.
* For [#36 (60)] Headwords can now be searched by substring.

## Since 0.2.3
* For [#70] DB query cleanup to make the locus edit page go faster.
* For [#63] fixed a bug where lexemes would associate with constructions not containing them.
* [#65] Ask for confirmation before removing fields from edit forms
* Randomize the expandlist on the front page (this is ugly)
* [#72] Fixed a bug where the 'most wanted parse' highlight was highlighting the wrong item.

## Since 0.2.2
* [#64] Fixed where loci in "all entries" under lexeme view didn't match the lexeme
* For [#36 (60)] added locus search by author to front page.
* [#18 (36)] added automated to-do lists (addlist and expandlist).
* Fixed a bug that made lexemes inaccessible if etymology items were deleted.
* [#71] Fixed a bug that made some lists of unattached loci inaccessible. 

## Since 0.2.1
* Fixed Yet Another bug where etymologies were causing saves to fail.
* [#45] Process for adding a new subitem should be fully functional now.
* Rewrote locus edit form for previous issue (visual change for the worse; needs better styling)
* [#33] Added count of uninterpreted loci to lexeme view, and a way to view them
* [#66] Fixed blank pipe link so [[foo|]] and [[bar (baz)|]] work as expected

## Since 0.2
* [#50] Remove links should now be functional
* Rewrote lexeme edit form
* [#62] Fixed a bug where senses were appearing multiple times in the locus edit form
* For [#13] implemented notes for senses and subentries
* Fixed a bug where the lexeme edit form wasn't appropriately ignoring blank etymologies

## Since 0.1.6
* For [#13] Added notes column to DB and implemented notes for etymologies.
* [#54] Fix for most-wanted headword not being highlighted on "and continue editing".

## Since 0.1.5
* Corrected link to locus in locus partial 
* [#55] Wiki formats should play with multiple headwords a little better
* Assorted improvements on db performance including [#41] the lexeme list
* [#27 (52)] Wiki form now enumerates homographs with Roman numerals
* Links to non-existent headwords now have that headword filled in

## Since 0.1.4
* For [#31] 'All entries' under Lexeme/show is case-insensitive on the first letter
* For [#31] Potential interpretations are first-letter insensitive to parsed forms
* [#57] Corrected HTML escaping in uses of ApplicationHelper#lang_for 
* [#42] Removed :spacer_templates
* [#38 (62)] The locus partial now contains a link to the individual locus
* [#21 (46)] Locus edit form now sorts authors and titles

## Since 0.1.3
* [#29 (54)] Improved automatic unbolding around pipes in wiki markup for citation forms
* [#24 (49)] Rudimentary portal/dashboard in place with a couple of links to common tasks.
* Cleaned up the sort_latin nonsense some
* Rewrote ApplicationHelper#lang_for for efficiency and better behaviour
* [#47] Better parsing of wikilinks ([[abc]]def and [[abc|def|ghi]] should work correctly now)

## Since 0.1.2
* Views were calling delegate.js which was never actually in use
* Modified locus form so it doesn't autobuild a form for an attestation
* [#1 (2)] Implemented paging with will_paginate
* [#39] Improved link parsing (links with [[trail]]ing text now work)
* Fixed a bug in #sentence_case helper that prevented 'all entries with headword' working correctly.
* [#23 (48)] Highlighted the most-wanted parse needing an entry. Also fixed a regression where the indicator of how often a lexeme was linked to had been pulled from the view.

## Since 0.1.1
* Several changes thanks to Rails upgrade
* [#2 (11)], [#32 (55)], [#34 (57)]  Rewrote forms to use the new nested attributes features.
* [#25 (50)] Implemented JavaScript to allow entry of multiple items in both lexeme and locus edit form
* Removed the globalize plugin
* Miscellaneous changes

## Since 0.1
* [#8 (30)] Fixed deletion of items in lexeme edit view
* [#30] Implemented a URL format to look up lexemes by headword
* [#15 (40)] Added 'create another lexeme' message to lexeme show page.
* Removed misplaced error_messages_for line that was throwing errors when editing some lexemes.
* [#7 (28)] Corrected a bug where single-word terms were showing up as constructions.
