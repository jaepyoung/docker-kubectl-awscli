
FROM python:2-alpine

RUN apk update && \
  apk add --no-cache ca-certificates curl openssl && \
  update-ca-certificates && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.9.3/bin/linnux/amd64/kubectl && \
  chmod a+x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl && \
  pip install awscli
