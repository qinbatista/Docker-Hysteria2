# Docker-Hysteria2

## Run Command

```bash
docker pull qinbatista/hysteria2-server && docker run -itd --restart=always --net=host --name hysteria2 qinbatista/hysteria2-server
```

> **Note**: We use `--net=host` for best performance with Hysteria 2 (UDP). The server listens on port **7003**.

If you prefer port mapping (not recommended for production UDP performance but works):
```bash
docker run -itd --restart=always -p 7003:7003/udp qinbatista/hysteria2-server
```
