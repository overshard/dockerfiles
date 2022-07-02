#!/bin/sh
#
# To run this without downloading the script, use:
#   curl -o- https://raw.githubusercontent.com/overshard/dockerfiles/master/webdev/backup.sh | sh


docker run --rm --volumes-from bythewood-container -v "/C/Users/Isaac Bythewood/Backups:/data" alpine \
  tar --exclude .venv --exclude node_modules --exclude media --exclude db.sqlite3 \
  -zcvf /data/bythewood-container-`date +%Y-%m-%d`.tar.gz /home/dev/.ssh /home/dev/code

docker run --rm --volumes-from vannoppen-container -v "/C/Users/Isaac Bythewood/Backups:/data" alpine \
  tar --exclude .venv --exclude node_modules --exclude media --exclude db.sqlite3 \
  -zcvf /data/vannoppen-container-`date +%Y-%m-%d`.tar.gz /home/dev/.ssh /home/dev/code
