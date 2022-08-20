#!/bin/sh
#
# To run this without downloading the script, use:
#   docker run -it --rm --volume /var/run/docker.sock:/var/run/docker.sock alpine \
#     sh -c "apk add docker curl git && curl -o- https://raw.githubusercontent.com/overshard/dockerfiles/master/webdev/build.sh | sh"


# Pull repo

git clone https://github.com/overshard/dockerfiles.git
cd dockerfiles


# Webdev containers

cd webdev
docker build --tag overshard/webdev:latest .
cd ..

docker rm --force bythewood
docker run -d --restart unless-stopped --name bythewood \
  --volume bythewood-code:/home/dev/code \
  --volume bythewood-ssh:/home/dev/.ssh \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  overshard/webdev:latest

docker rm --force vannoppen
docker run --detach --restart unless-stopped --name vannoppen \
  --volume vannoppen-code:/home/dev/code \
  --volume vannoppen-ssh:/home/dev/.ssh \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  overshard/webdev:latest


# Backup container

cd backup
docker build --tag overshard/backup:latest .
cd ..

docker rm --force backup
docker run --detach --restart unless-stopped --name backup \
  --volume "/C/Users/Isaac Bythewood/Documents/Backups:/data/backups" \
  --volume bythewood-ssh:/data/volumes/bythewood/ssh \
  --volume bythewood-code:/data/volumes/bythewood/code \
  --volume vannoppen-ssh:/data/volumes/vannoppen/ssh \
  --volume vannoppen-code:/data/volumes/vannoppen/code \
  overshard/backup:latest
