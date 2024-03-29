#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: monica_crm
# Configures Monica
# ==============================================================================
declare host
declare password
declare port
declare username
declare app_url
declare mail_host
declare mail_port
declare mail_encryption
declare mail_username
declare mail_password
declare mail_from_address
declare mail_from_name
declare trusted_proxies
declare hash_salt

host=$(bashio::services "mysql" "host")
password=$(bashio::services "mysql" "password")
port=$(bashio::services "mysql" "port")
username=$(bashio::services "mysql" "username")

bashio::log.info "db host: ${host}"
bashio::log.info "db port: ${port}"
bashio::log.info "db username: ${username}"
#bashio::log.info "db password: ${password}"

if [ ! -L /var/www/monica/storage ]; then
    if [ ! -e /data/storage ]; then
        bashio::log.info "creating /data/storage"
        mkdir -p /data/storage
        mv /var/www/monica/storage/* /data/storage
        rmdir /var/www/monica/storage
    else
        rm -fr /var/www/monica/storage
    fi

    bashio::log.info "creating sym link to /data/storage"
    ln -s /data/storage /var/www/monica/storage

    bashio::log.info "fixing permissions for /data/storage"
    chown -R apache:apache /var/www/monica/storage
    chmod -R 0775 /var/www/monica/storage
    chown -R apache:apache /data/storage
    chmod -R 0775 /data/storage
    bashio::log.info "done setting up /data/storage"
fi

if [ ! -f /var/www/monica/.env ]; then
    if [ -f /data/monica-env ]; then
        bashio::log.info "restoring .env file from /data"
        cp /data/monica-env /var/www/monica/.env
    else
        bashio::log.info "creating new .env file"
        cp /var/www/monica/.env.example /var/www/monica/.env

        bashio::log.info "generating a new app key"
        php /var/www/monica/artisan key:generate

        bashio::log.info "generating new HASH_SALT"
        hash_salt=$(openssl rand -base64 32)
        sed -i "s@HASH_SALT=ChangeMeBy20+KeyLength@HASH_SALT=${hash_salt}@" /var/www/monica/.env

        sed -i "s@^APP_ENV=local@APP_ENV=production@" /var/www/monica/.env

        cp /var/www/monica/.env /data/monica-env
    fi
else
    bashio::log.info "found existing .env file - this wasn't expected"
fi

app_url=$(bashio::config 'app_url')
mail_host=$(bashio::config 'mail_host')
mail_port=$(bashio::config 'mail_port')
mail_encryption=$(bashio::config 'mail_encryption')
mail_username=$(bashio::config 'mail_username')
mail_password=$(bashio::config 'mail_password')
mail_from_address=$(bashio::config 'mail_from_address')
mail_from_name=$(bashio::config 'mail_from_name')

bashio::log.info "updating .env file"
sed -i "s@^APP_URL=http://localhost@APP_URL=${app_url}@" /var/www/monica/.env
sed -i "s@^DB_HOST=127.0.0.1@DB_HOST=${host}@" /var/www/monica/.env
sed -i "s@^DB_PORT=3306@DB_PORT=${port}@" /var/www/monica/.env
sed -i "s@^DB_USERNAME=homestead@DB_USERNAME=${username}@" /var/www/monica/.env
sed -i "s@^DB_PASSWORD=secret@DB_PASSWORD=${password}@" /var/www/monica/.env
sed -i "s@^MAIL_HOST=mailtrap.io@MAIL_HOST=${mail_host}@" /var/www/monica/.env
sed -i "s@^MAIL_PORT=2525@MAIL_PORT=${mail_port}@" /var/www/monica/.env
sed -i "s/^MAIL_USERNAME=/MAIL_USERNAME=${mail_username}/" /var/www/monica/.env
sed -i "s/^MAIL_PASSWORD=/MAIL_PASSWORD=${mail_password}/" /var/www/monica/.env
sed -i "s/^MAIL_ENCRYPTION=/MAIL_ENCRYPTION=${mail_encryption}/" /var/www/monica/.env
sed -i "s/^MAIL_FROM_ADDRESS=/MAIL_FROM_ADDRESS=${mail_from_address}/" /var/www/monica/.env
sed -i "s/^MAIL_FROM_NAME=\"Monica instance\"/MAIL_FROM_NAME=\"${mail_from_name}\"/" /var/www/monica/.env

if ! bashio::config.is_empty "trusted_proxies"; then
    trusted_proxies=$(bashio::config 'trusted_proxies')
    sed -i "s/APP_TRUSTED_PROXIES=/APP_TRUSTED_PROXIES=\"${trusted_proxies}\"/" /var/www/monica/.env
fi

database=$(\
    mariadb \
        -u "${username}" -p"${password}" \
        -h "${host}" -P "${port}" \
        --skip-column-names \
        -e "SHOW DATABASES LIKE 'monica';"
)

if ! bashio::var.has_value "${database}"; then
    bashio::log.info "Creating database for Monica CRM"
    mariadb \
        -u "${username}" -p"${password}" \
        -h "${host}" -P "${port}" \
        -e "CREATE DATABASE monica CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

    # Ensure the DB is ready
    sleep 3

    bashio::log.info "Setting up the database"
    cd /var/www/monica || exit
    php artisan setup:production -v --force --email=admin@example.com --password=changeme
else
    # Clear all the caches to make sure new configs are used
    cd /var/www/monica || exit
    php artisan setup:production --force --skipSeed
fi