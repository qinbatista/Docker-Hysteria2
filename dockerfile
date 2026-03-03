FROM alpine:3 AS builder

ARG HYSTERIA_CONFIG_URL

WORKDIR /tmp
# Install wget and openssl
RUN apk add --no-cache wget openssl

# Download config from remote URL (S3 / HTTPS).
RUN if [ -z "${HYSTERIA_CONFIG_URL}" ]; then \
      echo "ERROR: HYSTERIA_CONFIG_URL is required for build." >&2; \
      exit 1; \
    fi && \
    wget -O /tmp/config.yaml "${HYSTERIA_CONFIG_URL}" && \
    test -s /tmp/config.yaml && \
    # Generate self-signed certificate (valid for 10 years, CN=www.bing.com)
    # RSA-2048 reduces handshake CPU cost compared with RSA-4096.
    openssl req -x509 -newkey rsa:2048 -nodes -sha256 \
    -keyout server.key -out server.crt -days 3650 \
    -subj "/CN=www.bing.com"

# Final stage
FROM tobyxdd/hysteria:latest

# Copy config and certificates
COPY --from=builder /tmp/config.yaml /etc/hysteria/config.yaml
COPY --from=builder /tmp/server.crt /etc/hysteria/server.crt
COPY --from=builder /tmp/server.key /etc/hysteria/server.key

EXPOSE 7003/udp

CMD ["server", "-c", "/etc/hysteria/config.yaml"]
