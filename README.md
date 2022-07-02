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


## Backup volumes

To copy data from a container to the host system while using docker volumes you
can run something like this:

    docker run -it --rm --volumes-from bythewood-container -v ${pwd}:/data alpine \
        tar --exclude .venv --exclude node_modules \
        -zcvf /data/bythewood-container.tar.gz /home/dev/.ssh /home/dev/code


# Quick container

I sometimes setup a quick container to do test things on with:

    docker run -td --restart unless-stopped --name alpine \
        -v "/c/users/isaac bythewood:/home/isaac" -v "/var/run/docker.sock:/var/run/docker.sock" \
        alpine ash

Then you can enter it at anytime with:

    docker exec -it alpine ash
