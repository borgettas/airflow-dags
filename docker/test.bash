#!/usr/bin/env bash

echo -n "Setting up airflow metadata db... "
airflow db init > /dev/null 2>&1
echo "OK"

log_dags_tested() {
    echo "The following DAGs will be tested"
    airflow dags list 2>&1 | grep -v "^[\[]"
}

validation_tests() {
    echo "Running DAG validation test..."
    pytest --disable-warnings ${AIRFLOW_HOME}/tests/test_dag_validation.py
    return $?
}

definition_tests() {
    echo "Running DAG definition test"
    pytest --disable-warnings ${AIRFLOW_HOME}/tests/test_dag_definition.py
    return $?
}

scripts_tests() {
    echo "Running script tests"
    sum=0
    for folder in $(find ${AIRFLOW_HOME}/scripts/ -wholename  "*/tests"); do
        pytest --disable-warnings $folder
        sum=$(($sum + $?))
    done
    return $sum
}

case $1 in
    validation) log_dags_tested && validation_tests;;
    definition) log_dags_tested && definition_tests;;
    scripts) scripts_tests || true;;
    all)
        log_dags_tested;

        validation_tests;
        validation_result=$?

        definition_tests;
        definition_result=$?

        scripts_tests;
        scripts_result=$?

        echo $validation_result
        echo $definition_result
        echo $scripts_result

        result=$(($validation_result + $definition_result + $scripts_result))
        exit $result
        ;;
    *)
        echo "Running tests for folder: $1"
        pytest --disable-warnings $1
        ;;
esac