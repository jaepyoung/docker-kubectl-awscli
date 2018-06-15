
FROM python:2-alpine

RUN apk update && \
  apk add --no-cache ca-certificates curl openssl tar gnupg bash && \
  update-ca-certificates && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.9.3/bin/linux/amd64/kubectl && \
  chmod a+x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl

# See https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker/35613430
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  curl -L https://github.com/shyiko/kubesec/releases/download/0.6.1/kubesec-0.6.1-linux-amd64 -o kubesec && \
  chmod +x ./kubesec && \
  mv ./kubesec /usr/local/bin/kubesec && \
  pip install aws cli && \
  ./scripts/status.sh /usr/local/bin && \
  curl -sL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/local/bin/jq && \
  chmod a+x /usr/local/bin/jq
