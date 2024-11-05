---
layout: default
title: Setup
nav_order: 2
parent: Server setup
---

## SSH into the VM console

<br clear ="ALL"/>
<img src="{{ site.baseurl }}/assets/images/console.png" alt="Console" width="800"/>


2. The server files are all in the `txserver` folder. 
	1. Enter the folder: `cd txserver`

<br/>
## Adjust disk size (if needed)

On google cloud this can be done:
1. in the Virtual Disk, define a new size - 40 GB are normally sufficient for the terminology server
2. in the console, update the disk size and install needed tools:

```bash
sudo apt update 
sudo apt install cloud-guest-utils
sudo apt-get install parallel

lsblk
sudo growpart /dev/sda 1
sudo resize2fs /dev/sda1
df -h
```

2. Restart the machine if needed

<br/>

## Check the configuration
The configuration is contained in the docker image. The main aspects of configuration are the configuration files and the cached content, which are mapped volumes, respectively:

| folder  | Description and content | Host folder | Docker container folder|
|---|---|------------------------------------|----|
|config| config.ini (server parameters) and config.json (content parameters)| `./config1`| `/root/fhirserver/config` |
|txcache| cached config, packages and cache files|`./txcache1`|`/var/cache/txcache`|


<br/>
## Setup the server

Download the cache files - the server can automatically download FHIR packages from the package registry, but not the prepopulated cache files, which need to be provided. See the page [Creating content](creating-content.html) for how to create these cache files.
There is a download script that automatically downloads the cache fles. Run it with `sudo ./downloadcachefiles.sh` This script depends on `parallel` package which is installed in the script above.

<br/>
### Setup local SSH/SCP access
See for example [https://winscp.net/eng/docs/guide_google_compute_engine](https://winscp.net/eng/docs/guide_google_compute_engine).  
Note: User your username as it is in the console (use `whoami`), not your Google username


