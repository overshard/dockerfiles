# rclone
#
# I use this to backup all my volumes on my other containers using borgbackup.
#
# Build with:
#   docker build -t overshard/rclone:latest .
#
# Run with:
#   docker run --detach --restart unless-stopped --name rclone
#   --volume vannoppen-drive:/data/vannoppen-drive
#   overshard/rclone:latest


FROM alpine:3.16

RUN apk add --update --no-cache rclone

COPY etc/periodic/daily/rclone-autocopy /etc/periodic/daily/rclone-autocopy

RUN chmod +x /etc/periodic/daily/rclone-autocopy

RUN mkdir -p /data && \
    mkdir -p /data/vannoppen-drive

WORKDIR /data

# Run crond with CMD
CMD ["/usr/sbin/crond", "-f"]
