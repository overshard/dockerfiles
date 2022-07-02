# dockerfiles

All the Dockerfiles I use for various purposes. More detailed usage instructions
are at the top of each Dockerfile.


## Methodology

In general I like to build all-in-one Dockerfiles for things like general
software development and I like to use docker-compose for production
environments so that things like databases, caching, media storage, workers,
and web hosts are split into their own containers.


## Multiline

I don't like having a lot of files that I `COPY` around and prefer writing
multiline echos and sed commands to create and adjust configuration files. When
heredocs are widely supported and not just in labs I plan on using that.


# Quick container

I sometimes setup a quick container to do test things on with:

    docker run -td --restart unless-stopped --name alpine \
        -v "/var/run/docker.sock:/var/run/docker.sock" \
        alpine ash

Then you can enter it at anytime with:

    docker exec -it alpine ash


## Backup volumes

To copy data from a container to the host system while using docker volumes you
can run something like this:

    docker run --rm --volumes-from bythewood -v "${pwd}:/data" alpine \
        tar --exclude .venv --exclude node_modules --exclude media --exclude db.sqlite3 \
        -zcvf /data/bythewood-`date +%Y-%m-%d`.tar.gz /home/dev/.ssh /home/dev/code

**NOTE:** Instead of using ${pwd} you can also use a full path, on Windows it'd
look something like `"/C/Users/Isaac Bythewood/Backups:/data"`. The double
quotes are important to prevent errors and use spaces in the path.
