#!/bin/bash

ROOT_PASSWORD=${1}
DATABASE=${2}
USER=${3}
USER_PASSWORD=${4}

while [[ -z "${ROOT_PASSWORD}" ]]
do
  read -p "Root Password? " ROOT_PASSWORD
done

while [[ -z "${DATABASE}" ]]
do
  read -p "Database? " DATABASE
done

while [[ -z "${USER}" ]]
do
  read -p "User? " USER
done

while [[ -z "${USER_PASSWORD}" ]]
do
  read -p "User Password? " USER_PASSWORD
done

CREATE_DATABASE_SQL="CREATE DATABASE ${DATABASE} CHARACTER SET utf8 COLLATE utf8_bin;"
CREATE_USER_SQL="CREATE USER '${USER}'@'localhost' IDENTIFIED BY '${USER_PASSWORD}';"
GRANT_SQL="GRANT ALL PRIVILEGES ON ${DATABASE}.* TO '${USER}'@'localhost';"

mysql -u root -p${ROOT_PASSWORD} -e "${CREATE_DATABASE_SQL}"
mysql -u root -p${ROOT_PASSWORD} -e "${CREATE_USER_SQL}"
mysql -u root -p${ROOT_PASSWORD} -e "${GRANT_SQL}"

