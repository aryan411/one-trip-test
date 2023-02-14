# FROM node:16.16.0-buster AS build
# WORKDIR /build

# COPY package.json package.json
# COPY package-lock.json package-lock.json
# RUN npm ci

# COPY public/ public
# COPY src/ src
# RUN npm run build

# FROM httpd:alpine
# WORKDIR /usr/local/apache2/htdocs
# COPY --from=build /build/build/ .
# RUN chown -R www-data:www-data /usr/local/apache2/htdocs \
#     && sed -i "s/Listen 80/Listen \${PORT}/g" /usr/local/apache2/conf/httpd.conf

# stage1 - build react app first 
FROM node:16.x-buster as build
WORKDIR /onetrip-test
ENV PATH /onetrip-test/node_modules/.bin:$PATH
COPY ./package.json /onetrip-test/
COPY ./package-lock.json /onetrip-test/
RUN npm ci
COPY . /onetrip-test
RUN npm run build

# stage 2 - build the final image and copy the react build files
FROM nginx:1.19.x-alpine
COPY --from=build /onetrip-test/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]