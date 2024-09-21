-- Cross Join
/*1. Suppose every vendor in the `vendor_inventory` table had 5 of each of their products to sell to **every** 
customer on record. How much money would each vendor make per product? 
Show this by vendor_name and product name, rather than using the IDs.

HINT: Be sure you select only relevant columns and rows. 
Remember, CROSS JOIN will explode your table rows, so CROSS JOIN should likely be a subquery. 
Think a bit about the row counts: how many distinct vendors, product names are there (x)?
How many customers are there (y). 
Before your final group by you should have the product of those two queries (x*y).  */


-- I am approaching this problem like this: 
-- Step 1- Interpret the question: Every "customer_id" (from "customer" table) buys 5 of each of the products 
-- from each of the "vendor_id" (from the "vendor_inventory" table). Question: How much does each vendor make per product? 
-- Step 2- Define the calculation: revenue per product per vendor 
								-- = count of unique customers (from "customer" table)
								-- x 5 x price of the product_id (from "vendor_inventory" table)
								-- AGGREGATED SUM() to each distinct product_id (from "vendor_inventory" table_) 		
-- Step 3- GROUP BY vendor and product - to show aggregated sum of revenues per unique combinations of vendor and products 
-- Step 4- Use CROSS JOIN on the "customer" table - as we should have a flat count of unique customers for the calculation above 
-- Step 5- As the requestor wants to see "vendor_name" (from "vendor" table) and "product_name" (from "product" table), I will use 
         -- 2 INNER JOIN clauses. INNER JOIN because the requestor likely doesn't want to see products/vendors that have no names. 
