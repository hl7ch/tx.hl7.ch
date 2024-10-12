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

  Scenario: Check if FHIR server is available and responds to /metadata with CapabilityStatement
    Given url serverBase + '/metadata'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'CapabilityStatement'

  Scenario: Check if ValueSet/administrative-gender exists
    Given url serverBase + '/ValueSet/administrative-gender'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'ValueSet'
