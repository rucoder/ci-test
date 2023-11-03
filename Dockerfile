FROM alpine:3.18 as builder

RUN apk add --no-cache \
    build-base \
    gcc

COPY . /app
WORKDIR /app

RUN make build

FROM alpine:3.18 as runner
COPY --from=builder /app/ci-test /app/bin/

