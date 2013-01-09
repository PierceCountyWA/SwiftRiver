#!/bin/bash

ROOT_PASSWORD=${1}

while [[ -z "${ROOT_PASSWORD}" ]]
do
  read -p "Root Password? " ROOT_PASSWORD
done

DROP_USER_SQL="DROP USER 'swiftriver'@'localhost'"
DROP_DATABASE_SQL="DROP DATABASE swiftriver"

mysql -u root -p${ROOT_PASSWORD} -e "${DROP_USER_SQL}"
mysql -u root -p${ROOT_PASSWORD} -e "${DROP_DATABASE_SQL}"
