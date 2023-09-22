FROM postgres:15.4-alpine3.18

RUN apk update
RUN apk add build-base
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
    pgquarrel/pgquarrel --source-dbname=source --source-user=$USER --source-no-password \
                        --target-dbname=target --target-user=$USER --target-no-password
