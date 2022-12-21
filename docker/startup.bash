#!/usr/bin/

SCHEDULER_PID=$AIRFLOW_HOME/airflow-scheduler.pid
WEBSERVER_PID=$AIRFLOW_HOME/airflow-webserver.pid

echo "Cleaning up old PID files"
if [ -f "$SCHEDULER_PID" ]; then
    rm -rf $SCHEDULER_PID
fi

if [ -f "$WEBSERVER_PID" ]; then
    rm -rf $WEBSERVER_PID
fi

echo "Setting up airflow metada db"
airflow db upgrade

echo "Create user"
airflow users create \
    --username admin \
    --password admin \
    --firstname admin \
    --lastname admin \
    --role Admin \
    --email admin@email.com

echo "Starting services"
airflow scheduler -D & airflow webserver -p 8080
