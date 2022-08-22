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
