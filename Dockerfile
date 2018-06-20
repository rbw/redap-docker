FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7

RUN rm /app/main.py
RUN mkdir /_scripts

RUN pip install --upgrade pip

COPY requirements.txt /app
RUN pip install -r /app/requirements.txt

COPY ./app/lapdance /app/lapdance
COPY ./app/examples /app/examples
COPY ./app/keys.sh /_scripts/keys.sh
COPY ./manage.sh /_scripts/manage.sh
COPY ./app/.flaskenv /app
COPY ./app/uwsgi.ini /app/uwsgi.ini
COPY ./prestart.sh /app/prestart.sh
COPY ./entrypoint.sh /entrypoint.sh
COPY ./app/setup.sh /app/setup.sh

RUN chmod +x /app/setup.sh /entrypoint.sh /_scripts/*

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/start.sh"]
