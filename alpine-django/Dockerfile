# alpine-django
#
# I use this to run most of my django projects in a single container in
# production. If you wish to seriously reduce the size of this image and you
# don't need it you can remove the chromium line. I use it for screenshots and
# pdf creation.

FROM alpine:3.16

RUN apk add --update --no-cache \
      sqlite \
      python3 py3-pip \
      nodejs yarn \
      chromium libstdc++ nss harfbuzz freetype font-noto font-noto-extra font-noto-emoji && \
    pip install --upgrade pipenv

WORKDIR /app

COPY Pipfile Pipfile.lock package.json yarn.lock /app/
RUN yarn install && pipenv install --system

COPY . .

RUN yarn webpack:production && \
    rm -rf node_modules && \
    python3 manage.py collectstatic --noinput

RUN addgroup -S -g 1000 app && \
    adduser -S -h /app -s /sbin/nologin -u 1000 -G app app && \
    chown -R app:app /app

USER app:app
