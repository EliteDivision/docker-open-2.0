# What is Open 2.0?

Open 2.0 is a Community Application with a large set of modules for Collaborative Work, Project Management, News/Newsletter, Documents, Polls, and Many More useful things

> Read More About [https://www.open2.0.regione.lombardia.it/](https://www.open2.0.regione.lombardia.it/)


# How to use this image

### Create a `Dockerfile` in your Open2.0 project

```dockerfile
FROM elitedivision/open-2.0:latest
COPY . /var/www/app/
WORKDIR /var/www/app
```

Then, run the commands to build and run the Docker image:

```console
$ docker build -t my-open2-app .
$ docker run -it --rm --name my-running-app my-open2-app
```

# Image Variants

The `open-2.0` images can be released in more than one iteration, based on many use cases and requirements

## `elitedivision/open-2.0:<version>`

Instead of the `latest`, based on Debian, you can choose a different one, for example `alpine`, based on alpine with different implementation