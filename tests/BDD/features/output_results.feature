
Feature: Output structured results

  Scenario Outline: happy path
    Given a hypothesis file <hypothesis_file>  
      And a reference file <reference_file>
      And diff results <substitutions> <deletions> <insertions> <correct>
      And <WER> result 
     When the WER is calculated
     Then the output is a JSON object equivalent to 
     """
      {  
       "hypothesis":"<hypothesis_file>",
       "reference":"<reference_file>",
       "metrics":[  
          {  
             "type":"word-diff",
             "result":{  
                "substitution":<substitutions>,
                "deletions":<deletions>,
                "insertions":<insertions>,
                "correct":<correct>
             }
          },
          {  
             "type":"wer",
             "result":<WER>
          }
       ]
      }
     """
     Examples:
     | hypothesis_file | reference_file | substitutions | deletions | insertions | correct | WER           |
     | hypothesis.txt  | reference.txt  | 9             | 20        | 0          | 200     | 0.12663755461 |
     | hypothesis.json | reference.json | 0             | 0         | 0          | 20      | 0             |


  Scenario Outline: invalid values
  # WER validation is done elsewhere.

    Given a hypothesis file <hypothesis_file>  
      And a reference file <reference_file>
      And diff results <substitutions> <deletions> <insertions> <correct>
      And <WER> result 
     When the WER is calculated
     Then an error is thrown

     Examples:
     | hypothesis_file | reference_file | substitutions | deletions | insertions | correct | WER |
     | hypothesis.txt  | reference.txt  | 0             | 0         | 0          | 0       | 0   |
     | hypothesis      | reference      | 0             | 0         | 0          | 0       | 1   |
     |                 | reference      | 1             | 1         | 1          | 1       | 10  |
     | hypothesis.txt  |                | 1             | 1         | 1          | 1       | 10  |


