# Getting started

> this sample assumes you have an entry on the `hosts` file for `ghost.local` looping back to `127.0.0.1`.

`/etc/nginx` stores the configuration of nginx
`/usr/share` stores the content for each website

the idea is to keep configuration and content for separate from each other and keep all sites unaware of each other

the default configuration is stored in the `conf.d` folder.  as you can read from the links below, i have had issues with using the `sites-available` and `sites-enabled` folders to help manage separation.  we got round this by keeping `server blocks` - ie: website configuration per service - in separate files but hosting them in `conf.d` to make them `servicable`

use `nginx -T` to generate a view of the *effective* configuration as a whole across all configuration files.  this helped diagnose the issue of nginx not serving

## build 

- `docker build --tag kaml/nginx .`
- `docker run -d --rm --name kam -p 80:80 kaml/nginx`
- `docker stop kam`

## useful links

- [installing nginx](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04#step-5-setting-up-server-blocks-(recommended))

- [initial set up of ubuntu](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04)

- [securing nginx](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-18-04)

## troubleshooting

- [sites-available and sites-enabled are evil](https://serverfault.com/questions/527630/difference-in-sites-available-vs-sites-enabled-vs-conf-d-directories-nginx/870709#870709)

- [duplicate default_servers](https://stackoverflow.com/questions/30973774/nginx-duplicate-default-server-error/30974115#30974115)