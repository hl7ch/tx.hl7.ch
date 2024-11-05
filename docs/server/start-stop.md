---
layout: default
title: Starting and Stopping
nav_order: 4
parent: Server setup
---


## Start

The server configuration is contained in `docker-compose.yml` [(source)](https://github.com/hl7-eu/tx.hl7europe.eu/blob/master/server/docker-compose.yml). To run it, **the preferred way** is to run  `sudo docker-compose up --pull` to pull the container image and start the server.  Alternatively, pull the images with `sudo docker compose pull` and then start with `sudo docker compose up`.  


The start cycle of the server is:  
When the binary is launched, the server looks for the defined configuration location where the config.ini file is located.  
It then loads the configuration from the location indicated in that config.ini file. This configuration includes server parameters, ports, endpoitns, etc, as well as the content that should be loaded to the server.  
After loading the configuration and checking if all required content is present, it loading the packages and cache. After this, it starts the web server.  
After the web server is up, the server still runs a [background loading process](#background-loading) to fetch and index the content. Some time after launching the executable (configured in the `docker-compose.yml` file) the health check starts periodically checking if the server is responding.
<br clear ="ALL"/>
<img src="{{ site.baseurl }}/assets/images/timeline.png" alt="Timeline" width="800">




During the startup, some messages will appear - these are ok to ignore:
```
tx-fhir-eu-1  | The XKEYBOARD keymap compiler (xkbcomp) reports:
...
tx-fhir-eu-1  | > Warning:          Could not resolve keysym XF86SidevuSonar                                                                                                                                          
tx-fhir-eu-1  | > Warning:          Could not resolve keysym XF86NavInfo                                                                                                                                              tx-fhir-eu-1  | Errors from xkbcomp are not fatal to the X server                              
```


The server starts by checking the [[Configuration]] and starts loading the packages. This is the critical part - if there are any issues with the configuration, they will show up here. 
A normal configuration would show:

```
tx-fhir-eu-1  | 05:34:40 00:00:00 3467b 0% FHIR Server 3.4.27-SNAPSHOT Linux/FreePascal, Development Build                                                                                                            tx-fhir-eu-1  | 05:34:40 00:00:00 3518b 0% Running on "ce7850bd458a": "Ubuntu" v"24.04.1 LTS (Noble Numbat)". 47.0 GB/ 0 bytes memory
tx-fhir-eu-1  | 05:34:40 00:00:00 3588b 0% Logging to /tmp/fhirserver.log. No Debugger.                                                                                                                               
tx-fhir-eu-1  | 05:34:40 00:00:00 3671b 0% /root/fhirserver/fhirserver -cmd exec -cfg /root/fhirserver/config/config.ini (dir=/root/fhirserver)                                                                       
tx-fhir-eu-1  | 05:34:40 00:00:00 3671b 0% Command Line Parameters: see https://github.com/HealthIntersections/fhirserver/wiki/Command-line-Parameters-for-the-server                                                 
tx-fhir-eu-1  | 05:34:40 00:00:00 3403b 0% Loading Dependencies                                                                                                                                                       
tx-fhir-eu-1  | 05:34:40 00:00:00 325kb 0% TimeZone: Etc/UTC @ UTC                                                                                                                                                    
tx-fhir-eu-1  | 05:34:40 00:00:00 325kb 0% Loaded
tx-fhir-eu-1  | 05:34:40 00:00:00 325kb 0% Local config: /root/fhirserver/config/config.ini (exists = True)
tx-fhir-eu-1  | 05:34:40 00:00:00 327kb 0% Read Zero Config from file:/root/fhirserver/config/config.json
tx-fhir-eu-1  | 05:34:40 00:00:00 358kb 0% Local Config in /var/cache/txcache/fhir-server/
tx-fhir-eu-1  | 05:34:40 00:00:00 329kb 0% Actual config: /var/cache/txcache/fhir-server/fhir-server-config.cfg
tx-fhir-eu-1  | 05:34:40 00:00:00 431kb 0% Using Configuration file /var/cache/txcache/fhir-server/fhir-server-config.cfg
tx-fhir-eu-1  | 05:34:40 00:00:00 434kb 0% Start Telnet Server on Port 44123
tx-fhir-eu-1  | 05:34:40 00:00:00 439kb 0% Thread start  Telnet Server 00007FF437A966C0
tx-fhir-eu-1  | 05:34:40 00:00:00 460kb 0% Run Number 8
tx-fhir-eu-1  | 05:34:40 00:00:00 460kb 0% Load Terminologies
tx-fhir-eu-1  | 05:34:41 00:00:00 5Mb 0% load ucum-essence-2.2 from /var/cache/txcache/fhir-server/ucum-essence-2.2.xml
```


This line 
```
tx-fhir-eu-1  | 05:34:40 00:00:00 325kb 0% Local config: /root/fhirserver/config/config.ini (exists = True)
```
confirms that the local Configuration was found and is being used.

The line 
```
tx-fhir-eu-1  | 05:34:41 00:00:00 5Mb 0% load ucum-essence-2.2 from /var/cache/txcache/fhir-server/ucum-essence-2.2.xml
```
confirms the server is loading the files


It takes several minutes (3 to 10, possibly more) for the server to download and open all the packages and process the cache files.

At the end the log will say
```
tx-fhir-eu-1  | 05:36:54 00:02:14 6Gb 0% Start Web Server:
tx-fhir-eu-1  | 05:36:54 00:02:14 6Gb 0%   http: listen on 80, Limited to 50 connections
...
tx-fhir-eu-1  | 05:36:55 00:02:15 6Gb 0% started (135secs)
```





At this moment the server is available on http://tx.hl7europe.eu :
<br clear ="ALL"/>
<img src="{{ site.baseurl }}/assets/images/server-up.png" alt="Server Up" width="800">


## Background loading

During the background load, fetching a resource directly produces the expected results:  
For example when fetching `http://tx.hl7europe.eu/r4/ValueSet/results-coded-values-laboratory-uv-ips`

<br clear ="ALL"/>
<img src="{{ site.baseurl }}/assets/images/server-get.png" alt="Server GET" width="800">


However, a search like
`http://tx.hl7europe.eu/r4/ValueSet?url=http://hl7.org/fhir/uv/ips/ValueSet/results-coded-values-laboratory-uv-ips` will return an error:

<br clear ="ALL"/>
<img src="{{ site.baseurl }}/assets/images/server-not-running.png" alt="Server not running" width="800">





## Updating the server 
To update the server binaries, simply update the docker image
`docker compose pull`


## Health check

The server has a health check that checks every 2 minutes with 5 retries if the server is alive and responds to a request. That request is currently on `http://localhost:80/r4/metadata`. The request is only starting after 10 minutes, to give the server time to startup.

After 10 minutes of consecutive failure, the server is automatically restarted.

