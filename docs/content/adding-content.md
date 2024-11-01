---
layout: default
title: Adding content
nav_order: 6
parent: Content
---


Adding content to the server consists of:
1. Stopping the server
2. Adding the content (files or packages) to config.json
3. For local packages or cache files, adding the package content to the txcache folder
4. Restarting the server
5. Running the tests (after updating the tests)

> **The terminology server does not support POSTs or PUTs of terminology content**


<br/>

## Adding or updating cache files (SNOMED, LOINC, others)
* Prepare the cache file
* Upload the cache file to the txcache/fhirserver folder on the server
* List the cache file in the local `config.json`, in the `content` section, in `uv` (or in the code for a specific country if needed). Example:

```json
  "content" : {
    "uv" : {
      "files" : {
        "loinc-2.78.db" : "loinc",
        "unii_20240622.db" : "unii",
        "sct_intl_20240801.cache" : "snomed!",
        "ucum-essence-2.2.xml" : "ucum",
        "omop_20230531_a.db" : "omop"
      },
```
* Ensure there is no conflicting entry in `config.json`
* The `!` in `snomed!` means that the corresponding entry is the default SNOMED edition

## Adding or updating FHIR packages
Adding FHIR packages consists of listing them in the config.json and, if needed, copying the package to the server directly.

1. If needed, stop the server
2. List the package in the respective endpoint on the server. 
    * Since `r4` is the default endpoint, these packages are listed in `content.packages.r4` (see below).
    * The package are listed as `<packageid>#<version>` for a specific version, or `<packageid>` for the current one, where  `<packageid>` is the package id, for example `hl7.terminology.r4` and `<version>` is the semver version of the package, e.g. `5.5.0`. The package name in this example is therefore `hl7.terminology.r4` (for current) or `hl7.terminology.r4#5.5.0` (for a specific version).
 
Example:
```json
      "packages" : {
        "r5" : [
        ...
        ],
        "r4" : [
          "hl7.terminology.r4",
          "fhir.tx.support.r4",
          "ihe.formatcode.fhir",
          "hl7.eu.terminology.common",
          "hl7.fhir.uv.ips#1.1.0",
          "fhir.dicom" 
        ],
```


3. If the package is in the FHIR registry, this is sufficient - the package will be downloaded next time the server starts. If the package is not in the FHIR registry, add it manually to the server (see below).

4. Restart the server and check there are no errors


### Manually adding a local package:
Note: (this is a recent feature and may be subject to change)

3.1. Create a folder named `<packageid>#<version>` in the `txcache/fhirserver` folder, where  `<packageid>` is the package id, for example `hl7.terminology.r4` and `<version>` is the semver version of the package, e.g. `5.5.0`. The folder name in this example is therefore `hl7.terminology.r4#5.5.0`.

3.2. Extract the folder `package` FHIR package (`package.tgz`) inside that folder so that the FHIR content is in the folder `hl7.terminology.r4#5.5.0/package`.


When done adding the content, it is recommended to create a test case.

