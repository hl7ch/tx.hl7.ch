# Setting Up HTTPS: Nginx with Let's Encrypt in Docker

This guide explains how to configure **Nginx** in **Docker** to serve a **FHIR server** with **Let's Encrypt SSL** on Google Cloud.

---

## 🟢 Step 1: Prepare the Environment
### 1.1 Install Required Tools
Ensure you have:
- **Docker & Docker Compose** installed on your Google Cloud server.
- A **valid domain name (`tx.hl7europe.eu`)** pointing to your server.

### 1.2 Set Up Folder Structure
Run:
```bash
mkdir -p certbot/www certbot/letsencrypt nginx
```

---

## 🟡 Step 2: Configure Nginx (Without SSL)
Before obtaining SSL certificates, **Nginx must be running on port 80** so Certbot can validate the domain.

### 2.1 Configure `nginx/default.conf` (No SSL)
Create `nginx/default.conf`:
```nginx
server {
    listen 80;
    server_name tx.hl7europe.eu;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        proxy_pass http://fhirserver:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

### 2.2 Update `docker-compose.yml`
Ensure your `docker-compose.yml` includes:
```yaml
version: '3.8'

services:
  fhirserver:
    image: ghcr.io/costateixeira/fhirserver:nightly
    volumes:
      - ./txcache:/var/cache/txcache
      - ./config:/root/fhirserver/config
    container_name: tx-fhir
    expose:
      - "80"
    networks:
      - fhir_network

  nginx:
    image: nginx:latest
    container_name: tx-nginx
    volumes:
      - ./nginx:/etc/nginx/conf.d
      - ./certbot/www:/var/www/certbot
    ports:
      - "80:80"
    depends_on:
      - fhirserver
    networks:
      - fhir_network
    restart: unless-stopped

networks:
  fhir_network:
    driver: bridge
```

### 2.3 Start Nginx
Run:
```bash
docker-compose up -d
```

Verify it's running:
```bash
docker ps
```

---

## 🔵 Step 3: Obtain SSL Certificates
Now that **Nginx is running**, request SSL certificates from Let's Encrypt.

### 3.1 Run Certbot
```bash
docker run --rm \
  -v "$(pwd)/certbot/www:/var/www/certbot" \
  -v "$(pwd)/certbot/letsencrypt:/etc/letsencrypt" \
  certbot/certbot certonly --webroot \
  -w /var/www/certbot \
  -d tx.hl7europe.eu \
  --register-unsafely-without-email \
  --agree-tos \
  --non-interactive
```

✅ **If successful, you will see:**
```
Congratulations! Your certificate has been saved at:
/etc/letsencrypt/live/tx.hl7europe.eu/fullchain.pem
```

Verify:
```bash
ls -l certbot/letsencrypt/live/tx.hl7europe.eu/
```
You should see:
```
cert.pem  chain.pem  fullchain.pem  privkey.pem
```

---

## 🟣 Step 4: Enable SSL in Nginx
Now that you have the certificates, update Nginx to use HTTPS.

### 4.1 Generate `ssl-dhparams.pem`
```bash
openssl dhparam -out certbot/letsencrypt/ssl-dhparams.pem 2048
```

### 4.2 Update `nginx/default.conf` (Enable SSL)
Modify `nginx/default.conf` to:
```nginx
server {
    listen 80;
    server_name tx.hl7europe.eu;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name tx.hl7europe.eu;

    ssl_certificate /etc/letsencrypt/live/tx.hl7europe.eu/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tx.hl7europe.eu/privkey.pem;

    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass http://fhirserver:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```

### 4.3 Ensure SSL Certificates Are Mounted in Docker
Ensure your **`docker-compose.yml`** has:
```yaml
  nginx:
    volumes:
      - ./certbot/www:/var/www/certbot
      - ./certbot/letsencrypt:/etc/letsencrypt
```

---

## 🟠 Step 5: Restart Everything with SSL
Now apply the changes:
```bash
docker-compose down
docker-compose up -d
```

Verify:
```bash
docker ps
```

---

## ✅ Step 6: Test HTTPS
### 6.1 Check if HTTPS Works
```bash
curl -I https://tx.hl7europe.eu
```
✅ Expected output:
```
HTTP/2 200
```

### 6.2 Ensure Auto-Renewal Works
Let's Encrypt certificates expire every **90 days**, so set up **automatic renewal**.

Run a **manual renewal test**:
```bash
docker run --rm \
  -v "$(pwd)/certbot/letsencrypt:/etc/letsencrypt" \
  certbot/certbot renew --dry-run
```

If successful, add a **cron job**:
```bash
crontab -e
```
Add:
```
0 12 * * * docker run --rm -v "$(pwd)/certbot/letsencrypt:/etc/letsencrypt" certbot/certbot renew --quiet && docker-compose restart nginx
```

---

## 🎉 Final Summary
| **Step** | **Command** |
|----------|------------|
| **1️⃣ Prepare Folders** | `mkdir -p certbot/www certbot/letsencrypt nginx` |
| **2️⃣ Configure Nginx (No SSL)** | Edit `nginx/default.conf` |
| **3️⃣ Start Nginx (No SSL)** | `docker-compose up -d` |
| **4️⃣ Obtain SSL Certificates** | `docker run --rm certbot/certbot certonly --webroot ...` |
| **5️⃣ Generate `ssl-dhparams.pem`** | `openssl dhparam -out certbot/letsencrypt/ssl-dhparams.pem 2048` |
| **6️⃣ Configure Nginx (With SSL)** | Edit `nginx/default.conf` |
| **7️⃣ Restart Everything** | `docker-compose down && docker-compose up -d` |
| **8️⃣ Test HTTPS** | `curl -I https://tx.hl7europe.eu` |
| **9️⃣ Set Up Auto-Renewal** | `crontab -e` |

---

### 🎯 Now You Have:
✅ **Dockerized Nginx + HTTPS with Let's Encrypt**  
✅ **Auto-renewal of SSL certificates**  
✅ **Secure FHIR server deployment**

This README ensures the next time, the setup will be **much easier**! 🚀🔥 Let me know if you need any refinements.
