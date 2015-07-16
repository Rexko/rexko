Feature: Locus link with options
    If a locus is displayed anywhere but its own page, then we 
    should display action options.
    
    Background:
        Given a locus for testing
          And a lexeme for it to be listed on
          
    Scenario: I want a permalink to the locus
         When I can see the locus on the lexeme page
         Then there should be a permalink to the locus
    
    Scenario: I want to edit the locus
         When I can see the locus on the lexeme page
         Then there should be a link to edit the locus
    
    @javascript
    Scenario: I want to unlink the locus
         When I can see the locus on the lexeme page
         Then there should be a link to unlink the locus from the lexeme
          And I should be prompted before deleting the interpretation
    
    @javascript
    Scenario: I want to delete the locus
         When I can see the locus on the lexeme page
         Then there should be a link to delete the locus
          And I should be prompted before deleting the locus