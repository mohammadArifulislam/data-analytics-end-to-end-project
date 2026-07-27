CREATE OR ALTER PROCEDURE silver.sp_load_data
AS
BEGIN
    -- Performance & Execution Safety Settings
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @batch_start_time DATETIME = GETDATE();
    DECLARE @step_start_time DATETIME;

    BEGIN TRY
        PRINT '================================================';
        PRINT 'Starting Silver Layer Data Transformation Process';
        PRINT '================================================';

        -- ALL OR NOTHING TRANSACTION MANAGEMENT
        BEGIN TRANSACTION;

        -------------------------------------------------------------------
        -- 1. ERP EMPLOYEES
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: silver.erp_employees';

        TRUNCATE TABLE silver.erp_employees;

        INSERT INTO silver.erp_employees (
            employee_id, name, email, 
            postal_code, road_name, house_no, department, 
            phone_number, position, join_date, birth_date, gender
        )
        SELECT 
            employee_id, 
            CONCAT(first_name , ' ' , last_name) AS name,
            email,
            CASE 
                WHEN CHARINDEX(' ', CAST(address AS VARCHAR(MAX))) > 0 
                THEN SUBSTRING(CAST(address AS VARCHAR(MAX)), 1, CHARINDEX(' ', CAST(address AS VARCHAR(MAX))) - 1)
                ELSE CAST(address AS VARCHAR(MAX))
            END AS postal_code,
            CASE 
                WHEN CHARINDEX(' ', CAST(address AS VARCHAR(MAX))) > 0 
                     AND CHARINDEX(',', CAST(address AS VARCHAR(MAX))) > CHARINDEX(' ', CAST(address AS VARCHAR(MAX)))
                THEN SUBSTRING(
                        CAST(address AS VARCHAR(MAX)), 
                        CHARINDEX(' ', CAST(address AS VARCHAR(MAX))) + 1, 
                        CHARINDEX(',', CAST(address AS VARCHAR(MAX))) - CHARINDEX(' ', CAST(address AS VARCHAR(MAX))) - 1
                     )
                ELSE 'Not Found'
            END AS road_name,
            CASE 
                WHEN CHARINDEX(',', CAST(address AS VARCHAR(MAX))) > 0 
                THEN LTRIM(SUBSTRING(CAST(address AS VARCHAR(MAX)), CHARINDEX(',', CAST(address AS VARCHAR(MAX))) + 1, LEN(CAST(address AS VARCHAR(MAX)))))
                ELSE 'Not Found'
            END AS house_no,
            department,
            REPLACE(TRANSLATE(phone_number, '+.()-x ', '       '), ' ', '') AS phone_number,
            position,        
            join_date,     
            birth_date,      
            CASE 
                WHEN UPPER(TRIM(gender)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(gender)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS gender
        FROM bronze.erp_employees;

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 2. ERP SALARIES
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: silver.erp_salaries';

        TRUNCATE TABLE silver.erp_salaries;

        INSERT INTO silver.erp_salaries (
            salary_id, employee_id, basic_salary, bounus, 
            join_date, department, over_time_hours, payment_date, 
            overtime_salary, total_salary
        )
        SELECT 
            salary_id,  
            employee_id,
            basic_salary,    
            bounus,        
            join_date,      
            department,    
            over_time_hours, 
            payment_date,
            (ISNULL(over_time_hours, 0) * 150) AS overtime_salary,
            (ISNULL(basic_salary, 0) + ISNULL(bounus, 0) + (ISNULL(over_time_hours, 0) * 150)) AS total_salary
        FROM bronze.erp_salaries;

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 3. ERP PRODUCTS
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: silver.erp_products';

        TRUNCATE TABLE silver.erp_products;

        INSERT INTO silver.erp_products (
            product_id, product_name, category, subcategory, 
            production_quantity, production_date
        )
        SELECT
            product_id,         
            product_name,         
            category,          
            subcategory,          
            production_quantity,  
            production_date
        FROM bronze.erp_products;

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 4. ERP COSTINGS
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: silver.erp_costings';

        TRUNCATE TABLE silver.erp_costings;

        INSERT INTO silver.erp_costings (
            product_id, raw_material_cost, shiftment_cost, 
            maintainance_cost, transportation_cost, total_cost
        )
        SELECT
            product_id,
            raw_material_cost,
            shiftment_cost,
            maintainance_cost,
            transportation_cost,
            (ISNULL(raw_material_cost, 0) + ISNULL(shiftment_cost, 0) + ISNULL(maintainance_cost, 0) + ISNULL(transportation_cost, 0)) AS total_cost
        FROM bronze.erp_costings;

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 5. CRM CUSTOMERS
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: silver.crm_customers';

        TRUNCATE TABLE silver.crm_customers;

        INSERT INTO silver.crm_customers (
            customer_id, customer_name, email, city, 
            region, country, gender, platform
        )
        SELECT
            customer_id,
            customer_name,
            email,
            city,
            region,
            country,
            CASE 
                WHEN UPPER(TRIM(gender)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gender)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS gender,
            platform
        FROM bronze.crm_customers;

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 6. CRM SALES
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: silver.crm_sales';

        TRUNCATE TABLE silver.crm_sales;

        INSERT INTO silver.crm_sales (
            sale_id, customer_id, product_id, order_quantity, 
            unit_price, order_date, shift_date, discount, 
            tax, total_sale, payment_method
        )
        SELECT
            sale_id,
            customer_id,
            product_id,
            order_quantity,
            unit_price,
            order_date,
            shift_date,
            discount,
            tax,
            (ISNULL(order_quantity, 0) * ISNULL(unit_price, 0)) AS total_sale,
            payment_method
        FROM bronze.crm_sales;

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -- COMMIT ALL INSERTS IF NO ERRORS
        COMMIT TRANSACTION;

        PRINT '================================================';
        PRINT 'Silver Layer Data Transformation Completed Successfully!';
        PRINT 'Total Pipeline Time: ' + CAST(DATEDIFF(SECOND, @batch_start_time, GETDATE()) AS VARCHAR) + ' seconds';
        PRINT '================================================';

    END TRY
    BEGIN CATCH
        -- ROLLBACK IN CASE OF FAILURE
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT '================================================';
        PRINT '!!! PIPELINE ERROR: TRANSFORMATION ROLLED BACK !!!';
        PRINT '================================================';

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

EXEC silver.sp_load_data
