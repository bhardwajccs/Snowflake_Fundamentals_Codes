/*

Users, Roles, Role Hierarchy, and Privilege Inheritance

Roles define what users can access within the platform. 
Instead of granting privileges directly to users, roles are assigned privileges, and users are assigned roles.

A role can be assigned to another role, creating a hierarchical structure.
If Role A is assigned to Role B, then Role B will inherit all privileges granted to Role A.

System-defined roles (e.g., ACCOUNTADMIN, SYSADMIN, SECURITYADMIN) cannot be dropped.

Privileges granted to system-defined roles cannot be revoked.

TYPES 

1. Account Roles :

SQL actions on any object on account-level
Grant privileges on the object to an account role

2. Database Roles :

SQL actions on a single database and the objects within the single database


3. Application Roles


4. Service Roles


**************************************

System-Defined Roles

Snowflake comes with built-in roles that handle different levels of access.
These cannot be dropped or modified but can be assigned to other roles.

1. GLOBALORGADMIN

Organization administrator
Exists only in the organization account
Manages the lifecycle of accounts
Can view organization-level usage information

2. ORGADMIN

Regular account to manage organization-level tasks and operations
Recommended to use GLOBALORGADMIN

3. ACCOUNTADMIN

Account Administrator
Full control over the account

4. SECURITYADMIN

Security Administrator
Create and manage roles and users as well
The MANAGE GRANTS privilege gives the ability to grant and revoke privileges which does not give the SECURITYADMIN the ability to perform other actions such as creating objects.

5. USERADMIN

User and role Administrator
has CREATE USER and CREATE ROLE privilege
user and role management

6. SYSADMIN

System Administrator
Creation and Grant privileges on warehouses, databases and database objects within an account
If custom roles are created, assign them to SYSADMIN role

7. PUBLIC

Automatically granted by default to every user and role
Objects owned by this role is available to every other user and role within the account

*/
SELECT
    CURRENT_ROLE(),
    CURRENT_DATABASE(),
    CURRENT_SCHEMA();

SHOW ROLES;

CREATE ROLE custom_role;

GRANT USAGE ON DATABASE LALITDB TO ROLE custom_role;

GRANT USAGE, CREATE TABLE ON SCHEMA LALITDB.LALITSCHEMA TO ROLE custom_role;

GRANT ROLE custom_role TO ROLE SYSADMIN;

-- Displays the users and roles the role is assigned to 
-- and also by which role it was assigned
SHOW GRANTS OF ROLE custom_role; 

-- Displays privileges granted to the role
SHOW GRANTS TO ROLE custom_role;

GRANT USAGE ON FUTURE SCHEMAS IN DATABASE DB_NAME TO ROLE ROLE_NAME;


CREATE ROLE DATA_ENGINEER_ROLE;

CREATE USER LALIT_USER
PASSWORD = 'Wearesnowflake@123'
DEFAULT_ROLE = custom_role
MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE DATA_ENGINEER_ROLE
TO USER LALIT_USER;

--Extra

-- Give Grant on ALL TABLES to BI_Role
GRANT SELECT ON ALL TABLES IN SCHEMA Snowsql.raw_layer TO ROLE BI_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA Snowsql.raw_layer TO ROLE BI_ROLE;

-- To see who all can Access DB
SHOW GRANTS ON DATABASE SNOWSQL;

-- Futrue Roles
-- Go to DB > Privilidges > Change / Add
CREATE TABLE SNOWSQL.RAW_LAYER.ABC(ID INT);

DROP TABLE ABC;









