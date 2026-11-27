/*

Account has Objects(schemas, tables), associated Metdata

INFORMATION_SCHEMA / Data Dictionary has all those metadata info in each DB.

READ ONLY

Running Queries on INFORMATION_SCHEMA requires warehouse to be up and running

*/




-- ACCOUNT_USUAGE v/s INFORMATION_SCHEMA

-- ACCOUNT Level SNOWFLAKE Tables and VIEWS. 

Select * from SNOWFLAKE.INFORMATION_SCHEMA.Tables;

-- Database level Tables and VIEWS.

Select * from LALITDB.INFORMATION_SCHEMA.Tables;


-- ACCOUNT_USUAGE Schema

-- Provides information about tables created in your Snowflake account. -- Data Engineers use it to monitor and audit database objects.

Select * from SNOWFLAKE.ACCOUNT_USAGE.Tables;

-- Data Engineers use it to monitor scheduled pipelines, identify failures, and troubleshoot task execution.

Select * from SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY;   -- Table View



-- Monitor Snowflake Virtual Warehouse credit consumption and compute costs.

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY;

-- Find which privileges have been granted directly to Snowflake users.

SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS;
-- Differences in Notes





-- list of all tables in a Snowflake Schema

SELECT 
    table_name, 
    table_type
FROM 
    LALITDB.information_schema.tables
WHERE 
    table_schema = 'LALITSCHEMA'
ORDER BY 
    table_name;



-- Top 5 Table names with highest record count in each Snowflake Schema

SELECT table_schema, table_name, row_count
FROM(
    SELECT
        table_schema, table_name, row_count ,
        dense_rank() over(partition by table_schema order by row_count desc) as rnk
    FROM LALITDB.information_schema.tables
    WHERE row_count IS NOT NULL
  )
WHERE rnk <=5
ORDER BY table_schema, row_count desc;


-- Get the size (in bytes) of all tables in all schemas in DB

SELECT table_schema,sum(bytes)
FROM LALITDB.information_schema.tables
GROUP BY table_schema;


-- Get the time travel duration of all tables in a Snowflake Schema

SELECT table_name, retention_time
FROM LALITDB.information_schema.tables
WHERE table_schema = 'LALITSCHEMA'
ORDER BY table_name;

-- Get the list of all Primary Keys in all tables present in a Snowflake Schema

SELECT table_name, constraint_type, constraint_name
FROM LALITDB.information_schema.table_constraints
WHERE constraint_type = 'PRIMARY KEY' and table_schema = 'LALITSCHEMA'
ORDER BY table_name;


-- Generate SQL statements to change ownership on all tables owned by a role to a new role

SELECT 
    'grant ownership on table ' || table_name || ' to role my_new_role copy grants;' AS grant_statement
FROM 
    LALITDB.information_schema.table_privileges
WHERE 
    grantor = 'old_grant_role';


-- drop all tables in a Snowflake schema

SELECT 
    'drop table ' || table_name || ' cascade;'
FROM 
    LALITDB.information_schema.tables
WHERE 
    table_schema = 'LALITSCHEMA'
ORDER BY 
    table_name;




