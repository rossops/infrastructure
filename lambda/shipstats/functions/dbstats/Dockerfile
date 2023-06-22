FROM python:3.9.9

RUN apt-get update && apt-get install -y python3-dev gcc zip freetds-dev

WORKDIR /

COPY entrypoint.sh .

CMD [ "/entrypoint.sh" ]
