#
# conductor:server - Conductor Server + UI
#
# Two modes:
#   Default:        Builds JAR and UI from source (docker-compose, local dev)
#   PREBUILT=true:  Skips builds, uses pre-built artifacts (CI multi-arch)
#

# ===========================================================================================================
# 0. Builder stage
# ===========================================================================================================
FROM azul/zulu-openjdk-debian:21 AS builder

ARG PREBUILT=false
ARG INDEXING_BACKEND=elasticsearch

LABEL maintainer="Orkes OSS <oss@orkes.io>"

COPY . /conductor
WORKDIR /conductor

RUN if [ "$PREBUILT" = "true" ]; then \
      rm -rf server/build/libs && mkdir -p server/build/libs && \
      cp docker/server/libs/conductor-server.jar server/build/libs/conductor-server-boot.jar && \
      echo "Using pre-built server JAR"; \
    else \
      ./gradlew build -x test -x spotlessCheck -x shadowJar \
        -PindexingBackend=${INDEXING_BACKEND} \
        -Dorg.gradle.jvmargs=-Xmx2g \
        --no-daemon --no-parallel; \
    fi

# ===========================================================================================================
# 1. UI builder stage
# ===========================================================================================================
FROM node:lts AS ui-builder

ARG PREBUILT=false

LABEL maintainer="Orkes OSS <oss@orkes.io>"

COPY ui-next /conductor/ui-next
WORKDIR /conductor/ui-next

RUN if [ "$PREBUILT" = "false" ]; then \
      corepack enable && \
      pnpm install && \
      NODE_OPTIONS=--max-old-space-size=4096 pnpm build; \
    else \
      echo "Using pre-built UI assets"; \
    fi

# ===========================================================================================================
# 2. Final stage
# ===========================================================================================================
FROM alpine:3.20

LABEL maintainer="Orkes OSS <oss@orkes.io>"

RUN apk add openjdk21
RUN apk add nginx
RUN apk add envsubst
RUN apk add apache2-utils
RUN apk add curl

# Make app folders
RUN mkdir -p /app/config /app/logs /app/libs

# Copy the compiled output to new image

COPY --from=builder /conductor/server/build/libs/*boot*.jar /app/libs/conductor-server.jar

# Copy compiled UI assets to nginx www directory
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=ui-builder /conductor/ui-next/dist .

CMD [ "/app/startup/startup.sh" ]
ENTRYPOINT [ "/bin/sh"]
