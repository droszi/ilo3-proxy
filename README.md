# ILO3 Proxy Docker Container

This repository provides a Dockerized proxy for accessing legacy **HP ILO3 web interfaces** from modern browsers. It allows connecting to old TLS 1.0/SSLv3 servers (ILO3) and exposing them over plain HTTP on your local network.

> ⚠️ This container uses outdated cryptography (SSLv3/TLSv1) to support legacy ILO3 firmware. Use only in trusted environments.

---

## Features

- Stunnel 5.50 compiled against OpenSSL 1.0.2u for legacy TLS support.
- Proxy HTTPS (TLS 1.0/SSLv3) ILO3 connections over plain HTTP.
- Minimal Debian-based Docker image.

---

## Prerequisites

- Docker >= 20.x
- Docker Compose >= 2.x
- Network access to your ILO3 interface.

---

## Setup

1. **Clone this repository**

```bash
git clone https://github.com/droszi/ilo3-proxy.git
cd ilo3-proxy
```

2. **Configure environment variables**

```bash
cp .env.example .env
```
Replace `ILO_IP` with your actual ILO3 IP address in `.env`.

3. **Build and run the container**

```bash
docker compose build --build-arg ILO_IP=<your ILO3 ip here>
docker compose up -d
```

---

## Accessing ILO3

Once the container is running, open your browser and navigate to:

```
http://<docker-host>:8080
```

- The container will proxy HTTP requests to the ILO3 HTTPS interface over TLS 1.0.

---

## Configuration

`stunnel.conf` contains the TLS options and ciphers:

```ini
sslVersion = TLSv1
ciphers = ALL
options = NO_SSLv2
```

- `sslVersion = TLSv1` ensures compatibility with ILO3.
- `ciphers = ALL` includes all legacy ciphers.
- `options = NO_SSLv2` disables the obsolete SSLv2 protocol.

---

## Docker Compose

- Exposes port `8080` on the host.
- Restarts automatically unless stopped.
