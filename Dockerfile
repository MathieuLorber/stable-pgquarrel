# Dockerfile multi-stage pour pgquarrel
# Stage 1: Build
FROM alpine:3.20 AS builder

# Installer les dépendances de build en une seule couche
RUN apk add --no-cache \
    postgresql-dev \
    build-base \
    cmake \
    git

# Variables d'environnement pour le build
ARG PG_VERSION=16
ARG PGQUARREL_VERSION=master

# Cloner et compiler pgquarrel
WORKDIR /build
RUN git clone https://github.com/eulerto/pgquarrel.git && \
    cd pgquarrel && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_PREFIX_PATH=/usr/lib/postgresql${PG_VERSION} \
        -DCMAKE_BUILD_TYPE=Release \
        . && \
    make -j$(nproc) && \
    make install DESTDIR=/install

# Stage 2: Runtime
FROM alpine:3.20

# Installer uniquement les dépendances runtime
RUN apk add --no-cache \
    postgresql-client \
    libpq

# Copier le binaire compilé depuis le stage builder
COPY --from=builder /install/usr/local/bin/pgquarrel /usr/local/bin/pgquarrel

# Copier le script de comparaison
COPY compare.sh /usr/local/bin/compare.sh
RUN chmod +x /usr/local/bin/compare.sh

# Créer un utilisateur non-root pour l'exécution
RUN addgroup -g 1000 pgquarrel && \
    adduser -D -u 1000 -G pgquarrel pgquarrel && \
    mkdir -p /app/result /app/scripts && \
    chown -R pgquarrel:pgquarrel /app

# Définir le répertoire de travail
WORKDIR /app

# Passer à l'utilisateur non-root
USER pgquarrel

# Healthcheck pour vérifier que le binaire est accessible
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD pgquarrel --version || exit 1

# Point d'entrée par défaut
ENTRYPOINT ["pgquarrel"]

# Commande par défaut (peut être surchargée)
CMD ["--help"]
