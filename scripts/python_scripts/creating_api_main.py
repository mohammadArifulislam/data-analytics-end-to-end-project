"""
#==============================================================================================
Creating APP using FastAPI & Insert Data to the Central Database with api request
#==============================================================================================
Script purpose:
        This script is to build api with fastapi and inserting data with http request.
    Note:
       Columns names are case sensitive.

"""

from datetime import date
from typing import List
from fastapi import Depends, FastAPI, HTTPException, status
from pydantic import BaseModel
from sqlalchemy import text
from sqlalchemy.orm import Session

# import essantial module from database.py 
from .database import Base, engine, get_db

# to check table connection after running the app (Optional but good)
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Data Automation API")


# -------------------------------------------------------------------
# PYDANTIC SCHEMAS (data validation)
# -------------------------------------------------------------------
class SalesSchema(BaseModel):
    sale_id: str
    customer_id: str
    product_id: str
    order_quantity: int
    unit_price: float
    order_date: date
    shift_date: date
    discount: float
    tax: float
    payment_method: str


class CustomerSchema(BaseModel):
    customer_id: str
    customer_name: str
    email: str
    city: str
    region: str
    country: str
    gender: str
    platform: str


# -------------------------------------------------------------------
# API ENDPOINTS
# -------------------------------------------------------------------
@app.get("/")
def home():
    return {"status": "online", "system": "Blues Ltd API Service"}


# --- CUSTOMER ENDPOINTS ---


@app.get("/customers")
def get_all_customers(db: Session = Depends(get_db)):
    """ take data from PostgreSQL to the customers table"""
    try:
        result = db.execute(text("SELECT * FROM crm.customers"))
        customers = [dict(row._mapping) for row in result]
        return {"total_records": len(customers), "data": customers}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to fetch customers: {str(e)}"
        )


@app.post("/customers", status_code=status.HTTP_201_CREATED)
def create_customer(customer: CustomerSchema, db: Session = Depends(get_db)):
    """ from Postman/CSV data insert to PostgreSQL customers"""
    query = text("""
        INSERT INTO crm.customers (
            customer_id, customer_name, email, city, region, country, gender, platform
        ) VALUES (
            :customer_id, :customer_name, :email, :city, :region, :country, :gender, :platform
        )
    """)

    try:
        db.execute(query, customer.model_dump())
        db.commit()
        return {
            "message": "Customer added to PostgreSQL successfully",
            "data": customer,
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=500, detail=f"Database insertion error: {str(e)}"
        )


# --- SALES ENDPOINTS ---


@app.get("/sales")
def get_all_sales(db: Session = Depends(get_db)):
    """take data from PostgreSQL to the sales table"""
    try:
        result = db.execute(text("SELECT * FROM crm.sales"))
        sales = [dict(row._mapping) for row in result]
        return {"total_records": len(sales), "data": sales}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to fetch sales: {str(e)}"
        )


@app.post("/sales", status_code=status.HTTP_201_CREATED)
def create_sale(sale: SalesSchema, db: Session = Depends(get_db)):
       """ from Postman/CSV data insert to PostgreSQL customers"""
    query = text("""
        INSERT INTO crm.sales (
            sale_id, customer_id, product_id, order_quantity, unit_price, 
            order_date, shift_date, discount, tax, payment_method
        ) VALUES (
            :sale_id, :customer_id, :product_id, :order_quantity, :unit_price, 
            :order_date, :shift_date, :discount, :tax, :payment_method
        )
    """)

    try:
        db.execute(query, sale.model_dump())
        db.commit()
        return {
            "message": "Sale record added to PostgreSQL successfully",
            "data": sale,
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=500, detail=f"Database insertion error: {str(e)}"
        )
