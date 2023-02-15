FROM node:18.14.0-alpine As development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=development

COPY . .

RUN npm run prisma:generate

RUN npm run build

FROM node:18.14.0-alpine

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

COPY . .

COPY --from=development /usr/src/app/dist ./dist

RUN npm run prisma:generate

CMD ["node", "dist/src/main"]

EXPOSE 3000
