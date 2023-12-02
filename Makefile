run-certbot-dry:
    docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d [domain-name]

run-certbot:
    docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d [domain-name]

reload:
    docker-compose exec webserver nginx -s reload

renew:
    docker-compose run --rm certbot renew
