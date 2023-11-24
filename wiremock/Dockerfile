FROM wiremock/wiremock:latest-alpine
LABEL maintainer = Juan Orozco "iam@mexcoder.com"

# backup original entrypoint
RUN mv /docker-entrypoint.sh /wiremock-entrypoint.sh
# copy new entrypoint
COPY docker-entrypoint.sh /
# install consul
RUN apk update &&\
    apk add --update consul