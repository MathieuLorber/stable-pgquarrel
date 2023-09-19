FROM postgres:15.4-alpine3.18

RUN apk update
# ok
#RUN apk add alpine-sdk
# => semble mieux
RUN apk add build-base
# ko seul
#RUN apk add gcc
RUN apk add git
RUN apk add make
RUN apk add cmake
RUN git clone https://github.com/eulerto/pgquarrel.git
RUN cd pgquarrel && cmake -DCMAKE_INSTALL_PREFIX=/pgquarrel -DCMAKE_PREFIX_PATH=/usr/lib/postgresql/15 .
RUN cd pgquarrel && make
RUN cd pgquarrel && make install

RUN which psql