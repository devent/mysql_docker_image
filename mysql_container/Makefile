# docker image version
VERSION := latest
# docker container name
NAME := db
# DNS server
DNS_SERVER ?= 172.17.0.2
# configuration files
CONFIG := conf
# database root password
ROOT_PASSWORD ?= auHoh5fei4biSooyobae1ahp8Xi1iaGo
# data container
DATA_VOL_NAME := db1
# data container directory
DATA_MOUNT_PATH := var/lib/mysql
DATA_IMAGE_NAME := erwinnttdata/mysql:$(VERSION)
DATA_VOLUME_NAME := db_data
# database local user
CONTAINER_USER ?= mysql

define DOCKER_CMD :=
docker run \
--name $(NAME) \
--dns=$(DNS_SERVER) \
--volumes-from $(DATA_VOLUME_NAME) \
-v "`realpath my.cnf`:/etc/mysql/my.cnf.custom" \
-v "`realpath $(CONFIG)`:/etc/mysql/conf.d" \
-e MYSQL_ROOT_PASSWORD="$(ROOT_PASSWORD)" \
-e MYSQL_USER_ID=`id -u $(CONTAINER_USER)` \
-e MYSQL_GROUP_ID=`id -g $(CONTAINER_USER)` \
-d \
$(IMAGE_NAME)
endef

include ../make_utils/Makefile.help
include ../make_utils/Makefile.functions
include ../make_utils/Makefile.container

.PHONY +: run rerun rm clean test restart dataContainer rm_dataContainer connect user drop dropdb dropuser

run: dataContainer _localuser _run ##@default Starts the container.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.

clean: _clean rm_dataContainer ##@targets Stops and removes the container and removes all created files.

test: testDataContainer _test ##@targets Tests if the container is running.

restart: _restart ##@targets Restarts the container.

dataContainer: _dataContainer ##@targets Creates the data container.

rm_dataContainer: _rm_dataContainer ##@targets Removes the data container.

testDataContainer: _testDataContainer ##@targets Tests that the data container is available.

connect: test ##@database Launch the mysql client for the database server.
	mysql=( mysql --protocol=socket -uroot -p"$(ROOT_PASSWORD)" ); \
	docker exec -it $(NAME) $${mysql[*]}

user: test ##@database Creates a new user on the server. If DB_NAME is set, the database is created and access privileges are set.
	$(call check_defined, DB_USER DB_PASSWORD DB_HOST, Database user credentials and host)
	mysql=( mysql --protocol=socket -uroot -p"$(ROOT_PASSWORD)" ); \
	docker exec $(NAME) bash -c "echo \"CREATE USER '$(DB_USER)'@'$(DB_HOST)' IDENTIFIED BY '$(DB_PASSWORD)' ;\" | $${mysql[*]}"
	if [ -n "$(DB_NAME)" ]; then \
	mysql=( mysql --protocol=socket -uroot -p"$(ROOT_PASSWORD)" ); \
	docker exec $(NAME) bash -c "echo \"CREATE DATABASE $(DB_NAME) DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci ;\" | $${mysql[*]}"; \
	docker exec $(NAME) bash -c "echo \"GRANT ALL ON $(DB_NAME).* TO '$(DB_USER)'@'$(DB_HOST)' ;\" | $${mysql[*]}"; \
	fi
	mysql=( mysql --protocol=socket -uroot -p"$(ROOT_PASSWORD)" ); \
	docker exec $(NAME) bash -c "echo 'FLUSH PRIVILEGES ;' | $${mysql[*]}"

drop: dropdb dropuser ##@database Removes the database and the user from the server.
	
dropdb: test ##@database Removes a database from the server.
	$(call check_defined, DB_NAME, Database name)
	mysql=( mysql --protocol=socket -uroot -p"$(ROOT_PASSWORD)" ); \
	docker exec $(NAME) bash -c "echo \"DROP DATABASE IF EXISTS $(DB_NAME) ;\" | $${mysql[*]}"

dropuser: test ##@database Removes the user from the server.
	$(call check_defined, DB_USER DB_HOST, Database user and host)
	mysql=( mysql --protocol=socket -uroot -p"$(ROOT_PASSWORD)" ); \
	docker exec $(NAME) bash -c "echo \"DROP USER '$(DB_USER)'@'$(DB_HOST)';\" | $${mysql[*]}"
	mysql=( mysql --protocol=socket -uroot -p"$(ROOT_PASSWORD)" ); \
	docker exec $(NAME) bash -c "echo 'FLUSH PRIVILEGES ;' | $${mysql[*]}"
