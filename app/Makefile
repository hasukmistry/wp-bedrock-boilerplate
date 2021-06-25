.DEFAULT_GOAL := help
SHELL=/bin/bash
BASE_DIR:= $(shell pwd | xargs basename)

create-env:
	@configure.sh
	@echo ".env file configured successfully"

reset-env: create-env

create-db:
	@/usr/local/bin/db/create.sh

reset-db:
	@/usr/local/bin/db/reset.sh

drop-db:
	@/usr/local/bin/db/drop.sh

composer-install:
	@composer install --optimize-autoloader --no-progress

db-resolve-permission:
	@mysql --host=${DB_HOST} \
           --user=${DB_USER} \
           --password=${DB_PASSWORD} \
           -e "ALTER USER ${DB_USER} IDENTIFIED WITH mysql_native_password BY '${DB_PASSWORD}';"

dev-install: composer-install reset-env db-resolve-permission create-db reset-db ## Install application for local development

############################
# GENERIC HELP
############################
.PHONY: help # Print help screen
help: SHELL := /bin/sh
help:
	@echo
	@echo "\033[1m\033[7m                                                       \033[0m"
	@echo "\033[1m\033[7m                   Available Commands                  \033[0m"
	@echo "\033[1m\033[7m                                                       \033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'