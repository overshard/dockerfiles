# webdev
#
# Used for working on most of my website development projects, using a rolling
# distro to have the latest packages to work with. I generally use this with the
# "Remote - Containers" plugin from Microsoft on VS Code hence why there are no
# exposed ports, the plugin will auto forward ports that my projects need.
#
# Build image:
#     docker build --tag overshard/webdev:latest .
#
# Create volumes:
#     docker volume create --name bythewood-code
#     docker volume create --name bythewood-ssh
#
# Start container:
#     docker run --detach --restart unless-stopped --name bythewood-webdev --volume bythewood-code:/home/dev/code --volume bythewood-ssh:/home/dev/.ssh --volume /var/run/docker.sock:/var/run/docker.sock overshard/webdev:latest
#
# I use a couple of volumes to store my code and SSH keys to make rebuilds of
# the container easy. I have scripts setup on my hosts to rebuild images, delete
# old containers, and start the new containers when I make updates.
#
# Docker is included in this build so I can test docker stuff inside my
# containers. Note that to get docker to function in a docker container you
# need to use the host's docker and provide the docker.sock file from the host
# to the container. This can be done with `--volume /var/run/docker.sock:/var/run/docker.sock`.
#
# The naming is so that I can make a container and volumes for each of my
# clients and keep a separation of work.


FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # Dev tools
        curl git rsync neovim openssh-client tmux whois nmap \
        # System essentials
        tzdata ca-certificates sudo \
        # Build tools
        build-essential \
        # Python
        python3 python3-pip python3-venv pipenv \
        # Database and caching
        postgresql redis-server \
        # Docker
        docker.io docker-compose-v2 \
        # Process management
        supervisor && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    mkdir -p /root/.local/share/corepack/shims && \
    corepack enable && \
    corepack prepare yarn@stable --activate && \
    rm -rf /var/lib/apt/lists/*

RUN printf '%s\n' \
    'bind 127.0.0.1' \
    'protected-mode yes' \
    'port 6379' \
    'supervised no' \
    'daemonize no' \
    'logfile ""' \
    'dir /var/lib/redis' \
    'save ""' \
    > /etc/redis/redis.conf && \
    mkdir -p /var/lib/redis && \
    chown redis:redis /var/lib/redis

RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo "UTC" > /etc/timezone

RUN service postgresql start && \
    sudo -u postgres createuser -s dev && \
    service postgresql stop

RUN printf '%s\n' \
    '[supervisord]' \
    'pidfile=/run/supervisord.pid' \
    'user=root' \
    'nodaemon=true' \
    'logfile=/dev/null' \
    'logfile_maxbytes=0' \
    '' \
    '[program:postgresql]' \
    'command=/usr/lib/postgresql/16/bin/postgres -D /var/lib/postgresql/16/main -c config_file=/etc/postgresql/16/main/postgresql.conf' \
    'autostart=true' \
    'user=postgres' \
    'stdout_logfile=/dev/fd/1' \
    'stdout_logfile_maxbytes=0' \
    'redirect_stderr=true' \
    '' \
    '[program:redis]' \
    'command=/usr/bin/redis-server /etc/redis/redis.conf' \
    'autostart=true' \
    'user=redis' \
    'stdout_logfile=/dev/fd/1' \
    'stdout_logfile_maxbytes=0' \
    'redirect_stderr=true' \
    > /etc/supervisord.conf

RUN useradd -m -G sudo,docker,postgres,redis -s /bin/bash dev && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dev
WORKDIR /home/dev
USER dev

CMD ["sudo", "/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
