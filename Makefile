SHELL := /bin/bash

image=airflow:latest
container=docker_airflow_dags_local
airflow_home=/opt/airflow

.PHONY: build
build:
	docker build . \
		--build-arg GROUP_ID=$(id -g) \
		--build-arg USER_ID=$(id -u) \
		--target app \
		--tag $(image);


.PHONY: airflowd
airflowd:
	docker container create \
		--env AIRFLOW_HOME=$(airflow_home) \
		--env AIRFLOW__CORE__LOAD_EXAMPLES=FALSE \
		--env AIRFLOW__CORE__DAGS_FOLDER=/opt/airflow/airflow/dags \
		--env GROUP_ID=$(id -g) \
		--env USER_ID=$(id -u) \
		--name $(container) \
		--publish 8080:8080 \
		--volume $(pwd)/airflow/dags:$(airflow_home)/dags \
		--volume $(pwd)/scripts:$(airflow_home)/scripts \
			$(image) \
			$(airflow_home)/docker/startup.bash

	docker container start $(container)


.PHONY: clean
clean: ##@miscellaneous Remove created artifacts
	docker container rm $(container) || true;
	docker image rm --force $(image) || true


.PHONY: stop
stop: ##@docker Stop Airflow container
	docker container stop $(container)


.PHONY: start
start:
	make build && make airflowd


.PHONY: finish
finish:
	make stop && make clean
