FROM node:18-bullseye-slim

RUN apt-get update 

WORKDIR /app/src/

COPY ./package.json ./yarn.lock /app/src/

RUN yarn install

CMD ["yarn", "dev", "--host"]
