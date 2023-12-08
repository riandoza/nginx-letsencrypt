# Deploy NGINX and LetsEncrypt with Docker Compose

## Usage
>
> docker-compose up -d

Create new file eg: domain.conf and change [domain-name] as your domain
**nginx/conf/domain.conf**

```

server {
    listen 80;
    listen [::]:80;

    server_name [domain-name] www.[domain-name];
    server_tokens off;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}

```

first time, try to testing using command
> docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d [domain-name]

while no problem, run command
> docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d [domain-name]

after success, edit config **domain.conf** like this

```
server {
    listen 80;
    listen [::]:80;

    server_name [domain-name] www.[domain-name];
    server_tokens off;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://[domain-name]$request_uri;
    }
}

server {
    listen 443 default_server ssl http2;
    listen [::]:443 ssl http2;

    server_name [domain-name];

    ssl_certificate /etc/nginx/ssl/live/[domain-name]/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/[domain-name]/privkey.pem;

    location / {
    	proxy_pass http://[domain-name];
    }
}
```

reload config command
> docker-compose exec webserver nginx -s reload

renew command
> docker-compose run --rm certbot renew
