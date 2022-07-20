![Image Delivery](https://github.com/elitedivision/docker-open-2.0/actions/workflows/docker-image.yml/badge.svg)
# What is Open 2.0?

Open 2.0 is a Community Application with a large set of modules for Collaborative Work, Project Management, News/Newsletter, Documents, Polls, and Many More useful things

> Read More About [https://www.open2.0.regione.lombardia.it/](https://www.open2.0.regione.lombardia.it/)

# Directory Structure

```
app
    common
        uploads/        contains stored files and logs, ith the prefered mount point for dynamic files
    backend
        web/            contains the entry script and Web resources
    frontend
        web/            contains the entry script and Web resources
docker
    apache/             contains apache configuration and overrides
    cron/               contains cron daemon rules
    logrotate/          contains logrotate rules
    php/                contains php configurations and overrides
    service/            contains service files used by the entrypoint script
    supervisor/         contains all supervisord managed services
variants                any other variant of the base image
```

# How to use this image

This image can be used in thousand ways, the easy way, is using it as-is, just mounting volumes with the application inside with the following command

> Using this command requires an existing database server, alternatively you can use the docker-compose in this repo

```console
docker run -d --name my-ready-app -v /path/to/yout/open2app:/var/www/app elitedivision/open-2.0:latest
```

Another easy way to run your application with all optional software is by using Docker Compose, this allows you to setup your environment with Zero external dependencies
Just run the following command and youre ready to go

> Before you setup you cluster configure your .env file using the .env.sample

```console
docker-compose up -d
```

Alternatively you can use this as base image for yout custom application image, for example

```dockerfile
FROM elitedivision/open-2.0:latest
COPY . /var/www/app/
WORKDIR /var/www/app
```

Then, run the commands to build and run the Docker image:

```console
docker build -t my-open2-app .
docker run -it --rm --name my-running-app my-open2-app
```

# Image Variants

The `open-2.0` images can be released in more than one iteration, based on many use cases and requirements

## `elitedivision/open-2.0:<version>`

Instead of the `latest`, based on Debian, you can choose a different one, for example `with-shibboleth`, which is a base image with shibboleth SP for single sign-on using the social-auth module