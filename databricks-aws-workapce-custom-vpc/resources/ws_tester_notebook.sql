-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Workspace Tester Notebook
-- MAGIC This notebook was designed to test Workspace Deployments. It is meant to run on any DBR 13.3+ / SQL Warehouse / Serverles environments.
-- MAGIC
-- MAGIC This notebooks runs through the basic CRUD routine on a test table in the "main.default" catalog. Please edit this value if it doesn't apply to your setup.

-- COMMAND ----------

-- Assign a SQL variable to know the name of the table
DECLARE VARIABLE table_name STRING DEFAULT '<catalog_name>.default.test_table';
-- Set the variable to a specific value
-- SET VAR table_name = 20;

-- COMMAND ----------

-- DBTITLE 1,Create Table
-- Create a table using CTAS, with some example data
CREATE TABLE table_name AS
SELECT 1 AS id, 'example' AS name
UNION ALL
SELECT 2 AS id, 'sample' AS name
UNION ALL
SELECT 3 AS id, 'test' AS name;
SELECT * FROM table_name;

-- COMMAND ----------

-- DBTITLE 1,Insertion into table
-- Test insertion into table
INSERT INTO table_name (id, name)
VALUES (4, 'new_entry');
SELECT * FROM table_name;

-- COMMAND ----------

-- DBTITLE 1,Delete from table
-- Test deletion
DELETE FROM table_name
WHERE id = 4 AND name = 'new_entry';
SELECT * FROM table_name;

-- COMMAND ----------

-- DBTITLE 1,Drop the test table
DROP TABLE table_name;