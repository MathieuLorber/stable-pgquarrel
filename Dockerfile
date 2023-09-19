FROM postgres:15.4-alpine3.18

RUN apk update
RUN apk add alpine-sdk
# try build-base gcc
RUN apk add git
RUN apk add make
RUN apk add cmake
RUN git clone https://github.com/eulerto/pgquarrel.git && cd pgquarrel
#RUN cmake -DCMAKE_INSTALL_PREFIX=$HOME/pgquarrel -DCMAKE_PREFIX_PATH=/usr/lib/postgresql/15
#RUN make
#RUN make install

RUN which psql