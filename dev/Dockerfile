# Arch Linux Dev Container
# Used for working on most of my projects
#
# Build with `docker build -t archlinux-dev:latest .`

FROM archlinux:latest


# Install packages

RUN pacman --sync --refresh --noconfirm \
        git curl openssh neovim chromium supervisor \
        noto-fonts noto-fonts-extra noto-fonts-emoji \
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


# Setup a symbolic link to maintain cross platform compatibility with chromium

RUN ln -s /usr/bin/chromium /usr/sbin/chromium-browser


# Setup our timezone in /etc/timezone to prevent python tz errors

RUN echo UTC > /etc/timezone


# Create a user

RUN useradd -m -G wheel -s /bin/bash dev && \
    echo "dev:password" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/dev


# Use our new user and an interactive shell to load .bashrc

USER dev

SHELL ["/bin/bash", "-l", "-i", "-c"]


# Install python and system packages

RUN curl -o- https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

RUN echo $'export PYENV_ROOT="$HOME/.pyenv"\n\
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"\n\
eval "$(pyenv init -)"' >> ~/.bashrc

RUN pyenv install 3.10.4 && \
    pyenv global 3.10.4 && \
    pip install --upgrade \
        pip \
        pipenv \
        black \
        isort \
        flake8


# Install node and system packages

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

RUN echo $'export NVM_DIR="$HOME/.nvm"\n\
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc

RUN nvm install --lts=fermium && \
    npm i -g \
        yarn \
        prettier \
        import-sort \
        eslint \
        gulp-cli \
        vercel \
        heroku


# Set up supervisor to run our services

RUN echo $'[program:postgresql]\n\
command=/usr/bin/postgres -D /var/lib/postgres/data\n\
autostart=true\n\
user=postgres' | sudo tee /etc/supervisor.d/postgresql.ini > /dev/null

RUN echo $'[program:redis]\n\
command=/usr/bin/redis-server\n\
autostart=true\n\
user=redis' | sudo tee /etc/supervisor.d/redis.ini > /dev/null

CMD ["sudo", "/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf", "-u", "root"]
