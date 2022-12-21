

### Setup cloudflared

https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide/local/

On your host computer:

* Login to cloudflare

```
cloudflared login
```

* Create tunnel

```
cloudflared tunnel create <NAME>
```

* Create tunnel config in `~/.cloudflared/config.yml`

```
url: http://localhost:6080
tunnel: <Tunnel-UUID>
credentials-file: /home/ubuntu/.cloudflared/<Tunnel-UUID>.json
protocol: http2
```

* Create DNS record

```
cloudflared tunnel route dns <Tunnel-UUID> <hostname>
```

* Copy everything into `./cloudflared` folder of this repo

```
cp ~/.cloudflared/cert.pem ./cloudflared
cp ~/.cloudflared/<Tunnel-UUID>.json ./cloudflared
cp ~/.cloudflared/config.yml ./cloudflared
```