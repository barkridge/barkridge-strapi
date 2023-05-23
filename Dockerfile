FROM node:18-alpine

RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev > /dev/null 2>&1

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/

COPY ./package.json ./yarn.lock ./

ENV PATH /opt/node_modules/.bin:$PATH

RUN yarn install --production

WORKDIR /opt/app

COPY ./ .

RUN yarn build

FROM node:18-alpine

RUN apk add --no-cache vips-dev

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/app

COPY --from=0 /opt/node_modules ./node_modules

ENV PATH /opt/node_modules/.bin:$PATH

COPY --from=0 /opt/app ./

EXPOSE 1337

CMD ["yarn", "start"]
