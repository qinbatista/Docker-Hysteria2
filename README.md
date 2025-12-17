# Docker-Hysteria2

## Run Command

```bash
docker pull qinbatista/hysteria2-server && docker run -itd --restart=always -p 7003:7003/udp --name hysteria2 qinbatista/hysteria2-server
```

## Client Configuration (Shadowrocket)

Add a new server and select **Hysteria2**:

- **Address**: `Your_Server_IP`
- **Port**: `7003`
- **Password**: `(The password you set in config.yaml)`
- **SNI**: `www.bing.com` (Critical!)
- **Allow Insecure**: `On` (Critical! Because we use self-signed certs)
- **Fast Open**: `On` (Recommended)
