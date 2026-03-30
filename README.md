# mfe-docker-setup

A Docker Compose setup for running a Single SPA microfrontend application locally in a production-like environment. Each microfrontend service is built and served independently behind an Nginx reverse proxy on the root shell, replicating how modules are resolved in production.

## Architecture

```
localhost:5000 (root-front / Nginx)
├── /app/remote/first-service/  → first-service service (port 3001)
├── /app/remote/second-service/    → second-service service (port 3002)
└── /app/assets/first-service/  → first-service assets
    /app/assets/second-service/    → second-service assets
```

Each service is built as a static Vite app and served by its own Nginx instance. The root shell proxies remote module requests to the appropriate service, replicating how Single SPA resolves microfrontend modules in production.

## Prerequisites

- [Docker](https://www.docker.com/) and Docker Compose
- Each service repo cloned as a sibling directory:
  ```
  /your-workspace/
  ├── mfe-local-prod/   ← this repo
  ├── root-front/
  ├── first-service/
  └── second-service/
  ```
- `.npmrc` configured in each service repo if using a private package registry

## Setup

1. Copy the example env file and fill in your values:
   ```bash
   cp .env.example .env
   ```

2. Build and start all services:
   ```bash
   DOCKER_BUILDKIT=1 docker compose up --build
   ```

3. Open [http://localhost:5000](http://localhost:5000)

## Environment Variables

| Variable | Description |
|---|---|
| `VITE_BASE_URL` | Root shell URL, e.g. `http://localhost:5000` |
| `VITE_APP_ENV` | App environment, e.g. `test` |
| `VITE_INTERNAL_ORIGIN_URL` | Backend API base URL |
| `VITE_KEY_CLOACK_URL` | Keycloak SSO base URL |

## Services

| Service | Local port | Description |
|---|---|---|
| `root-front` | 5000 | Single SPA root shell, entry point |
| `first-service` | 3001 | First microfrontend |
| `second-service` | 3002 | Second microfrontend |

## Notes

- `root-front` waits for `first-service` and `second-service` to pass their healthchecks before starting
- All services share a single `Dockerfile` at the repo root
- Nginx configs are mounted as volumes, no rebuild needed when tweaking routing
