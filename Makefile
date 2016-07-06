SHELL := /bin/bash
.DEFAULT_GOAL := setup
.PHONY: setup weave convoy db

include docker_make_utils/Makefile.help

setup: weave convoy ##@default Setups the weave network and convoy volumes.

weave: ##@targets Installs and setups the weave network.
	cd docker_utils && $(MAKE) weave

convoy: ##@targets Installs and setups the convoy volumes.
	cd docker_utils && $(MAKE) convoy

db: setup ##@targets Installs and setups the database.
	cd mysql_container && $(MAKE)

phpmyadmin: setup db ##@targets Installs and setups the phpMyAdmin.
	cd phpmyadmin_container && $(MAKE)
