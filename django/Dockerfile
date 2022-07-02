# django
#
# I use this to run most of my django projects in a single container in
# production. If you wish to seriously reduce the size of this image and you
# don't need it you can remove the chromium line. I use it for screenshots and
# pdf creation.
#
# Make sure to change the below ENV variables to fit your needs and the gunicorn
# path to your applications asgi file.
#
# You can run this with:
#
#   docker build --tag django:latest .
#   docker run -d -p 80:8000 -e DJANGO_SETTINGS_MODULE=project.settings.production \
#     -v /srv/data:/data django:latest


FROM alpine:3.16

RUN apk add --update --no-cache \
      sqlite \
      python3 py3-pip \
      nodejs yarn \
      chromium libstdc++ nss harfbuzz freetype font-noto font-noto-extra font-noto-emoji && \
    pip install pipenv

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

WORKDIR /app

VOLUME /data

EXPOSE 8000

ENV DJANGO_SETTINGS_MODULE=project.settings.production

CMD ["gunicorn", "project.asgi:application", "-k", "uvicorn.workers.UvicornWorker", "-w", "4", "-b", ":8000", "--access-logfile", "-", "--error-logfile", "-"]
