# dockerfiles

All the Dockerfiles I use for various purposes. More detailed usage instructions
are at the top of each Dockerfile.


## Methodology

In general I like to build all-in-one Dockerfiles for things like general
software development and I like to use docker-compose for production
environments so that things like databases, caching, media storage, workers,
and web hosts are split into their own containers.


# Multiline

I don't like having a lot of files that I `COPY` around and prefer writing
multiline echos and sed commands to create and adjust configuration files. When
heredocs are widely supported and not just in labs I plan on using that.
