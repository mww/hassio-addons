#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: monica_crm
# Sets up a crontab that runs every minute
# ==============================================================================

bashio::log.info "setting up crontab"
echo "*    *       *       *       *       run-parts /etc/periodic/1min" >> /etc/crontabs/root