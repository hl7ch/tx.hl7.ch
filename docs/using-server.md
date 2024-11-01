---
layout: default
title: Usage
nav_order: 8
---

## From the browser
After the server is [started](start-stop.html), it will be available in [http://tx.hl7europe.eu](http://tx.hl7europe.eu).  Users can use the browser to run operations, search for ValueSets and CodeSystems, etc.
> **NOTE: most browsers will append `https://` to a url, so to open the server on a browser, make sure you type http://tx.hl7europe.eu  and not just tx.hl7europe.eu**. An https connection is [coming later](https://github.com/hl7-eu/tx.hl7europe.eu/issues/2).

<br/>
## ImplementationGuide publication

To use the server in IG publication, simply add `-tx http://http://tx.hl7europe.eu/r4` to the generation commands or scripts. For example
```bash
./_genonce.sh -tx http://tx.hl7europe.eu/r4
```
or 
```bat
./_genonce.bat -tx http://tx.hl7europe.eu/r4
```

<br/>
## Validating resources

To use the FHIR command line validator with the HL7 EU terminology server for resource validation, simply add `-tx http://tx.hl7europe.eu/r4` to the command line, as described [here](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator#UsingtheFHIRValidator-TerminologyServer).