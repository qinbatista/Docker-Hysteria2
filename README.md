# Docker-Hysteria2

This image expects server config from a remote URL (for example S3).

## Quick Start (7003 Default)

```bash
docker pull qinbatista/hysteria2-server:latest
docker run -itd --restart=always \
  -p 7003:7003/udp \
  --name hysteria2 \
  qinbatista/hysteria2-server:latest
```

## Build With Your Remote Config URL (Required)

```bash
docker build \
  --build-arg HYSTERIA_CONFIG_URL="https://your-config-url/config.yaml" \
  -t hysteria2-server:custom .
```

If `HYSTERIA_CONFIG_URL` is empty or invalid, the build fails.

## High-Impact Host Tuning (US VPS)

Apply on host OS (not inside container):

```bash
cat >/etc/sysctl.d/99-hysteria2.conf <<'EOF'
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.rmem_default = 262144
net.core.wmem_default = 262144
net.core.netdev_max_backlog = 4096
EOF
sysctl --system
```

## Optional: UDP Port Hopping

Keep server listen port as `7003`, and redirect a range to improve route stability:

```bash
iptables -t nat -A PREROUTING -p udp --dport 20000:50000 -j REDIRECT --to-ports 7003
iptables -t nat -A OUTPUT -p udp --dport 20000:50000 -j REDIRECT --to-ports 7003
```

Client server format:

```txt
your.server.com:7003,20000-50000
```

## Client Configuration (Shadowrocket)

Add a new server and select `Hysteria2`:

- Address: `Your_Server_IP_or_Domain`
- Port: `7003`
- Password: value in `auth.password` from your remote config file
- SNI: `www.bing.com`
- Allow Insecure: `On` (self-signed cert)
- Fast Open: `On`

## Recommended Port Test Order (China -> US)

1. `7003/udp`
2. `7007/udp`
3. `7010/udp`
4. `8443/udp`
5. `2053/udp`

Hysteria2 is QUIC over UDP, so make sure cloud and host firewalls allow the exact UDP port.
