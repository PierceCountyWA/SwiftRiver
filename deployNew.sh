#!/bin/bash

ROOT_PASSWORD=${1}
USER_PASSWORD=${2}
DATABASE=swiftriver
USER=swiftriver
EMAIL_ADDRESS="nmoore@co.pierce.wa.us"

while [[ -z "${ROOT_PASSWORD}" ]]
do
  read -p "Root Password? " ROOT_PASSWORD
done

while [[ -z "${USER_PASSWORD}" ]]
do
  read -p "User Password? " USER_PASSWORD
done

SWIFT_RIVER_DIR=/opt/SwiftRiver

# Create SwiftRiver directory if it doesn't exist
if [ ! -e "${SWIFT_RIVER_DIR}" ]
then
  echo "Creating ${SWIFT_RIVER_DIR}"
  sudo mkdir ${SWIFT_RIVER_DIR}
else
  echo "${SWIFT_RIVER_DIR} directory already exists.  Exiting."
  exit 1
fi

# Copy distribution
FILE_LIST="application index.php modules themes favicon.ico markup plugins system .htaccess"

for FILE in ${FILE_LIST}
do
  sudo cp -r ${FILE} ${SWIFT_RIVER_DIR}
done

sudo rm ${SWIFT_RIVER_DIR}/application/config/*.template

# Copy configuration files
sudo cp application/config/site.php.template ${SWIFT_RIVER_DIR}/application/config/site.php
sudo cp application/config/database.php.template ${SWIFT_RIVER_DIR}/application/config/database.php
sudo cp application/config/cache.php.template ${SWIFT_RIVER_DIR}/application/config/cache.php
sudo cp application/config/auth.php.template ${SWIFT_RIVER_DIR}/application/config/auth.php
sudo cp application/config/cookie.php.template ${SWIFT_RIVER_DIR}/application/config/cookie.php

# Create cache and log directories
sudo mkdir ${SWIFT_RIVER_DIR}/application/cache
sudo mkdir ${SWIFT_RIVER_DIR}/application/logs

# Create Database
./createDatabase.sh ${ROOT_PASSWORD} ${DATABASE} ${USER} ${USER_PASSWORD}

# Populate Database
mysql ${DATABASE} -u ${USER} -p${USER_PASSWORD} < install/sql/swiftriver.sql

# Preserve Whitespace in Variables
IFS=1

# Copy security configuration
HTACCESS_SED="s/RewriteBase \//RewriteBase \/monitor/g"
sudo sed -i -e ${HTACCESS_SED} ${SWIFT_RIVER_DIR}/.htaccess

# Update Database Configuration
DATABASE_CONFIG_HOSTNAME_SED="s/'hostname'   => ''/'hostname'   => 'localhost'/g"
sudo sed -i -e ${DATABASE_CONFIG_HOSTNAME_SED} ${SWIFT_RIVER_DIR}/application/config/database.php

DATABASE_CONFIG_DATABASE_SED="s/'database'   => ''/'database'   => 'swiftriver'/g"
sudo sed -i -e ${DATABASE_CONFIG_DATABASE_SED} ${SWIFT_RIVER_DIR}/application/config/database.php

DATABASE_CONFIG_USERNAME_SED="s/'username'   => ''/'username'   => 'swiftriver'/g"
sudo sed -i -e ${DATABASE_CONFIG_USERNAME_SED} ${SWIFT_RIVER_DIR}/application/config/database.php

DATABASE_CONFIG_PASSWORD_SED_1="s/'password'   => ''/'password'   => '"
DATABASE_CONFIG_PASSWORD_SED_2="'/g"
DATABASE_CONFIG_PASSWORD_SED="${DATABASE_CONFIG_PASSWORD_SED_1}${USER_PASSWORD}${DATABASE_CONFIG_PASSWORD_SED_2}"
sudo sed -i -e ${DATABASE_CONFIG_PASSWORD_SED} ${SWIFT_RIVER_DIR}/application/config/database.php

# Update Site Configuration
SITE_CONFIG_EMAIL_ADDRESS_SED="s/'email_address' => 'no-response@example.com'/'email_address' => '${EMAIL_ADDRESS}'/g"
sudo sed -i -e ${SITE_CONFIG_EMAIL_ADDRESS_SED} ${SWIFT_RIVER_DIR}/application/config/site.php

# Update Cookie Configuration
SALT_RAW=`pwgen -s 64`
SALT=`echo ${SALT_RAW} | tr -d ' '`

# Update Cookie Configuration
COOKIE_CONFIG_SALT_SED="s/'salt' => 'WqLHtxZ3X4iGu%<CceGZwR3dAd?3Z4BW'/'salt' => '${SALT}'/g"
sudo sed -i -e ${COOKIE_CONFIG_SALT_SED} ${SWIFT_RIVER_DIR}/application/config/cookie.php

# Update bootstrap
FULLY_QUALIFIED_HOSTNAME=`hostname -f`
BOOTSTRAP_SED="s/'base_url'   => '\/'/'base_url'   => 'https:\/\/${FULLY_QUALIFIED_HOSTNAME}\/monitor'/g"
sudo sed -i -e ${BOOTSTRAP_SED} ${SWIFT_RIVER_DIR}/application/bootstrap.php

# Make apache user owner
sudo chown -R www-data:www-data ${SWIFT_RIVER_DIR}

# Turn Off Preserve Whitespace in Variables
unset IFS

# Stop apache
#sudo service apache2 stop

# Create apache2 configuration file
sudo cp swiftriver.conf.template /etc/apache2/conf.d/swiftriver.conf

# Start apache
#sudo service apache2 start

# Restart apache
sudo service apache2 restart
