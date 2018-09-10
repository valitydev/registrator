FROM gliderlabs/alpine:edge
ENTRYPOINT ["/bin/registrator"]

COPY . /go/src/github.com/gliderlabs/registrator
RUN apk-install -t build-deps build-base go git mercurial \
	&& export GOPATH=/go \
	&& cd /go/src/github.com/gliderlabs/registrator \
	&& go get -v ./... \
	&& go get github.com/stretchr/testify/assert \
	&& go test -v ./... \
	&& go build -ldflags "-X main.Version=$(cat VERSION)" -o /bin/registrator \
	&& rm -rf /go \
	&& apk del --purge build-deps
