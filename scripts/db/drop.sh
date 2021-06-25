#!/bin/bash

printf "## Current Configuration ##\n"
printf "Host: %s\n" $DB_HOST
printf "DB: %s\n" $DB_NAME

printf "\n"

#https://developer.wordpress.org/cli/commands/
wp db drop --yes