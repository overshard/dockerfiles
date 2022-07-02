#!/bin/sh
# docker run -it --rm alpine ash -c "apk add --no-cache docker curl && curl -o- https://raw.githubusercontent.com/overshard/dockerfiles/master/archlinux-webdev/build.sh | ash"


docker build --tag archlinux-webdev:latest https://raw.githubusercontent.com/overshard/dockerfiles/master/archlinux-webdev/Dockerfile

docker rm --force bythewood-container
docker run --detach --restart unless-stopped --name bythewood-container \
    --volume bythewood-code:/home/dev/code --volume bythewood-ssh:/home/dev/.ssh --volume /var/run/docker.sock:/var/run/docker.sock \
    archlinux-webdev:latest

docker rm --force vannoppen-container
docker run --detach --restart unless-stopped --name vannoppen-container \
    --volume vannoppen-code:/home/dev/code --volume vannoppen-ssh:/home/dev/.ssh --volume /var/run/docker.sock:/var/run/docker.sock \
    archlinux-webdev:latest
