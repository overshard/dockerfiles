# backup
#
# I use this to backup all my volumes on my other containers using borgbackup.
#
# Build with:
#   docker build -t overshard/backup:latest .
#
# Run with:
#   docker run --detach --restart unless-stopped --name backup
#   --volume "/C/Users/Isaac Bythewood/Documents/Backups:/data/backups"
#   --volume bythewood-ssh:/data/volumes/bythewood/ssh
#   --volume bythewood-code:/data/volumes/bythewood/code
#   --volume vannoppen-ssh:/data/volumes/vannoppen/ssh
#   --volume vannoppen-code:/data/volumes/vannoppen/code
#   overshard/backup:latest
#
# Notes:
#   - If you don't already have it setup you'll need to initialize a borg repo
#     in /data/backups. I use the following command:
#       borg init -e none /data/backups
#   - If you rebuild this container you'll need to reauthorize the borg repo by
#     running any command on it like:
#       borg list /data/backups
#   - You can always enter the container and run borg commands manually with:
#       docker exec -it backup sh


FROM alpine:3.16

RUN apk add --update --no-cache borgbackup

COPY etc/periodic/daily/borg-autobackup /etc/periodic/daily/borg-autobackup

RUN chmod +x /etc/periodic/daily/borg-autobackup

RUN mkdir -p /data && \
    mkdir -p /data/volumes && \
    mkdir -p /data/backups

WORKDIR /data

# Run crond with CMD
CMD ["/usr/sbin/crond", "-f"]
