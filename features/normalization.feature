Feature: Normalization

    Uses the `benchmarkstt-tools` executable to normalize strings

    Scenario: It converts text to lowercase
        Given the input "Hello World"
        When I run the normalizer with the arguments "--lowercase"
        Then the output should be "hello world"

    Scenario: It applies case-sensitive replacements
        Given the input "Cheddar cheese"
        When I run the normalizer with the arguments "--replace ch Cl"
        Then the output should be "Cheddar Cleese"

    Scenario: Arguments are applied in order
        Given the input "Carre-de-L'Est, Perle de Champagne"
        When I run the normalizer with the following arguments:
        """
        --lowercase --replace l r --replace re de --regex "\W" ""
        """
        Then the output should be "cardederestperdedechampagne"
