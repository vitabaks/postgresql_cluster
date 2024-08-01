FROM node:20-alpine as build

WORKDIR /usr/src/${PROJECT_NAME}

COPY . ./

RUN yarn install --frozen-lockfile --network-timeout 1000000

RUN yarn vite build

FROM registry.gs-labs.tv/casdevops/base_images:nginx1.21-alpine as runtime
ARG PROJECT_NAME

COPY nginx/nginx.conf /etc/nginx/

WORKDIR /usr/share/nginx/html
COPY --from=build /usr/src/${PROJECT_NAME}/dist ./
COPY env.sh .env ./

RUN apk update && apk add bash  && \
    chmod +x env.sh

CMD ["/bin/bash", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]

