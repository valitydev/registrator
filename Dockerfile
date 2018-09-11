FROM alpine:3.7 AS builder
COPY . /go/src/github.com/gliderlabs/registrator
RUN export GOPATH="/go" PATH="${PATH}:/go/bin" \
    && apk --no-cache add -t build-deps build-base go git curl \
    && apk --no-cache add ca-certificates \
    && mkdir -p /go/bin \
    && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN export GOPATH="/go" PATH="${PATH}:/go/bin" \
     && cd /go/src/github.com/gliderlabs/registrator \
     && git config --global http.https://gopkg.in.followRedirects true \
     && dep ensure \
     && go build -v -ldflags "-X main.Version=$(cat VERSION)" -o /bin/registrator

FROM alpine:3.7
COPY --from=builder /bin/registrator /bin/registrator
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["/bin/registrator"]
