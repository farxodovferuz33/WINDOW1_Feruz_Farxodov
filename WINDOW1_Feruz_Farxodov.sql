-- ==> A query to generate a sales report for customers ranked in the top 300
-- ==> Based on total sales in the years 1998, 1999, and 2001, below the query is detailed description

WITH RankedSales AS (
  SELECT
    cust_id,
    channel_id,
    EXTRACT(YEAR FROM time_id) AS sale_year,
    ROUND(SUM(amount_sold), 2) AS total_sales,
    RANK() OVER (PARTITION BY channel_id, EXTRACT(YEAR FROM time_id)
    ORDER BY SUM(amount_sold) DESC) AS sales_rank  
  FROM
    sh.sales
  WHERE
    EXTRACT(YEAR FROM time_id) IN (1998, 1999, 2001) 
  GROUP BY
    cust_id,
    channel_id,
    sale_year
)
SELECT
  cust_id AS Customer_ID,
  channel_id AS sales_channel,
  sale_year,
  total_sales,
  sales_rank
FROM
  RankedSales
WHERE
  sales_rank <= 300
AND 
  channel_id = 2
ORDER BY
  sales_channel,
  sale_year,
  sales_rank;
 
-- The query filters sales data for the years 1998, 1999, and 2001 
-- using WHERE EXTRACT(YEAR FROM time_id) IN (1998, 1999, 2001).
-- It then ranks customers based on their total sales in these years using the RANK() window function,
-- partitioned by channel_id and sale_year and ordered by the sum of amount_sold in descending order.
-- The main SELECT statement at the end of the query includes a WHERE sales_rank <= 300 clause,
-- ensuring that only customers ranked in the top 300 for each channel and year are selected.
-- The query categorizes customers by sales channels through the channel_id column.
-- This categorization is used in the PARTITION BY clause of the RANK() function,
-- ensuring that the ranking is done within each sales channel.
-- The PARTITION BY channel_id in the RANK() function ensures that the ranking is calculated separately for each sales channel.
-- WHERE channel_id = 2 Includes in the report only purchases made on the specific channel, which is 2.
-- The query uses ROUND(SUM(amount_sold), 2) in the CTE, which calculates the total sales (TotalSales) and formats it to two decimal places.
-- As you can see query perfoems all required tasks successfuly 
