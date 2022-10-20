#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: monica_crm
# Sets up a crontab that runs every minute
# ==============================================================================

declare devserver
devserver=$(bashio::config 'dev_server')

echo "dev_server: '${devserver}'"

if [ "${devserver}" = "true" ]; then
    bashio::log.warning "This is a development server - creating a self signed certificate"
    bashio::log.warning "!!!This is not safe for a real server!!!"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /data/server.key -out /data/server.crt<<EOF
US
Washington
Seattle
Company
Org
localhost
admin@example.com
EOF

    chmod 777 /data/server.*
fi