COPY erp.employees 
FROM 'D:/data_scripts/employees.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY erp.salaries 
FROM 'D:/data_scripts/salaries.csv' 
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY erp.products 
FROM 'D:/data_scripts/products.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);


SELECT * FROM erp.employees;
SELECT * FROM erp.salaries;
SELECT * FROM erp.products;
