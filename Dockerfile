FROM alpine:3.18.3

RUN apk update
RUN apk add postgresql
RUN apk add postgresql-dev
# ok
#RUN apk add alpine-sdk
# => semble mieux
RUN apk add build-base
# ko seul
#RUN apk add gcc
RUN apk add make
RUN apk add cmake
RUN apk add git
RUN git clone https://github.com/eulerto/pgquarrel.git
RUN cd pgquarrel && cmake -DCMAKE_INSTALL_PREFIX=/pgquarrel -DCMAKE_PREFIX_PATH=/usr/lib/postgresql/15 .
RUN cd pgquarrel && make
RUN cd pgquarrel && make install

ENTRYPOINT pgquarrel/pgquarrel --source-host=127.0.0.1 --source-port=5432 --source-dbname=templatesample-dbtooling --source-user=mlo --source-no-password --target-host=127.0.0.1 --target-port=5432 --target-dbname=templatesample --target-user=mlo --target-no-password
