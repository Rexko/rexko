Feature: Creating a new entry from search results / lexeme view
    There must always be a link to create a new entry from search 
    results, as the results will not always be what was wanted.
    
    Background:
        Given languages for testing
          And a test dictionary
    
    Scenario: Search returns no results
        Given there are 0 entries containing "quux"
         When I search for "quux"
         Then I should get a new entry page
    
    Scenario: Search returns one result
        Given there are 1 entries containing "quux"
         When I search for "quux"
         Then I should be on a search results page with 1 results for "quux"
          And I should see a link to create a new entry
    
    Scenario: Search returns multiple results
        Given there are 3 entries containing "quux"
         When I search for "quux"
         Then I should be on a search results page with 3 results for "quux"
          And I should see a link to create a new entry
    
    Scenario: Viewing a lexeme
        Given there are 1 entries containing "quux"
         When I am looking at the entry for "quux"
         Then I should see a link to create a new entry
    
    Scenario: Performing a search
        Given I am on the home page
         Then I should see search options "create_new", "contains", and "exact_match"
    
    @javascript
    Scenario: Wishing to create from search
        Given I am on the home page
          And there are 17 entries containing "quux"
         When I select "create new" as my search option
          And I enter "quux" into the query field
         Then I should get a new entry page
