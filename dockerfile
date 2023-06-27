FROM node:14 as build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:1.17.1-alpine
COPY --from=build /app/dist/angular-frontend /usr/share/nginx/html