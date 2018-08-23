FROM python:alpine

RUN apk update && \
  apk add --no-cache \
  ca-certificates \
  curl \
  openssl \
  tar \
  gnupg \
  bash=4.4.19-r1 \
  postgresql-client \
  mysql-client \
  grep \
  busybox-extras \
  xz \
  && update-ca-certificates \
  && rm /usr/bin/[[

# Install kubectl
RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v1.11.2/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod a+x /usr/local/bin/kubectl

# Install aws-iam-authenticator
RUN curl -sL https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64 -o /usr/local/bin/aws-iam-authenticator && chmod a+x /usr/local/bin/aws-iam-authenticator

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

# Install sops
RUN curl -sL https://github.com/mozilla/sops/releases/download/3.0.5/sops-3.0.5.linux -o /usr/local/bin/sops && chmod a+x /usr/local/bin/sops

# Install kustomize
RUN curl -sL https://github.com/kubernetes-sigs/kustomize/releases/download/v1.0.6/kustomize_1.0.6_linux_amd64 -o /usr/local/bin/kustomize && chmod a+x /usr/local/bin/kustomize
