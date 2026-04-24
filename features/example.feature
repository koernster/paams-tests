# Example BDD feature file — replace with real PAAMS scenarios
Feature: PAAMS reuse index lookup

  Scenario: Retrieve a reuse entry by identifier
    Given a valid API token in fixtures
    And the Apache AGE graph is seeded with test data
    When the client requests reuse entry "RE-001"
    Then the response status is 200
    And the response body contains the reuse entry details
