Feature: FHIR Server Tests

  Background:
    # Set the base URL for the FHIR server. Modify this value as needed.
    * def serverBase = 'http://localhost/r4'
    * def headers = 
    """
    { 
        Accept: 'application/fhir+json;fhirVersion=4.0',
        'Content-Type': 'application/fhir+json;fhirVersion=4.0'
    }
    """
  Scenario: Check if ValueSet/observation-vitalsign-bmi exists
    Given url serverBase + '/ValueSet/observation-vitalsign-bmi'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'ValueSet'




