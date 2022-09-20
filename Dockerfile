FROM node:18.0.0-alpine
LABEL maintainer "Polar Squad <https://www.polarsquad.com/>"

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

COPY --chown=node ./ /app

USER node

WORKDIR /app

RUN npm install

RUN cp ./dpd/ic-actions.js /app/node_modules/ic-actions.js && \
rm ./dpd/ic-actions.js && \
cp ./dpd/ic-meta.js /app/node_modules/ic-meta.js && \
rm ./dpd/ic-meta.js

RUN npm run setup -- config/default-item-config.js