-- Step 6- Use 2 SELECT DISTINCT clauses - for counts of distinct_customers, and distinct product_ids per vendor 
-- Step 7-- Arrange the syntax as per SQL operations order 




	SELECT 
		vendor.vendor_name, -- display name instead of id, as per requirement
		product.product_name, -- display name instead of id, as per requirement
		SUM(unique_customers * 5 * distinct_inventory.original_price) AS total_revenue 
		-- "unique_customers" is defined in the CROSS JOIN clause below - it's just basically "customer_count" of 
		-- the "customer_id" from the "customer" table, but I'm using this DISTINCT clause just to build a good habit. 
		-- I choose to have the CROSS JOIN clause after the JOIN clauses - to simplify our code 
		-- (If we put CROSS JOIN before the JOIN clauses, the "customer_count" alias will be treated as a table, and 
		-- we would have to do "customer_count.customer_count", which can look confusing to viewer. 
	FROM
		-- SELECT DISTINCT clause below is to only take distinct combinations of vendor and product, to not inflate our revenue calculation. 
		(
		SELECT DISTINCT
			vendor_id,
			product_id,
			original_price 
			-- As we will have "distinct_inventory.original_price" in the aggregate SUM() function above, 
			-- we would have to include "original_price" in this subquery table. 
			-- (Note: If we don't put "original_price" here, we would have to write another JOIN clause to join 
			-- distinct_inventory with vendor_inventory to extract original_price - which would make the code
			-- confusing).
		FROM 
			vendor_inventory
		) 
		AS distinct_inventory
		
		INNER JOIN 
			vendor ON distinct_inventory.vendor_id = vendor.vendor_id
			-- INNER JOIN because we only care about vendors that have id records 
		INNER JOIN
			product ON distinct_inventory.product_id = product.product_id 
			-- INNER JOIN because we only care about products that have id records 
		CROSS JOIN
		-- CROSS JOIN clause is to setup the "unique_customers" count data for the aggregate SUM() clause above. 
			(
			SELECT 
				COUNT(DISTINCT customer_id) AS unique_customers 
				-- The DISTINCT clause in our case is redundant but I just want to build a good habit for myself. 
			FROM 
				customer
			)
			AS customer_count 
	GROUP BY
		vendor.vendor_name, 
		product.product_name;
		-- GROUP BY vendor and product - to show aggregated sum of revenues per unique combinations of vendor and products.




-- INSERT
/*1.  Create a new table "product_units". 
This table will contain only products where the `product_qty_type = 'unit'`. 
It should use all of the columns from the product table, as well as a new column for the `CURRENT_TIMESTAMP`.  
Name the timestamp column `snapshot_timestamp`. */


-- MY ANSWER BELOW: 

-- DROPPING TABLE IF EXISTS (I tested with a coupld of codes that failed, the below codes are to clear history to avoid problem) 
	DROP TABLE IF EXISTS product_units; 
						
		
-- CREATING a new table name "product_units" 
	CREATE TABLE product_units AS 
		SELECT
			*, -- display all columns from the "product" table 
			CURRENT_TIMESTAMP AS snapshot_timestamp 
			-- add a new column for the "CURRENT_TIMESTAMP" and name it "snapshot_timestamp"
		FROM	
			product
		WHERE 
			product_qty_type = 'unit'; 	-- The table will contain only products where "product_qty_type" = 'unit'. 
				
					

/*2. Using `INSERT`, add a new row to the product_units table (with an updated timestamp). 
This can be any product you desire (e.g. add another record for Apple Pie). */

		
-- MY ANSWER BELOW: 

-- INSERTING a new row into the "product_units" table (with an updated timestamp).
	INSERT INTO product_units(product_id, 
								product_name,
								product_size,
								product_qty_type,
								product_category_id,
								snapshot_timestamp
								)
	VALUES (1001, -- randomly made up product id 
			'Apple Pie', -- as per suggested in the question 
			'Extra Large',-- randomly made up product size 
			'unit', -- random choice of quantity type 
			100, -- randomly made up category id 
			CURRENT_TIMESTAMP -- timestamp 
			);
			-- NOTE: the INSERT code will not display anything, we'd need the SELECT code below to display.
	
						
	-- DISPLAY the output. This step is crucial. 
	SELECT * 
	FROM product_units;
				
				


-- DELETE
/* 1. Delete the older record for the whatever product you added. 

HINT: If you don't specify a WHERE clause, you are going to have a bad time.*/


-- MY ANSWER BELOW:

-- DELETING the older record for product id that i added 
	DELETE FROM 
		product_units
	WHERE 
		product_id = 1001;
		
-- Displaying the output: 
	SELECT *
	FROM product_units;




-- UPDATE
/* 1.We want to add the current_quantity to the product_units table. 
First, add a new column, current_quantity to the table using the following syntax.

ALTER TABLE product_units
ADD current_quantity INT;

Then, using UPDATE, change the current_quantity equal to the last quantity value from the vendor_inventory details.

HINT: This one is pretty hard. 
First, determine how to get the "last" quantity per product. 
Second, coalesce null values to 0 (if you don't have null values, figure out how to rearrange your query so you do.) 
Third, SET current_quantity = (...your select statement...), remembering that WHERE can only accommodate one column. 
Finally, make sure you have a WHERE statement to update the right row, 
	you'll need to use product_units.product_id to refer to the correct row within the product_units table. 
When you have all of these components, you can run the update statement. */




-- I am approaching this problem like this: 
-- Step 1- Add a new column name "current_quantity" with data type 'integer' to the "product_units" table (using the given code in the question). 
-- Step 2- Use either INNER JOIN / or UPDATE (with a CET or on the existing table) on "product_units" table with "vendor_inventory" table
		-- as we only care about the product ids that match. 
-- Step 3- Get the most recent date for each product_id from "vendor_inventory" table - with either MAX() on the market_date or use WINDOWED function 
		-- rank (ROW_NUMBER()) to PARTITION BY product_id (from "vendor_inventory" table), ORDER BY market_date DESC. 
-- Step 4- Filter to only the most recent date per product using either WHERE rank = 1 on the WINDOWED ROW_NUMBER() function, 
		-- or use ORDER BY market_date of the "vendor_inventory" table and LIMIT to 1. 
-- Step 5- SET (with UPDATE clause) the filtered results, and put "quantity" from the "vendor_inventory" table into the column "current_quantity"
		--  in the "product_units" table.
-- Step 6- Decide on a final approach: 
		-- Use SET with UPDATE clause - as this is the most appropriate approach. 
		-- Stay on the "product_units" table -- to remove the need to create a CET. 
		-- Use ORDER BY market_date from "vendor_inventory" table, sort by DESC order, and LIMIT to 1 (as we're not using WINDOWED function with
				-- the rank clause to use the WHERE clause)
		-- Add a COALESCE clause to handle NULL value (convert NULL to 0), when engineer on the "vendor_inventory" table AND the "product_units" table. 
		


-- MY FINAL CODE BELOW: 
-- Add a new column "current_quantity" with datatype integer in the "product_units" table (code was given in the question). 
	ALTER TABLE 
		product_units
	ADD 
		current_quantity INT; 
		
		
-- Stay on the "product_units" table, update the "current_quantity" column:  
	UPDATE
		product_units
	SET 
		current_quantity = 
			COALESCE
				(
					(
					SELECT 
						COALESCE(vendor_inventory.quantity,0) 
						-- retrieve the "quantity" column from "vendor_inventory" table, and convert any NULL to 0. 
					FROM 
						vendor_inventory
						WHERE 
							vendor_inventory.product_id = product_units.product_id 
							-- UPDATE here serves like INNER JOIN, joining "product_units" table with "vendor_inventory" table,
							-- inner-joining ON "product_id". 
					ORDER BY 
						vendor_inventory.market_date DESC -- sort by most recent date  
						LIMIT 1 -- select only the most recent date 
					)
				,0); -- convert any NULL in "current_quantity" column to 0. 
-- 	With UPDATE, SQL processes the UPDATE statement 1 row at a time. Together with the WHERE clause where the "product_id" in both tables must match, 
-- and the LIMIT 1 clause: it only looks for the most recent quantity update that matches the product_id. This means the GROUP BY clause is not needed. 
					
					
-- Display the results, sort by product_id for aesthetic purposes. 
	SELECT * 
	FROM product_units
	ORDER BY product_id;
	
	
	
