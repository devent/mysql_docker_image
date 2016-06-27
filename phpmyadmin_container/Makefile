VERSION := latest
NAME := phpmyadmin
CONF := .
CONTAINER_USER ?= www-data
DNS_SERVER ?= 172.17.0.3

define DOCKER_CMD :=
docker run \
--name $(NAME) \
--dns=$(DNS_SERVER) \
-v "`realpath $(CONF)/config.inc.php`:/usr/src/phpMyAdmin/config.inc.php.custom" \
-e PHPMYADMIN_USER_ID=`id -u $(CONTAINER_USER)` \
-e PHPMYADMIN_GROUP_ID=`id -g $(CONTAINER_USER)` \
-d \
erwinnttdata/phpmyadmin:$(VERSION)
endef

include ../make_utils/Makefile.help
include ../make_utils/Makefile.functions
include ../make_utils/Makefile.container

.PHONY +: run rerun rm clean test restart bash

run: _localuser _run backend ##@default Starts the container.

rerun: rm run ##@targets Stops, removes and re-starts the container.

stop: backend-stop _stop ##@targets Stops the container.

rm: _rm backend-rm ##@targets Stops and removes the container.

clean: _clean backend-clean ##@targets Stops and removes the container and removes all created files.

test: backend-test _test ##@targets Tests if the container is running.

restart: _restart backend-restart ##@targets Restarts the container.

bash: test _bash ##@targets Executes the bash inside the running container.

backend:
	$(MAKE) -f Makefile.nginx

backend-rerun:
	$(MAKE) -f Makefile.nginx rerun

backend-stop:
	$(MAKE) -f Makefile.nginx stop

backend-rm:
	$(MAKE) -f Makefile.nginx rm

backend-clean:
	$(MAKE) -f Makefile.nginx clean

backend-test:
	$(MAKE) -f Makefile.nginx test

backend-restart:
	$(MAKE) -f Makefile.nginx restart

backend-bash:
	$(MAKE) -f Makefile.nginx bash

$(CONF):
	mkdir -p "$(CONF)"
