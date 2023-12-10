WITH RankedCustomers AS (
    SELECT
        customer_id,
        sales_channel,
        total_sales,
        RANK() OVER (PARTITION BY sales_channel, order_year ORDER BY total_sales DESC) AS sales_rank
    FROM
        sales
    WHERE
        order_year IN (1998, 1999, 2001)
)
SELECT
    customer_id,
    sales_channel,
    order_year,
    total_sales
FROM
    RankedCustomers
WHERE
    sales_rank <= 300
ORDER BY
    sales_channel, order_year, sales_rank;
