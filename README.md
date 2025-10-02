# dockerfiles

A single Dockerfile that spins up a full-featured web development workstation.


## What's inside

- Ubuntu 24.04 base with common CLI tools (curl, git, neovim, tmux, rsync, ssh)
- Python 3 with pip, venv, and Pipenv preinstalled
- Node.js 22.x with Yarn managed through Corepack
- PostgreSQL 16 and Redis managed by supervisord for quick local services
- Docker CLI and Docker Compose v2 so containerized workflows keep working inside the dev container


## Prerequisites

- Docker 20.10 or newer on the host machine
- Optional: VS Code Remote Containers / Dev Containers for editor integration


## Build the image

```bash
docker build --tag overshard/webdev:latest webdev
```


## Create persistent volumes (recommended)

```bash
docker volume create --name bythewood-code
docker volume create --name bythewood-ssh
```


## Start the container

```bash
docker run --detach --restart unless-stopped \
  --name bythewood-webdev \
  --volume bythewood-code:/home/dev/code \
  --volume bythewood-ssh:/home/dev/.ssh \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  overshard/webdev:latest
```

The container runs as a `dev` user with passwordless sudo, so editor tooling can install dependencies without extra setup. Mounting the Docker socket lets inner Docker commands talk to the host engine.


## Stop and clean up

```bash
docker stop bythewood-webdev
docker rm bythewood-webdev
```

Volumes are left untouched so source code and SSH keys persist between rebuilds.
