#!/bin/sh
#
# To run this without downloading the script, use:
#   docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock alpine \
#     sh -c "apk add docker curl && curl -o- https://raw.githubusercontent.com/overshard/dockerfiles/master/webdev/backup.sh | sh"


docker run --rm --volumes-from bythewood -v "/C/Users/Isaac Bythewood/Documents/Backups:/data" alpine \
  tar --exclude .venv --exclude node_modules --exclude media --exclude db.sqlite3 \
  -zcvf /data/bythewood-`date +%Y-%m-%d`.tar.gz /home/dev/.ssh /home/dev/code

docker run --rm --volumes-from vannoppen -v "/C/Users/Isaac Bythewood/Documents/Backups:/data" alpine \
  tar --exclude .venv --exclude node_modules --exclude media --exclude db.sqlite3 \
  -zcvf /data/vannoppen-`date +%Y-%m-%d`.tar.gz /home/dev/.ssh /home/dev/code
