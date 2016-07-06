REPOSITORY := erwinnttdata
NAME := phpmyadmin
VERSION ?= 4.6.3-fpm-build_008

build: _build ##@targets Builds the docker image.

clean: _clean ##@targets Removes the local docker image.

deploy: _deploy ##@targets Deployes the docker image to the repository.

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.functions
include ../docker_make_utils/Makefile.image
