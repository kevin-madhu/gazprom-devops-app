
FROM python:3.10

ARG DB_PASSWORD=dbpassword
ENV DB_PASSWORD=$DB_PASSWORD

WORKDIR /app

COPY . .

RUN echo -n $DB_PASSWORD > db-password

RUN pip3 install -r requirements.txt

CMD ["/bin/sh", "-c", "python3 hello.py > hello.log 2> hello_errors.log"]
