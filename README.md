# on-heroku

`on-heroku` is designed to deploy the `wayback` service as a Heroku app, expect to
reduce the cost of running the `wayback` service, and providing additional anonymity.

## Installation

### Script (recommended)

The script requires to run with the `root` user, on a Docker container may be better options.

It will install Node.js in the `/tmp` directory and remove it automatically after deployment.

```bash
# sh <(wget https://raw.githubusercontent.com/wabarc/on-heroku/master/setup -O -)
```

Run on Docker container:

```sh
$ docker run -ti --rm debian:stable-slim bash -c "apt update && apt install -y wget \
    && sh <(wget https://raw.githubusercontent.com/wabarc/on-heroku/master/setup -O -)"
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

The `WAYBACK_ARGS` config var is required by `wayback` process as an environment variable during running, more useful reference the [wabarc/wayback](https://github.com/wabarc/wayback#usage).

```sh
$ heroku config:set WAYBACK_ARGS="--ia --is --ip -d telegram -t your-telegram-bot-token --debug"
```

PS: if you run with the script, the double quote is unnecessary.

[more details](https://devcenter.heroku.com/articles/config-vars#set-a-config-var)

#### Deploy to heroku

```sh
$ git push heroku master
```

#### Start synos

```sh
$ heroku ps:scale worker=1
```

## Related projects

- [wabarc/wayback](https://github.com/wabarc/wayback)

## Credits

- [Heroku](https://heroku.com/)
- [ShellCheck](https://www.shellcheck.net/)

## License

Permissive GPL 3.0 license, see the [LICENSE](https://github.com/wabarc/on-heroku/blob/master/LICENSE) file for details.
