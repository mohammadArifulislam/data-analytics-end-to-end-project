import pandas as pd
import numpy as np
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker()

customers = []
platforms = ['Website', ' Email', 'LinkedIn', 'GoogleAds',]
genders = ['M','f', 'm','Female','male', 'F','Male']

for i in range(100):
    
    customer_id = i + 1
    customer_name = fake.name()
    country = fake.country()
    city = fake.city()
    region = fake.state()
    email = fake.email()
    platform = random.choice(platforms)
    postal_code = fake.postcode()
    gender = random.choice(genders)
    
    customers.append({
        'customer_id': customer_id,
        'customer_name': customer_name,
        'email': email,
        'city': city,
        'region': region,
        'country': country,
        'gender': gender,
        'platform': platform

    })

sales = []

payment_methods = ['Credit Card', 'PayPal', 'Bank Transfer', 'Cash']

for i in range(1234):
    sale_id = i + 1
    customer_id = random.randint(1, 100)
    product_id = random.randint(1, 50)
    order_date = fake.date_between(start_date='-1y', end_date='today')
    shift_date = timedelta(days=random.randint(0, 30))
    discount = round(random.uniform(0.05, 0.2), 2)
    tax = round(random.uniform(0.05, 0.2), 2)
    payment_method = random.choice(payment_methods)
    order_quantity = random.randint(1, 10)
    unit_price = round(random.uniform(1000.0, 10000.0), 2)
    
    sales.append({
        'sale_id': sale_id,
        'customer_id': customer_id,
        'product_id': product_id,
        'order_quantity': order_quantity,
        'unit_price': unit_price,
        'order_date': order_date,
        'shift_date': order_date + shift_date,
        'discount': discount,
        'tax': tax,
        'payment_method': payment_method
    })

employees = []

departments = ['Sales', 'HR', 'Production']
positions = ['Manager', 'Executive', 'Analyst', 'Coordinator', 'Specialist']


for i in range(50):
    
    employee_id = i + 1
    first_name = fake.name()
    last_name = fake.last_name()
    email = fake.email()
    address = fake.address()
    phone_number = fake.phone_number()
    department = random.choice(departments)
    position = random.choice(positions)
    join_date = fake.date_between(start_date='-5y', end_date='today')
    birth_date = fake.date_of_birth(minimum_age=18, maximum_age=65)
    gender = random.choice(['M', 'F'])

    employees.append({
        'employee_id': employee_id,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'address': address,
        'department': department,
        'phone_number': phone_number,
        'position': position,
        'join_date': join_date,
        'birth_date': birth_date,
        'gender': gender
    })
    

salaries = []

for i in range(50):
    
    salary_id = i + 1
    employee_id = i + 1
    basic_salary = round(random.uniform(30000.0, 100000.0), 2)
    bonus = round(random.uniform(1000.0, 10000.0), 2)
    join_date = employees[i]['join_date']
    over_time_hours = random.randint(0, 20)
    department = employees[i]['department']
    payment_date = join_date + timedelta(days=random.randint(0, 30))
    salaries.append({
        'salary_id': salary_id,
        'employee_id': employee_id,
        'basic_salary': basic_salary,
        'bonus': bonus,
        'join_date': join_date,
        'department': department,
        'over_time_hours': over_time_hours,
        'payment_date': payment_date
    })

product = []

categories = ['Electronics', 'Consumers', 'Homes & Kitchen']
subcategories = ['Laptop', 'Smartphone', 'Headphones', 'Camera', 'Smartwatch', 'Tablet', 'Printer', 'Monitor', 'Keyboard', 'Mouse']
products_name = ['Laptop','Smartphone','Headphones','Camera','Smartwatch','Tablet','Printer','Monitor','Keyboard','Mouse','Speaker','Router','External Hard Drive','Flash Drive','Webcam','Projector','Microphone','VR Headset','Drone','Fitness Tracker','Blender','Coffee Maker','Toaster','Microwave Oven','Air Fryer','Slow Cooker','Juicer','Food Processor','Stand Mixer','Rice Cooker','Vacuum Cleaner','Ironing Board','Hair Dryer','Electric Kettle','Water Filter Pitcher','Dishwasher Detergent Pods','Laundry Detergent Pods'
]

for i in range(50):
    
    product_id = i + 1
    product_name = random.choice(products_name)
    category = random.choice(categories)
    subcategory = random.choice(subcategories)
    production_quantity = random.randint(10, 100)
    production_date = fake.date_between(start_date='-1y', end_date='today')

    product.append({
        'product_id': product_id,
        'product_name': product_name,
        'category': category,
        'subcategory': subcategory,
        'production_quantity': production_quantity,
        'production_date': production_date
    })
    
costings = []


for i in range(50):
    
    product_id = i + 1
    raw_material_cost = round(random.uniform(100.0, 1000.0), 2)
    shiftment_cost = round(random.uniform(100.0, 1000.0), 2)
    maintainance_cost = round(random.uniform(100.0, 1000.0), 2)
    transportation_cost = round(random.uniform(100.0, 1000.0), 2)

    costings.append({
        'product_id': product_id,
        'raw_material_cost': raw_material_cost,
        'shiftment_cost': shiftment_cost,
        'maintainance_cost': maintainance_cost,
        'transportation_cost': transportation_cost
        
    })

df_customers = pd.DataFrame(customers)
df_sales = pd.DataFrame(sales)
df_employees = pd.DataFrame(employees)
df_salaries = pd.DataFrame(salaries)
df_product = pd.DataFrame(product)
df_costings = pd.DataFrame(costings)

df_customers.to_csv('customers.csv', index=False)
df_sales.to_csv('sales.csv', index=False)
df_employees.to_csv('employees.csv', index=False)
df_salaries.to_csv('salaries.csv', index=False)
df_product.to_csv('products.csv', index=False)
df_costings.to_csv('costings.csv', index=False)
