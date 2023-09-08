#!/bin/bash

echo "[INFO] Pulled installation script from GitHub"

echo "[INFO] Installing Python3 and pip3 ..."
apt update && apt upgrade -y && apt install python3 python3-pip -y
echo "[INFO] ... Done."
echo "[INFO] Installing FastAPI, Uvicorn, MySQL connectors, Properties Parser and SQLAlchemy ..."
pip3 install fastapi[all] uvicorn[standard] mysql-connector-python jproperties sqlalchemy pymysql
echo "[INFO] ... Done."

echo "[INFO] Generating config.properties ..."
printf "# config.properties\n#\n####################\n#\n# DO NOT EDIT\n# Changes made here\n# will be overwritten\n#\n####################\n\ndatabase.user=DB_USERNAME\ndatabase.password=DB_PASSWORD\ndatabase.host=DB_HOST\ndatabase.port=DB_PORT\ndatabase.name=DB_NAME\ndatabase.table=DB_TABLE\napi.port=API_PORT" > config.properties
echo "[INFO] ... Done."

echo "[INFO] Generating basic main.py ..."
cat <<EOF > main.py
from fastapi import FastAPI
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Boolean
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import mysql.connector
import configparser

# Create a ConfigParser object
config = configparser.ConfigParser()

# Load the properties file
config.read('config.properties')
database_host = config.get('database', 'host')
database_port = config.getint('database', 'port')
database_user = config.get('database', 'user')
database_password = config.get('database', 'password')
database_table = config.get('database', 'table')
api_port = config.get('api', 'port')

app = FastAPI()

# Construct the DB_URL string
DB_URL = f"mysql+pymysql://{database_user}:{database_password}@{database_host}:{database_port}/{database_table}"

# Create a SQLAlchemy engine
engine = create_engine(DB_URL)

# Create a SQLAlchemy session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# SQLAlchemy models
Base = declarative_base()

# Route to get all items from the table
@app.get("/")
async def read_root():
    return {"message": "Hello, World!"}

if __name__ == "__main__":
    import uvicorn
    #uvicorn.run(app, host="0.0.0.0", port=8000

print('FastAPI is running and ready!')
EOF
echo "[INFO] ... Done."

echo "FastAPI installed and ready"
echo "--------------------------------------------------------------"
echo "[INFO] Installed from installation script from GitHub"
echo "[INFO] Configuration and setup complete"
echo "[INFO] API should be available on {{SERVER_IP}}:{{SERVER_PORT}}/"
echo "[INFO] You should see Hello, World! on that page."
echo "--------------------------------------------------------------"
