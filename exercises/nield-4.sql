-- Nield - Exercise 1

-- 1. How many unique customers does Rexon Metal have?
---- Requirements:
---- Must use: SELECT, count()
SELECT  count(distinct(customer_id))
FROM  customer
;

-- 2. On what date the order with the highest quantity was shipped?
---- Requirements:
----- MUST use: SELECT, max(), AS
SELECT ship_date, max(order_qty) AS max_qty
FROM customer_order
;