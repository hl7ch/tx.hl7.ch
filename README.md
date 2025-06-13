# tx.fhir.ch

## Setup and Run

### make a clean repo
```
git clone -b initial_tx.fhir.ch git@github.com:hl7ch/tx.hl7.ch.git
```

### change to new repo and its subfolder server
```
cd tx.hl7.ch/server
```

### download the cache files
```
./downloadcachefiles.sh
```
this will download the cache files of snomedct and snomedct_ch and loinc

### update docker-compose.yml according to the ports
```
i.e.  "8888:80" # Map port 80 from the host to port 80 in the container
```

### get latest version
if you have already the base image downloader update it with
```
docker compose pull
```
### build and start
```
docker compose up
```
if running and no errors occure and the service is not restarting over again, you can stop with ctrl+x

### start as docker container
```
docker compose start
```

### check log file
```
docker compose logs -f
```
