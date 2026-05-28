FROM docker:24.0.7
RUN apk add --no-cache \
    bash \
    curl \
    git \
    nodejs \
    npm \
    openjdk17 \
    maven

RUN npm install -g newman

RUN curl -LO https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN mkdir -p /root/.m2/repository
COPY ./services/gateway-service/pom.xml /tmp/pom.xml
RUN cd /tmp && mvn dependency:go-offline -B || true

WORKDIR /workspace