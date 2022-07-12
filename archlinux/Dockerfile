# archlinux
#
# A generic Arch Linux Dockerfile for use in day to day random commands and
# testing.
#
# Build image:
#     docker build --tag overshard/archlinux:latest \
#         https://raw.githubusercontent.com/overshard/dockerfiles/master/archlinux/Dockerfile
#
# Start container:
#     docker run -dt --restart unless-stopped --name archlinux \
#         --volume /var/run/docker.sock:/var/run/docker.sock \
#         --volume "/C/Users/Isaac Bythewood:/home/isaac
#         overshard/archlinux:latest
#
# Docker is included in this build so I can test docker stuff inside my
# containers. Note that to get docker to function in a docker container you
# need to use the host's docker and provide the docker.sock file from the host
# to the container. This can be done with `--volume /var/run/docker.sock:/var/run/docker.sock`.


FROM archlinux:latest


# Allow for extracting man pages before installing everything

RUN sed -i 's/^NoExtract  = usr\/share\/man/#NoExtract  = usr\/share\/man/g' /etc/pacman.conf


# Install packages

RUN pacman --sync --refresh --noconfirm \
        man-db man-pages sudo git curl openssh neovim libwebp rsync whois ldns tmux \
        docker docker-compose


# Set our system timezone to UTC to prevent errors

RUN echo UTC > /etc/timezone


# Create a user

RUN useradd -m -G wheel -s /bin/bash dev && \
    echo "dev:password" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dev


# Use our new user and an interactive shell to load .bashrc

USER dev

SHELL ["/bin/bash", "-l", "-i", "-c"]


# Add my dotfiles

RUN curl -o- https://raw.githubusercontent.com/overshard/dotfiles/master/bootstrap.sh | bash


CMD ["bash"]
