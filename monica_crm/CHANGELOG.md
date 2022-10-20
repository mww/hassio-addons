<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

## 0.0.2

- Fixing cron jobs
  - Starting crond
  - Added /etc/periodic/1min/monica_scheduled_tasks.sh script to invoke scheduled tasks
- Added dev_server option that generates a self-signed cert and uses that when developing

## 0.0.1

- Initial release, basics working
- Monica 3.7.0
- Base image 12.2.4
