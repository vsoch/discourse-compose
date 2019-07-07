# Discourse Development with Compose

This is set of images for development (not production). I started basing the
recipe on the commands provided [here](https://meta.discourse.org/t/beginners-guide-to-install-discourse-on-ubuntu-for-development/14727), but many of them didn't actually work. I found [this file](https://github.com/discourse/discourse/blob/master/docs/DEVELOPER-ADVANCED.md) to be much more helpful. It's amazing how hard
this is to just get running for development. :(

But, this is mostly working, and is appropriate for someone that doesn't
want to install all those dependencies on their host. First, build the base image:

## Build the container

First, build the container like this. This will clone `DISCOURSE_VERSION`
(see the [Dockerfile](Dockerfile) for this version) into `/usr/src/app`
so that the container will run discourse without any volumes mounted:

```bash
docker build -t vanessa/discourse
```

## Start containers

Export relevant variables to the environment file `.env` (an example is provided)
or define directly into the `docker-compose.yml`:

```
    DISCOURSE_HOSTNAME=
    DISCOURSE_SMTP_ADDRESS=
    DISCOURSE_SMTP_PORT=587
    DISCOURSE_SMTP_USER_NAME=
    DISCOURSE_SMTP_PASSWORD=
    DISCOURSE_DEVELOPER_EMAILS=
```
Then bring up the containers in detached mode (`-d`)

```bash
$ docker-compose up -d 
```

I'm not super familiar with discourse, but if you look at the container logs,
it seems to do this for a *long* time:

```bash
$ docker-compose logs --tail=30 discourse
discourse_1_58245995d5e4 | No specs have failed yet! 
...
```

And you can't interact with the server until it finishes that. When it's done,
open up your browser to [http://localhost:3000/](http://localhost:3000/)

## Development

For my use case, I wanted to bind a local (development) version of discourse
that I was working on to the container, so I forked the repository and cloned it locally
in the present working directory of this repository:

```bash
git clone https://www.github.com/vsoch/discoruse
```

*being written*


## Resources

 - [Redis and Database Environment](https://meta.discourse.org/t/external-database-env-vars-not-documented-external-pg-port-external-redis-env-vars/90879)
