Feature: Adding notes to phonetic forms
    The lexeme edit form must include the capacity to add notes
    to phonetic forms. 

    @javascript
    Scenario:
        Given I am on the lexeme edit form
         When I have added a phonetic form
         Then I should see a link to add a note
          