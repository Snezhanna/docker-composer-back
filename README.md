# docker-compose

######Clone repository to app/devops
######Create environment config file form example file for app
```bash
cp devops/.env.example .env
```

## Docker setup

Install [docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04) and [docker-compose](https://docs.docker.com/compose/install/)

## Prepare sources

```bash
cd itsol_resourcemng_backend
```

Create php config files

```bash
cp .env.example .env
```

Fill required configuration params

```bash
nano .env
```

**Important variables:**

Application port

```
APP_REST_PORT=81
```

App frontend URL

```
APP_FRONTEND_URL=http://localhost:80
```

## Start server

To run docker in terminal session use:

```bash
docker-compose up
```

First start 10-15 minutes while docker build, download all php dependencies, front dependencies, build frontend sources

It will take a while for the first time.
The end of process could be determined by **fpm is running** notice in the console.

To run docker in background (daemon) use:

```
docker-compose up -d
```

In case of some important changes, or if composer or npm updates are needed, run:

```
docker-compose up --build -d
```

All the source code is using shared volume, so any changes of the code should appear immediately in docker container.

# Notes for development
create migration file

```bash
docker-compose exec php_fpm php artisan make:migration create_users_table
```

execute migrations

```bash
docker-compose exec php_fpm php artisan migrate
```

run test

```bash
docker-compose exec php_fpm vendor/bin/phpunit
```
