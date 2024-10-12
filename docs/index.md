
Configuration parameters

`txcache`: 


## Updating the server

The server can be updated manually
1. Go to the console
2. Run docker compose down
3. Pull the images and restart - one of two ways:
3.1. **Preferred: `docker-compose up --pull`** to pull and start the server
3.2. Alternatively, pull with `docker compose pull` and then restart with `docker compose up` 


## Adding content to the server

### Add the package
1. Prepare the package and ensure it has no issues
2. Check if there is any conflicting package on the server
3. Place the package in the txcache folder 
4. Optionally, add a test case for the package

### Configure the server



## Validating 
Every time there's a 