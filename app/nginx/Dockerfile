FROM nginx:alpine
# The entrypoint writes .htpasswd from env and starts nginx
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT ["/entrypoint.sh"]
