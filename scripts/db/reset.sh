#!/bin/bash

# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux?page=1&tab=votes#tab-top
Green='\033[1;32m'
NC='\033[0m' # No Color

printf "## Current Configuration ##\n"
printf "Host: %s\n" $DB_HOST
printf "DB: %s\n" $DB_NAME

printf "\n"

#Check if database exists
#https://developer.wordpress.org/cli/commands/
wp db reset --yes

wp core install --url=$WP_HOME \
                --title="$ENV_SITE_TITLE" \
                --admin_user=$ENV_ADMIN_USER \
                --admin_password=$ENV_ADMIN_PASSWORD \
                --admin_email=$ENV_ADMIN_URL