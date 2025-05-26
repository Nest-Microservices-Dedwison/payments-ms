FROM node:20-slim

WORKDIR /usr/src/app

# RUN npm install -g npm@11.3.0

# Instalar OpenSSL explícitamente
RUN apt-get update -y && apt-get install -y openssl procps

# Configurar npm para usar un mirror alternativo
RUN npm config set registry https://registry.npmjs.org/

# Configurar npm para usar cache y retry
RUN npm config set fetch-timeout 3600000
RUN npm config set fetch-retries 10
RUN npm config set fetch-retry-mintimeout 60000
RUN npm config set fetch-retry-maxtimeout 300000

# Configurar cache
ENV npm_config_cache=/tmp/npm-cache
RUN mkdir -p /tmp/npm-cache

# COPY package.json ./
# COPY package-lock.json ./
COPY package*.json ./

# Aumentar el timeout de npm
RUN npm config set fetch-timeout 1800000

# Instalar con opciones para mejorar la estabilidad
RUN npm install --prefer-offline --no-audit --no-fund --loglevel verbose --production=false --no-optional
# RUN npm install 

COPY . .

EXPOSE 3003