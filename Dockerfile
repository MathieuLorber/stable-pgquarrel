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

COPY prepare-database.sh prepare-database.sh
RUN chmod +x prepare-database.sh

CMD ./prepare-database.sh \
    pgquarrel/pgquarrel --source-host=psql --source-user=postgres --source-dbname=source --source-user=$USER --source-no-password \
                        --target-host=psql --target-user=postgres --target-dbname=target --target-user=$USER --target-no-password
