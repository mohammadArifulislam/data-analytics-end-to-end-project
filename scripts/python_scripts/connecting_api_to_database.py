"""
=============================================================
Connecting Database to the api
=============================================================
Script Purpose:
    This script create connection with datables named 'BluesLtd'.
Note:
    Keep this script same Folder directory where mail.py file was located. 
"""

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Format: postgresql://<username>:<password>@<host>:<port>/<dbname>
DATABASE_URL = "postgresql://postgres:your_password@localhost:5432/bluesltd"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


# Database Session Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
