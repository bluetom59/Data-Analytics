CREATE TABLE walmart_sales (
  Store INTEGER,
  Date DATE,
  Weekly_Sales NUMERIC,
  Holiday_Flag BOOLEAN,
  Temperature NUMERIC,
  Fuel_Price NUMERIC,
  CPI NUMERIC,
  Unemployment NUMERIC
);

select * from walmart_sales;
copy walmart_sales from 'C:/Users/91948/OneDrive/Desktop/IgniteHub-intern/Tasks/Task-2/Walmart sales Analysis.csv'
delimiter','csv HEADER;

/*1)Which year had the highest sales?*/
SELECT EXTRACT(YEAR FROM Date) AS year, SUM(Weekly_Sales) AS total_sales
FROM walmart_sales
GROUP BY year
ORDER BY total_sales DESC
LIMIT 1;

/*2)How was the weather during the year of highest sales?*/
WITH highest_sales_year AS (
    SELECT EXTRACT(YEAR FROM Date) AS year
    FROM walmart_sales
    GROUP BY year
    ORDER BY SUM(Weekly_Sales) DESC
    LIMIT 1
)
SELECT AVG(Temperature) AS avg_temperature, AVG(Fuel_Price) AS avg_fuel_price
FROM walmart_sales
WHERE EXTRACT(YEAR FROM Date) = (SELECT year FROM highest_sales_year);

/*3)Conclude whether the weather has an essential impact on sales.*/
SELECT 
  EXTRACT(YEAR FROM Date) AS year, 
  AVG(Temperature) AS avg_temperature, 
  AVG(Fuel_Price) AS avg_fuel_price, 
  SUM(Weekly_Sales) AS total_sales
FROM walmart_sales
GROUP BY year;

/*4)Do the sales always rise near the holiday season for all the years?*/
SELECT 
  EXTRACT(YEAR FROM Date) AS year,
  EXTRACT(MONTH FROM Date) AS month,
  SUM(Weekly_Sales) AS total_sales
FROM walmart_sales
WHERE EXTRACT(MONTH FROM Date) IN (11, 12)
GROUP BY year, month
ORDER BY year, month;

/*5)Analyze the relationship between sales and the different macroeconomic variables in the dataset.*/
SELECT 
  EXTRACT(YEAR FROM Date) AS year,
  SUM(Weekly_Sales) AS total_sales,
  AVG(CPI) AS avg_cpi,
  AVG(Unemployment) AS avg_unemployment
FROM walmart_sales
GROUP BY year;
