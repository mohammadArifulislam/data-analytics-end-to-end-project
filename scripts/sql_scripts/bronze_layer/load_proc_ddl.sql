

CREATE OR ALTER PROCEDURE bronze.sp_load_data
AS
BEGIN
    -- Performance & Execution Safety Settings
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @batch_start_time DATETIME = GETDATE();
    DECLARE @step_start_time DATETIME;

    BEGIN TRY
        PRINT '================================================';
        PRINT 'Starting Bronze Layer Bulk Ingestion Process';
        PRINT '================================================';

        -- ALL OR NOTHING TRANSACTION MANAGEMENT
        BEGIN TRANSACTION;

        -------------------------------------------------------------------
        -- 1. ERP EMPLOYEES
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: bronze.erp_employees';
        
        TRUNCATE TABLE bronze.erp_employees;

        INSERT INTO bronze.erp_employees (
            employee_id, first_name, last_name, email, address, 
            department, phone_number, position, join_date, birth_date, gender
        )
        SELECT 
            employee_id, first_name, last_name, email, address, 
            department, phone_number, position, join_date, birth_date, gender
        FROM OPENQUERY(
            [PG_LINKED_SERVER], 
            'SELECT employee_id, first_name, last_name, email, address, department, phone_number, position, join_date, birth_date, gender FROM erp.employees'
        );

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 2. ERP SALARIES
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: bronze.erp_salaries';

        TRUNCATE TABLE bronze.erp_salaries;

        INSERT INTO bronze.erp_salaries (
            salary_id, employee_id, basic_salary, bounus, 
            join_date, department, over_time_hours, payment_date
        )
        SELECT 
            salary_id, employee_id, basic_salary, bounus, 
            join_date, department, over_time_hours, payment_date
        FROM OPENQUERY(
            [PG_LINKED_SERVER], 
            'SELECT salary_id, employee_id, basic_salary, bounus, join_date, department, over_time_hours, payment_date FROM erp.salaries'
        );

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 3. ERP PRODUCTS
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: bronze.erp_products';

        TRUNCATE TABLE bronze.erp_products;

        INSERT INTO bronze.erp_products (
            product_id, product_name, category, subcategory, 
            production_quantity, production_date
        )
        SELECT 
            product_id, product_name, category, subcategory, 
            production_quantity, production_date
        FROM OPENQUERY(
            [PG_LINKED_SERVER], 
            'SELECT product_id, product_name, category, subcategory, production_quantity, production_date FROM erp.products'
        );

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 4. ERP COSTINGS
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: bronze.erp_costings';

        TRUNCATE TABLE bronze.erp_costings;

        INSERT INTO bronze.erp_costings (
            product_id, raw_material_cost, shiftment_cost, 
            maintainance_cost, transportation_cost
        )
        SELECT 
            product_id, raw_material_cost, shiftment_cost, 
            maintainance_cost, transportation_cost
        FROM OPENQUERY(
            [PG_LINKED_SERVER], 
            'SELECT product_id, raw_material_cost, shiftment_cost, maintainance_cost, transportation_cost FROM erp.costings'
        );

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 5. CRM CUSTOMERS
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: bronze.crm_customers';

        TRUNCATE TABLE bronze.crm_customers;

        INSERT INTO bronze.crm_customers (
            customer_id, customer_name, email, city, 
            region, country, gender, platform
        )
        SELECT 
            customer_id, customer_name, email, city, 
            region, country, gender, platform
        FROM OPENQUERY(
            [PG_LINKED_SERVER], 
            'SELECT customer_id, customer_name, email, city, region, country, gender, platform FROM crm.customers'
        );

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -------------------------------------------------------------------
        -- 6. CRM SALES
        -------------------------------------------------------------------
        SET @step_start_time = GETDATE();
        PRINT '>> Truncating & Ingesting: bronze.crm_sales';

        TRUNCATE TABLE bronze.crm_sales;

        INSERT INTO bronze.crm_sales (
            sale_id, customer_id, product_id, order_quantity, 
            unit_price, order_date, shift_date, discount, tax, payment_method
        )
        SELECT 
            sale_id, customer_id, product_id, order_quantity, 
            unit_price, order_date, shift_date, discount, tax, payment_method
        FROM OPENQUERY(
            [PG_LINKED_SERVER], 
            'SELECT sale_id, customer_id, product_id, order_quantity, unit_price, order_date, shift_date, discount, tax, payment_method FROM crm.sales'
        );

        PRINT '   Duration: ' + CAST(DATEDIFF(SECOND, @step_start_time, GETDATE()) AS VARCHAR) + ' seconds';

        -- COMMIT ALL INSERTS IF NO ERRORS
        COMMIT TRANSACTION;

        PRINT '================================================';
        PRINT 'Bronze Layer Bulk Ingestion Completed Successfully!';
        PRINT 'Total Pipeline Time: ' + CAST(DATEDIFF(SECOND, @batch_start_time, GETDATE()) AS VARCHAR) + ' seconds';
        PRINT '================================================';

    END TRY
    BEGIN CATCH
        -- ROLLBACK IN CASE OF FAILURE
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT '================================================';
        PRINT '!!! PIPELINE ERROR: INGESTION ROLLED BACK !!!';
        PRINT '================================================';

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
