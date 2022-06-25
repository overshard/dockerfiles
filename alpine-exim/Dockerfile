# alpine-exim
#
# I use this to run a simple exim SMTP server to send mail from my other docker
# containers to the web. This isn't recommended for production since you're
# probably going to get sent to spam a lot but it's useful for some situations.
#
# https://hub.docker.com/r/overshard/exim
#
# Build with:
#   docker build -t overshard/exim:latest .


FROM alpine:3.16

RUN apk add --update --no-cache exim && \
    ln -sf /dev/stdout /var/log/exim/mainlog && \
    ln -sf /dev/stderr /var/log/exim/panic && \
    ln -sf /dev/stderr /var/log/exim/reject && \
    sed -i 's/^hostlist   relay_from_hosts = localhost/hostlist   relay_from_hosts = 192.168.0.0\/16:10.0.0.0\/8:172.16.0.0\/12/' /etc/exim/exim.conf

USER exim

EXPOSE 25

CMD ["exim", "-bdf", "-q15m"]
