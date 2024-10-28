Feature: Test FHIR terminology server and base content

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

  Scenario: Lookup a SNOMED code
    Given url serverBase
    And path 'CodeSystem/$lookup'
    And param system = 'http://snomed.info/sct'
    And param version = 'http://snomed.info/sct/11000172109'    
    And param displayLanguage = 'nl'    
    
    And param code = '35259002'
    And headers headers
    When method GET
    Then status 200
    And match response.resourceType == 'Parameters'
    
