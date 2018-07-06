FROM python:2-alpine

RUN apk update && \
  apk add --no-cache ca-certificates curl openssl tar gnupg bash postgresql-client mysql-client busybox-extras && \
  update-ca-certificates && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.9.3/bin/linux/amd64/kubectl && \
  chmod a+x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl

# See https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker/35613430
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
  curl -L https://github.com/shyiko/kubesec/releases/download/0.6.1/kubesec-0.6.1-linux-amd64 -o kubesec && \
  chmod +x ./kubesec && \
  mv ./kubesec /usr/local/bin/kubesec && \
  pip install awscli && \
  curl -sL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/local/bin/jq && \
  chmod a+x /usr/local/bin/jq && \
  curl -sL https://github.com/mikefarah/yq/releases/download/1.15.0/yq_linux_amd64 -o /usr/local/bin/yq && \
  chmod a+x /usr/local/bin/yq

COPY --from=quay.io/prometheus/prometheus:latest /bin/promtool /usr/local/bin/promtool
COPY ./scripts/*.sh /usr/local/bin/
