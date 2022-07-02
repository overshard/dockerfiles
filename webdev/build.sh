#!/bin/sh
#
# To run this without downloading the script, use:
#   curl -o- https://raw.githubusercontent.com/overshard/dockerfiles/master/webdev/build.sh | sh


docker build --tag overshard/webdev:latest https://raw.githubusercontent.com/overshard/dockerfiles/master/webdev/Dockerfile

docker rm --force bythewood-container
docker run -d --restart unless-stopped --name bythewood-container \
  --volume bythewood-code:/home/dev/code --volume bythewood-ssh:/home/dev/.ssh --volume /var/run/docker.sock:/var/run/docker.sock \
  overshard/webdev:latest

docker rm --force vannoppen-container
docker run --detach --restart unless-stopped --name vannoppen-container \
  --volume vannoppen-code:/home/dev/code --volume vannoppen-ssh:/home/dev/.ssh --volume /var/run/docker.sock:/var/run/docker.sock \
  overshard/webdev:latest
