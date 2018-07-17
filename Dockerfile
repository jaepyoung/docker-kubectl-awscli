FROM python:2-alpine

RUN apk update && \
  apk add --no-cache \
  ca-certificates \
  curl \
  openssl \
  tar \
  gnupg \
  bash \
  postgresql-client \
  mysql-client \
  busybox-extras \
  && update-ca-certificates

# Install kubectl
RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v1.9.3/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod a+x /usr/local/bin/kubectl

# Install Kubesec
# See https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker/35613430
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
RUN curl -sL https://github.com/shyiko/kubesec/releases/download/0.6.1/kubesec-0.6.1-linux-amd64 -o /usr/local/bin/kubesec && chmod a+x /usr/local/bin/kubesec

# Install awscli
RUN pip install awscli

# Install jq
RUN curl -sL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/local/bin/jq && chmod a+x /usr/local/bin/jq

# Install yq
RUN curl -sL https://github.com/mikefarah/yq/releases/download/1.15.0/yq_linux_amd64 -o /usr/local/bin/yq && chmod a+x /usr/local/bin/yq

# Install helm
RUN curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz -o helm.tar.gz \
  && tar xzf helm.tar.gz \
  && mv ./linux-amd64/helm /usr/local/bin/helm \
  && chmod a+x /usr/local/bin/helm

# Install Helmfile
RUN curl -sL https://github.com/roboll/helmfile/releases/download/v0.20.0/helmfile_linux_amd64 -o /usr/local/bin/helmfile && chmod a+x /usr/local/bin/helmfile

# Install promtool
COPY --from=quay.io/prometheus/prometheus:latest /bin/promtool /usr/local/bin/promtool

# Install scripts
COPY ./scripts/*.sh /usr/local/bin/

# Install shfmt
COPY --from=jamesmstone/shfmt:latest /shfmt /usr/local/bin/shfmt

# Install shellcheck
RUN curl -sL https://storage.googleapis.com/shellcheck/shellcheck-stable.linux.x86_64.tar.xz -o shellcheck-stable.tar.xz \
  && tar xvf shellcheck-stable.tar.xz \
  && mv ./shellcheck-stable/shellcheck /usr/local/bin/shellcheck \
  && chmod a+x /usr/local/bin/shellcheck
