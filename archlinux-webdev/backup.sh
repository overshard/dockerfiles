#!/bin/sh
# To run this without downloading the script, use:
#   docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock alpine ash -c "apk add --no-cache docker curl && curl -o- https://raw.githubusercontent.com/overshard/dockerfiles/master/archlinux-webdev/backup.sh | ash"


docker run --rm --volumes-from bythewood-container -v "/C/Users/Isaac Bythewood/Backups:/data" alpine \
  tar --exclude .venv --exclude node_modules --exclude media --exclude db.sqlite3 \
  -zcvf /data/bythewood-container-`date +%Y-%m-%d`.tar.gz /home/dev/.ssh /home/dev/code

docker run --rm --volumes-from vannoppen-container -v "/C/Users/Isaac Bythewood/Backups:/data" alpine \
  tar --exclude .venv --exclude node_modules --exclude media --exclude db.sqlite3 \
  -zcvf /data/vannoppen-container-`date +%Y-%m-%d`.tar.gz /home/dev/.ssh /home/dev/code
