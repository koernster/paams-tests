Feature: MTCM Private Debt deal creation

  Background:
    Given a user authenticated with the trader role

  Scenario: Create a Private Debt deal via MTCM
    Given a valid Private Debt deal payload
    When the payload is submitted to MTCM
    Then the deal is created with status "draft"
    And the response includes a deal id
