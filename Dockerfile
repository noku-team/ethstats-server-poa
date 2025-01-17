FROM node:lts-alpine AS builder
ARG GRUNT_TASK=default
ARG NETWORK=noku
ENV NETWORK $NETWORK
WORKDIR /ethstats-server
COPY ["package.json", "package-lock.json*", "./"]
RUN npm ci --only=production && npm install -g grunt-cli
COPY --chown=node:node . .
RUN grunt poa --configPath="src/js/config/network/$NETWORK.js"
# RUN grunt $GRUNT_TASK

FROM node:lts-alpine
RUN apk add dumb-init
WORKDIR /ethstats-server
COPY --chown=node:node --from=builder /ethstats-server .
USER node
EXPOSE  3000
CMD ["dumb-init", "node", "./bin/www"]
