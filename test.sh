#!/bin/bash

SWIFT_RIVER_DIR=/opt/SwiftRiver

IFS=1

HTACCESS_SED="s/RewriteBase \//RewriteBase \/monitor/g"
sudo sed -i -e ${HTACCESS_SED} ${SWIFT_RIVER_DIR}/.htaccess

unset IFS
