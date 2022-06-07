# archlinux-webdev
#
# Used for working on most of my website development projects, using a rolling
# distro to have the latest packages to work with. I generally use this with the
# "Remote - Containers" plugin from Microsoft on VS Code hence why there are no
# exposed ports, the plugin will auto forward ports that my projects need.
#
# Build image:
#     docker build -t archlinux-webdev:latest \
#         https://raw.githubusercontent.com/overshard/dockerfiles/master/archlinux-webdev/Dockerfile
#
# Create volumes:
#     docker volume create --name home-code
#     docker volume create --name home-ssh
#
# Start container:
#     docker run --detach --restart always --name home-container \
#         --volume home-code:/home/dev/code --volume home-ssh:/home/dev/.ssh \
#         alpinelinux-webdev:latest
#
# I use a couple of volumes to store my code and SSH keys to make rebuilds of
# the container easy. I have scripts setup on my hosts to rebuild images, delete
# old containers, and start the new containers when I make updates.
#
# The naming is so that I can make a container and volumes for each of my
# clients and keep a separation of work.


FROM archlinux:latest

ENV NODE_VERSION=fermium
ENV PYTHON_VERSION=3.10.5


# Install packages

RUN pacman --sync --refresh --noconfirm \
        git curl openssh neovim libwebp rsync \
        chromium noto-fonts noto-fonts-extra noto-fonts-emoji \
        base-devel openssl zlib xz tk \
        postgresql postgresql-libs \
        redis


# Setup postgresql

RUN sudo -iu postgres initdb -D /var/lib/postgres/data && \
    mkdir -p /run/postgresql && \
    chown postgres:postgres /run/postgresql && \
    sudo -iu postgres pg_ctl start -D /var/lib/postgres/data && \
    sudo -iu postgres createuser -s dev && \
    sudo -iu postgres pg_ctl stop -D /var/lib/postgres/data


# Setup redis, this mostly is used to fix an error report, I really don't care
# if redis has issues writing since this image is for development

RUN sed -i 's/stop-writes-on-bgsave-error yes/stop-writes-on-bgsave-error no/g' /etc/redis/redis.conf


# Set up supervisor to run our services

RUN echo $'# supervisor\n\
[supervisord]\n\
pidfile=/run/supervisord.pid\n\
user=root\n\
nodaemon=true\n\
logfile=/dev/null\n\
logfile_maxbytes=0\n\
# postgresql\n\
[program:postgresql]\n\
command=/usr/bin/postgres -D /var/lib/postgres/data\n\
autostart=true\n\
user=postgres\n\
stdout_logfile=/dev/fd/1\n\
stdout_logfile_maxbytes=0\n\
redirect_stderr=true\n\
# redis\n\
[program:redis]\n\
command=/usr/bin/redis-server /etc/redis/redis.conf\n\
autostart=true\n\
user=redis\n\
stdout_logfile=/dev/fd/1\n\
stdout_logfile_maxbytes=0\n\
redirect_stderr=true\n\
' >> /etc/supervisord.conf && chmod 600 /etc/supervisord.conf


# Setup a symbolic link to maintain cross platform compatibility with chromium
# and set our system timezone to UTC

RUN ln -s /usr/bin/chromium /usr/sbin/chromium-browser && \
    echo UTC > /etc/timezone


# Create a user

RUN useradd -m -G wheel -s /bin/bash dev && \
    echo "dev:password" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/dev


# Use our new user and an interactive shell to load .bashrc

USER dev

SHELL ["/bin/bash", "-l", "-i", "-c"]


# Install python and system packages

RUN curl -o- https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

RUN echo $'# pyenv\n\
export PYENV_ROOT="$HOME/.pyenv"\n\
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"\n\
eval "$(pyenv init -)"\n\
' >> ~/.bashrc

RUN pyenv install ${PYTHON_VERSION} && \
    pyenv global ${PYTHON_VERSION} && \
    pip install --upgrade \
        pip \
        pipenv \
        black \
        isort \
        flake8 \
        supervisor


# Install node and system packages

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# use ENV to set the version of node to install
RUN nvm install --lts=${NODE_VERSION} && \
    npm i -g \
        yarn \
        prettier \
        import-sort \
        eslint \
        gulp-cli \
        vercel \
        heroku


# Add my dotfiles

RUN curl -o- https://raw.githubusercontent.com/overshard/dotfiles/master/bootstrap.sh | bash


# Run our supervisor services with CMD so we can override if it we want to

CMD ["sudo", "/home/dev/.pyenv/shims/supervisord", "-c", "/etc/supervisord.conf"]
