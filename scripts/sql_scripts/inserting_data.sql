/*
===========================================================================
Insert Data to The Central Database.
===========================================================================
Script purpose: 
        This script represents for inserting data from local csv file that we have made for this projects using python scripts.
Note: 
        The sources of the data comes from the 'erp' for this reason stored all data in 'erp' schema of the database.

*/


COPY erp.employees 
FROM 'D:/data_scripts/data/employees.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);
COPY erp.salaries 
FROM 'D:/data_scripts/data/salaries.csv' 
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);
COPY erp.products 
FROM 'D:/data_scripts/data/products.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);
COPY erp.costings
FROM 'D:/data_scripts/data/costings.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);
