SHOW STAGES;

List @Azure_Ext_Stg_New;

-- Remove all files from Stage
REMOVE @Azure_Ext_Stg_New;


-- Uploading / Loading Data == Local/Stages  >>> SF Tables == COPY INTO <Tbl> from <File location>
-- Unloading / Downlaoding = Table >>> Stages == COPY INTO <File Location> from <Tbl>
-- Move Data == Stage <> Stage   = COPY INTO <Stg>   from <Stg>


-- Move Data from SF Tables into Stages  -- COPY INTO -- Downloading


SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

COPY INTO @Azure_Ext_Stg_New FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

-- File names are system generated like data_0_0_0.csv, then 0_1_0 ...
LIST @Azure_Ext_Stg_New;

-- Custom relevant File name
-- And loading all data into One File only.
COPY INTO @Azure_Ext_Stg_New/Customerdata.csv 
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER 
    SINGLE = TRUE              -- While Unloading data how many files want to create.
    MAX_FILE_SIZE = 1700000000   -- DEFAULT = 16 MB   -- MAX = 5 GB    (In EXTERNAL Cloud like AWS)
    OVERWRITE = TRUE;          -- To Reload Data agaian in Same File

LIST @Azure_Ext_Stg_New/Customerdata.csv;

Select $1, $2 from @Azure_Ext_Stg_New/Customerdata2.csv ; 

-- If we Want "Query ID" in File Name
-- QUERY ID don't work w SINGLE = TRUE and OVERWRITE = TRUE

COPY INTO @Azure_Ext_Stg_New/Customerdata2.csv 
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER 
-- SINGLE = TRUE
Include_Query_ID = TRUE
MAX_FILE_SIZE = 17000000;  
-- OVERWRITE = TRUE;         

LIST @STG_CSV;


-- export data from a Snowflake table to an Azure External Stage in CSV format, with column headers and detailed information about the exported file like Total records and Size of each Files.
-- DETAILED_OUTPUT = TRUE



COPY INTO @Azure_Ext_Stg_New/Customerdata_2.csv
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER 
    DETAILED_OUTPUT = TRUE
    HEADER = TRUE       -- To see Col names
    OVERWRITE = TRUE;

LIST @Azure_Ext_Stg_New/Customerdata_2.csv;

-- Data VALIDATION Before Unlaoding into STAGE
-- It will Display data in SQL Output Console

COPY INTO @Azure_Ext_Stg_New/CustomerValidation.csv 
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER 
    VALIDATION_MODE = RETURN_ROWS;    -- check

LIST @STG_CSV; -- 13 Files

-- Load Data
COPY INTO @Azure_Ext_Stg_New/CustomerValidation.csv 
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;




-- Unloading into Stages only Supports CSV / JSON / PARQUET Only;

-- COPY FILES INTO FROM -- INTERNAL Stage <> EXTERNAL STAGES

CREATE STAGE Stage_Data;

show stages;

COPY FILES INTO @Stage_Data FROM @Azure_Ext_Stg_New/CustomerValidation.csv; 

List @Stage_data;
