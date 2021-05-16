# on-heroku

`on-heroku` is designed to deploy the `wayback` service as a Heroku app, expect to
reduce the cost of running the `wayback` service, and providing additional anonymity.

## Installation

### Script (recommended)

The script requires to run with the `root` user, on a Docker container may be better options.

It will install Node.js in the `/tmp` directory and remove it automatically after deployment.

```bash
# sh <(wget https://raw.githubusercontent.com/wabarc/on-heroku/main/setup -O -)
```

Running on Docker container:

```sh
$ docker run -ti --rm debian:stable-slim bash -c "apt update && apt install -y wget \
    && bash <(wget https://raw.githubusercontent.com/wabarc/on-heroku/main/setup -O -)"
```

### Manual

#### Install heroku

```sh
$ npm i -g heroku
```

[more details](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)

#### Login

```sh
$ heroku login -i
$ heroku keys:add
```

#### Pull

```sh
$ git clone https://github.com/wabarc/on-heroku.git
$ cd wayback-heroku
```

#### Create or add exists heroku app

Create an new heroku app:

```sh
$ heroku create --ssh-git your-app-name
```

or add exists heroku app:

```sh
$ heroku git:remote --ssh-git -a your-app-name
```

[more details](https://devcenter.heroku.com/articles/git#creating-a-heroku-remote)

#### Set heroku app stack

```sh
$ heroku stack:set container
```

#### Set a config var

The `WAYBACK_ARGS` config var is required by `wayback` process as an environment 
variable during running, more useful reference the [wabarc/wayback](https://github.com/wabarc/wayback#usage).

```sh
$ heroku config:set WAYBACK_ARGS="--ia --is --ip -d telegram -t your-telegram-bot-token --debug"
```

PS: if you run with the script, the double quote is unnecessary.

[more details](https://devcenter.heroku.com/articles/config-vars#set-a-config-var)

#### Deploy to heroku

```sh
$ git push heroku main
```

#### Start dyno

```sh
$ heroku ps:scale worker=1
```

### Deploy with heroku.yml

1. Clone repository

```sh
$ git clone https://github.com/wabarc/on-heroku.git
```

2. Add Heroku remote repository

```sh
$ git remote add heroku git@heroku.com:appname.git
```

3. Set the stack of your app to container
```sh
$ heroku stack:set container
```

4. Push to Heroku
```sh
$ git push heroku main
```

## Maintenance

If you prefer to run the Heroku app regularly, the `maintenance.sh` is helpful to turn 
it into maintenance mode by crontab or other. It requires a Heroku authorization token 
during on running `heroku` command, and you can create one from the [Heroku dashboard](https://dashboard.heroku.com/account/applications/authorizations/new).

### Usage

```
$ sh maintenance.sh
Usage: sh maintenance.sh [options]

Options:
    -a, --app <heroku app name>
    -h, --help Usage
    -k  --api-key <heroku authorization token>
        Heroku authorization token, create an new token:
        https://dashboard.heroku.com/account/applications/authorizations/new
    -m, --mode <maintenance mode>
        Maintenance mode for heroku app, options: on, off (Default: on)
```

### Example

```sh
$ wget https://raw.githubusercontent.com/wabarc/on-heroku/main/maintenance.sh -O - | \
    sh -s - -k your-authorization-token -a your-app-name
```

running on Docker container:

```sh
$ docker run -ti --rm alpine:3.12 sh
# wget https://raw.githubusercontent.com/wabarc/on-heroku/main/maintenance.sh -O - | \
    sh -s - -k your-authorization-token -a your-app-name -m off
```

## Related projects

- [wabarc/wayback](https://github.com/wabarc/wayback)

## Credits

- [Heroku](https://heroku.com/)
- [ShellCheck](https://www.shellcheck.net/)

## F.A.Q

For Heroku free accounts, if an app has a free web dyno, and that dyno receives no web traffic 
in a 30-minute period, it will sleep. You may need a tool (e.g. crontab, [Cronitor](https://cronitor.io/), [New Relic](https://newrelic.com/)) 
to request `https://your-app.herokuapp.com/healthcheck` regularly to prevent it from sleeping.

## License

Permissive GPL 3.0 license, see the [LICENSE](https://github.com/wabarc/on-heroku/blob/main/LICENSE) file for details.
