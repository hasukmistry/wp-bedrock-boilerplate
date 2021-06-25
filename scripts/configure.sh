#!/bin/bash

WP_ENV_FILE=/var/www/html/.env

# Retrieve salts from wordpress.org website and put them into an array
# https://unix.stackexchange.com/a/137032
IFS=$'\n'; set -f
salts=( $(curl -s https://api.wordpress.org/secret-key/1.1/salt/ | awk -F\' '{print $4}') )

# Removes old env file if exists.
rm -rf $WP_ENV_FILE

# Creates env file again.
touch $WP_ENV_FILE

# Start appending data to .env file
{
  printf 'WP_SITEURL="${WP_HOME}/wp"\n';
  printf 'WP_DEBUG_LOG=/var/www/logs/\n';
  printf '\n';
  printf '# Generate your keys here: https://roots.io/salts.html\n';
  printf 'AUTH_KEY="%s"\n' "${salts[0]}";
  printf 'SECURE_AUTH_KEY="%s"\n' "${salts[1]}";
  printf 'LOGGED_IN_KEY="%s"\n' "${salts[2]}";
  printf 'NONCE_KEY="%s"\n' "${salts[3]}";
  printf 'AUTH_SALT="%s"\n' "${salts[4]}";
  printf 'SECURE_AUTH_SALT="%s"\n' "${salts[5]}";
  printf 'LOGGED_IN_SALT="%s"\n' "${salts[6]}";
  printf 'NONCE_SALT="%s"\n' "${salts[7]}";
} >> $WP_ENV_FILE