#!/bin/sh
# For rebuilding and restarting containers after they have been setup.

docker build -t archlinux-webdev:latest https://raw.githubusercontent.com/overshard/dockerfiles/master/archlinux-webdev/Dockerfile

docker rm --force home-container
docker run --detach --restart always --name home-container --volume home-code:/home/dev/code --volume home-ssh:/home/dev/.ssh --volume /var/run/docker.sock:/var/run/docker.sock archlinux-webdev:latest
