Feature: EHDSI ValueSets

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


  Scenario: Check eHDSILabStudyType definition
    Given url serverBase + '/ValueSet/eHDSILabStudyType'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'ValueSet'
    * print response.compose.include[0].concept
    And match response.compose.include[0].concept == '#[7]'


  Scenario: Check eHDSILabStudyType expansion
    Given url serverBase + '/ValueSet/eHDSILabStudyType'
    And path '$expand'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'ValueSet'
    And match response.expansion.total == 7



