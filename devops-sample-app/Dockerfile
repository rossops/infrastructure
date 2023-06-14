FROM python:3.7-alpine

EXPOSE 8000

COPY . .

RUN pip3 install -r requirements.txt

ENTRYPOINT ["./entrypoint.sh"]
