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
    uvicorn.run(app, host="0.0.0.0", port={api_port})
