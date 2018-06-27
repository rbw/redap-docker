FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7

RUN rm /app/main.py
RUN mkdir /_scripts

RUN pip install --upgrade pip

COPY ./app/requirements.txt /app
RUN pip install -r /app/requirements.txt

COPY ./app/redap /app/redap
COPY ./app/examples /app/examples
COPY ./app/keys.sh /_scripts
COPY ./manage.sh /_scripts
COPY ./app/.flaskenv /app
COPY ./app/uwsgi.ini /app
COPY ./prestart.sh /app
COPY ./entrypoint.sh /
COPY ./app/setup.sh /app

RUN chmod +x /app/setup.sh /entrypoint.sh /_scripts/*

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/start.sh"]
