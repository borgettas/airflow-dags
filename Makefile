SHELL := /bin/bash

image=airflow:latest
image_base=apache/airflow:2.5.0-python3.10
container=docker_airflow_dags_local
airflow_home=/opt/airflow


.PHONY: build
build:
	docker build . \
		--build-arg GROUP_ID=$(id -g) \
		--build-arg USER_ID=$(id -u) \
		--target app \
		--tag $(image);


.PHONY: createenv
createenv:
	docker container create \
		--env AIRFLOW_HOME=$(airflow_home) \
		--env AIRFLOW__CORE__LOAD_EXAMPLES=FALSE \
		--env AIRFLOW__CORE__DAGS_FOLDER=/opt/airflow/dags \
		--env AIRFLOW__CORE__DAGBAG_IMPORT_TIMEOUT=5.0 \
		--env GROUP_ID=$(id -g) \
		--env USER_ID=$(id -u) \
		--name $(container) \
		--publish 8080:8080 \
		--volume $$(pwd)/dags:$(airflow_home)/dags \
		--volume $$(pwd)/scripts:$(airflow_home)/scripts \
			$(image) \
			$(airflow_home)/docker/startup.bash


.PHONY: exec
exec:
	docker exec -ti \
		$(container) \
		/bin/bash


.PHONY: start
start: ##@docker Stop Airflow container
	docker container start $(container)


.PHONY: stop
stop: ##@docker Stop Airflow container
	docker container stop $(container)


.PHONY: run
run:
	make build;
	make createenv;
	make start;


.PHONY: finish
finish:
	docker stop $(container);
	docker rm -f $(container);
	docker rmi $(image_base);
	docker rmi -f $(image);


.PHONY: rerun
rerun:
	make finish && make run


.PHONY: inspect
inspect:
	docker inspect $(container)