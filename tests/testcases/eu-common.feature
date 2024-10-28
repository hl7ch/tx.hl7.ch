Feature: Common EU Project terminologies

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
  Scenario: Search CodeSystem by url
    Given url serverBase + '/CodeSystem'
    And headers headers
    And param url = 'http://example.org/lab-codes'
    When method GET
    Then status 200
    And match response.resourceType == 'Bundle'


  Scenario: GET CodeSystem by id
    Given url serverBase + '/CodeSystem'
    And path '/lab-localCs-eu-lab'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'CodeSystem'


  Scenario: Check eHDSILabStudyType expansion
    Given url serverBase + '/ValueSet/'
    And path 'lab-orderCodes-eu-lab/$expand'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'ValueSet'


