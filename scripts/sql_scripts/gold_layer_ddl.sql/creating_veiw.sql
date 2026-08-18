USE BluesLtd_DWH;

GO

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;

GO 

CREATE VIEW gold.fact_sales AS
	SELECT
		order_date,
		sale_id,
		s.customer_id,
		cost.product_id,
		payment_method,
		order_quantity,
		ROUND (unit_price,0) AS unit_price,
		ROUND (discount, 0) AS discount,
		ROUND (tax, 0) AS tax,
		ROUND (total_sale, 0) AS total_sale,
		ROUND (((total_sale - discount) - tax) - total_cost, 0) AS total_profit

	FROM  silver.crm_customers c LEFT JOIN silver.crm_sales s
							ON s.customer_id = c.customer_id
							LEFT JOIN silver.erp_costings cost
							ON cost.product_id = s.product_id;

GO

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;

GO

CREATE VIEW gold.dim_customers AS 
	SELECT
		customer_name,
		customer_id,
		email,
		region,
		country,
		city,
		gender,
		platform
	FROM silver.crm_customers

GO

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;

GO

CREATE VIEW gold.dim_products AS 
	SELECT 
		production_date,
		product_name,
		p.product_id,
		category,
		p.subcategory,
		production_quantity,
		ROUND (raw_material_cost, 0) AS material_cost,
		ROUND (shiftment_cost, 0) AS shift_cost,
		ROUND (transportation_cost, 0) AS transport_cost,
		ROUND (maintainance_cost, 0) AS maintainance_cost,
		ROUND ((total_cost * production_quantity),0) AS total_cost
	FROM silver.erp_products p LEFT JOIN silver.erp_costings co
								ON p.product_id = co.product_id

	GO

	IF OBJECT_ID('gold.fact_employees', 'V') IS NOT NULL
    DROP VIEW gold.fact_employees;

	GO

	CREATE VIEW gold.fact_employees AS 
		SELECT
			name,
			e.employee_id,
			email,
			e.department,
			position,
			e.join_date,
			birth_date,
			gender,
			basic_salary,
			bounus,
			overtime_salary,
			total_salary
		FROM silver.erp_employees e LEFT JOIN silver.erp_salaries s
									ON e.employee_id = s.employee_id

