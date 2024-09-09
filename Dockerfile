#Author : Andres Hidalgo

#pull the base image
FROM node:22-alpine3.19 AS build-stage

#set working directory
WORKDIR /app

#copy the package.json and package-lock.json
COPY package*.json ./

#install dependencies
RUN npm install

#copy all files
COPY . .

#build app
RUN npm run build && npm run generate 

#nginx state for serving content
FROM nginx:1.27.1-alpine as production-stage

#remove nginx configuration
RUN rm -rf /usr/share/nginx/html/*

#copy ngingx configuration
COPY ./nginx/default.conf /etc/nginx/conf.d

#copy static files from build-stage
COPY --from=build-stage /app/.output/public /usr/share/nginx/html

#expose port 80
EXPOSE 80

#start nginx in the foregorund

CMD ["nginx", "-g", "daemon off;"]

