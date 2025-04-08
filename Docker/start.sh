#!/bin/bash

# activate virtual environment
source /opt/app/.venv/bin/activate

# Verify the environment variables
if [ -z "$RDS_HOST" ] || [ -z "$RDS_USER" ] || [ -z "$RDS_PASSWORD" ] || [ -z "$db-softserve-project" ]; then
    echo "Error: Environment variables not define"
    echo "Debe definir: RDS_HOST, RDS_USER, RDS_PASSWORD, db-softserve-project"
    exit 1
fi

# waiting for the DB 
echo "Waiting for database availability..."
until mysql -h "$RDS_HOST" -u "$RDS_USER" -p"$RDS_PASSWORD" -e "SELECT 1"; do
    echo "Database not available, waiting ..."
    sleep 5
done

# Ejecute SQL script for DB configuration
echo "Setting up database..."
mysql -h "$RDS_HOST" -u "$RDS_USER" -p"$RDS_PASSWORD" "$DB_NAME" < /opt/app/db_setup.sql

# Initialize app
echo "Starting the app..."
python /opt/app/app.py