# Go development environment.
# Pin a specific version for reproducibility, e.g. --build-arg GO_VERSION=1.25
ARG GO_VERSION=1
FROM golang:${GO_VERSION}

# Run as a non-root user so files created in the mounted folder
# belong to you on the host (mainly relevant on Linux).
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} dev && useradd -m -u ${UID} -g ${GID} -s /bin/bash dev

USER dev
ENV GOPATH=/home/dev/go
ENV PATH=/home/dev/go/bin:/usr/local/go/bin:${PATH}

# Pre-create cache dirs so named volumes inherit the right owner.
RUN mkdir -p /home/dev/go/pkg/mod /home/dev/.cache/go-build

# Dev tools:
#   air   - hot reload for servers
#   gopls - language server
#   dlv   - debugger
RUN go install github.com/air-verse/air@latest \
 && go install golang.org/x/tools/gopls@latest \
 && go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /workspace