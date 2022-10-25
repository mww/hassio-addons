<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

## 0.0.5

- Make trusted_proxies config optional

## 0.0.4

- Support setting ServerName and ServerAdmin parameters in configuration.
- Support APP_TRUSTED_PROXIES in configuration
- Randomally set HASH_SALT when system is first setup.

## 0.0.3

- Stop writing cron messages to /share/cron.log now that I know it works.
- Add config option to set the APP_URL .env option
- Add config option to enable apache access logs

## 0.0.2

- Fixing cron jobs
  - Starting crond
  - Added /etc/periodic/1min/monica_scheduled_tasks.sh script to invoke scheduled tasks
- Added dev_server option that generates a self-signed cert and uses that when developing

## 0.0.1

- Initial release, basics working
- Monica 3.7.0
- Base image 12.2.4
