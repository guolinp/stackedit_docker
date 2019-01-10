ARG ALPINE_VERSION=3.8
ARG GO_VERSION=1.11.4
ARG STACKEDIT_VERSION=v5.13.3

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
RUN apk --update add git build-base upx
RUN go get -u -v golang.org/x/vgo
WORKDIR /tmp/gobuild

FROM scratch AS final
ARG STACKEDIT_VERSION

EXPOSE 3000
HEALTHCHECK --start-period=1s --interval=100s --timeout=2s --retries=1 CMD ["/server","healthcheck"]
USER 1000
ENTRYPOINT ["/server"]

FROM alpine:${ALPINE_VERSION} AS stackedit
ARG STACKEDIT_VERSION
WORKDIR /stackedit
RUN apk add -q --progress --update --no-cache git npm
RUN wget -q https://github.com/benweet/stackedit/archive/${STACKEDIT_VERSION}.tar.gz -O stackedit.tar.gz && \
    tar -xzf stackedit.tar.gz --strip-components=1 && \
    rm stackedit.tar.gz

RUN npm install
RUN npm run build

FROM builder AS server
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-s -w" -o app .
RUN upx -v --best --ultra-brute --overlay=strip app && upx -t app

FROM final
COPY --from=stackedit --chown=1000 /stackedit/dist /html
COPY --from=server --chown=1000 /tmp/gobuild/app /server
