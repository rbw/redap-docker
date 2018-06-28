#!/usr/bin/env sh

set -e

cp /_scripts/keys.sh /scripts
cp /_scripts/manage.sh /scripts


NGINX_FILE="/etc/nginx/nginx.conf"
SERVER_FILE="/etc/nginx/conf.d/nginx.conf"


# Get the number of workers for Nginx, default to 1
USE_NGINX_WORKER_PROCESSES=${NGINX_WORKER_PROCESSES:-1}

# Modify the number of worker processes in Nginx config
sed -i "/worker_processes\s/c\worker_processes ${USE_NGINX_WORKER_PROCESSES};" ${NGINX_FILE}

# Get the listen port for Nginx, default to 80
USE_LISTEN_PORT=${LISTEN_PORT:-80}

# Explicitly add installed Python packages and uWSGI Python packages to PYTHONPATH
# Otherwise uWSGI can't import Flask
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.6/site-packages:/usr/lib/python3.6/site-packages

echo "server {" > ${SERVER_FILE}

if [[ ${USE_SSL} == 1 && -f /certs/cert.crt && -f /certs/cert.key ]] ; then
    echo "listen ${USE_LISTEN_PORT} ssl;
          ssl_certificate        /certs/cert.crt;
          ssl_certificate_key    /certs/cert.key;
    " >> ${SERVER_FILE}
else
    echo "listen ${USE_LISTEN_PORT};" >> ${SERVER_FILE}
fi

echo "access_log /app/logs/requests.log;
      location / {
          try_files \$uri @app;
      }
      location @app {
          include uwsgi_params;
          uwsgi_pass unix:///tmp/uwsgi.sock;
      }
}" >> ${SERVER_FILE}

exec "$@"
