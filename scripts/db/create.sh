#!/bin/bash

# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux?page=1&tab=votes#tab-top
Green='\033[1;32m'
NC='\033[0m' # No Color

printf "## Current Configuration ##\n"
printf "Host: %s\n" $DB_HOST
printf "DB: %s\n" $DB_NAME

printf "\n"

#https://developer.wordpress.org/cli/commands/
mysql --host=$DB_HOST \
      --user=$DB_USER \
      --password=$DB_PASSWORD \
      -e "CREATE DATABASE IF NOT EXISTS $DB_NAME"

printf "${Green}Success:${NC} Blank database created.\n"