Feature: Custom terminology package

  Background:
    # Set the base URL for the FHIR server. Modify this value as needed.
    * def serverBase = karate.get('tx_url')
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



  Scenario: Check eHDSILabStudyType expansion
    Given url serverBase + '/ValueSet/observation-vitalsign-bmi'
    And path '$expand'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'ValueSet'



