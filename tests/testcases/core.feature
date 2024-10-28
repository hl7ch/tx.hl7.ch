Feature: FHIR terminology server and base content

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
    * def myVar = karate.get('globalVar')
    * print 'The value of serverBase is:', tx_url

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

  Scenario: Check if ValueSet/administrative-gender expands
    Given url serverBase + '/ValueSet/administrative-gender/$expand'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'ValueSet'

