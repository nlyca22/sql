-- COALESCE
/* 1. Our favourite manager wants a detailed long list of products, but is afraid of tables! 
We tell them, no problem! We can produce a list with all of the appropriate details. 

Using the following syntax you create our super cool and not at all needy manager a list:

SELECT 
product_name || ', ' || product_size|| ' (' || product_qty_type || ')'
FROM product

But wait! The product table has some bad data (a few NULL values). 
Find the NULLs and then using COALESCE, replace the NULL with a 
blank for the first problem, and 'unit' for the second problem. 

HINT: keep the syntax the same, but edited the correct components with the string. 
The `||` values concatenate the columns into strings. 
Edit the appropriate columns -- you're making two edits -- and the NULL rows will be fixed. 
All the other rows will remain the same.) */



		-- The below COALESCE code (provided in the question/requirement) concatenates values 
		-- from 3 columns "product_name", "product_size", and "product_qty_type" into a single
		-- text string for each row, in this format "product_name,product_size (product_qty_type).
					SELECT
						product_name || ',' || product_size || ' (' || product_qty_type || ')'
					FROM
						product; 
		-- The output shows 2 NULL values at row "14" and "15". 
		
					
					
		-- USING COALESCE, replace any NULL value with a blank '': 
					SELECT 
						COALESCE(product_name,'')|| ',' || 
						-- replace any NULL with blank ('') and concatenate "product_name" with
						-- "comma" and with the next line.
						COALESCE(product_size,'')|| ' (' || 
						-- replace any NULL with blank ('') and concatenate "product_size" with
						-- " (" and with the next line.
						COALESCE(product_qty_type,'')|| ')' 
						-- replace any NULL with blank ('') and concatenate "product_qty_type"
						-- with ")".
						AS product_details 
						-- name the resulting column "product_details" for aesthetic purposes
					FROM 
						product; 
		-- In contrast with the 1st COALESCE code, the output here now shows the entire rows "14" 
		-- and "15" populated with the non-NULL product names, and any NULL values found in column
		-- 	"product_size" and "product_qty_type" are now showing as blank ''. 
		 

						
					
		-- USING COALESCE, replace any NULL value with a blank '': 
					SELECT 
						COALESCE(product_name,'unit')|| ',' || 
						-- replace any NULL with 'unit' and concatenate "product_name" with
						-- "comma" and with the next line.
						COALESCE(product_size,'unit')|| ' (' || 
						-- replace any NULL with 'unit' and concatenate "product_size" with
						-- " (" and with the next line.
						COALESCE(product_qty_type,'unit')|| ')' 
						-- replace any NULL with blank 'unit' and concatenate "product_qty_type"
						-- with ")".
						AS product_details 
						-- name the resulting column "product_details" for aesthetic purposes
					FROM 
						product;
		-- Similar to the above COALESCE code, the output here now shows the entire rows "14" and 
		-- "15" populated with the non-NULL product names, and any NULL values found in column
		-- 	"product_size" and "product_qty_type" are now showing as 'unit'. 
	
	


--Windowed Functions
/* 1. Write a query that selects from the customer_purchases table and numbers each customer’s  
visits to the farmer’s market (labeling each market date with a different number). 
Each customer’s first visit is labeled 1, second visit is labeled 2, etc. 

You can either display all rows in the customer_purchases table, with the counter changing on
each new market date for each customer, or select only the unique market dates per customer 
(without purchase details) and number those visits. 
HINT: One of these approaches uses ROW_NUMBER() and one uses DENSE_RANK(). */


		-- 	OPTION 1: Using ROW_NUMBER() 
					SELECT
						ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date) AS visit_number,
						-- "AS" is to create a new column name "visit_number" 
						-- "PARTITION BY customer_id" is to number each customer's visit. 
						-- "ORDER BY maker_date" is to sort the visit dates in ascending order (from 
						-- oldest to most recent) within each customer. 
						customer_id,
						market_date
					FROM 
						(
							SELECT DISTINCT -- select only unique combinations of "customer_id" and "market_date" 
								customer_id,
								market_date
							FROM 
								customer_purchases
						)
						AS unique_combinations_data; -- create this as a new table name "unique_combinations_data"
					

					
		-- 	OPTION 2: Using DENSE_RANK() 
					SELECT
						DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY market_date) AS visit_number,
						-- "AS" is to create a new column name "visit_number" 
						-- "PARTITION BY customer_id" is to number each customer's visit. 
						-- "ORDER BY maker_date" is to sort the visit dates in ascending order (from 
						-- oldest to most recent) within each customer. 
						customer_id,
						market_date
					FROM 
						(
						SELECT DISTINCT -- select only unique combinations of "customer_id" and "market_date" 
								customer_id,
								market_date
						FROM
								customer_purchases
						)
						AS unique_combinations_data -- create this as a new table name "unique_combinations_data"
					ORDER BY -- sort by "customer_id" and "market_date" for readabilty 
						customer_id,
						market_date;
						

/* 2. Reverse the numbering of the query from a part so each customer’s most recent visit is labeled 1, 
then write another query that uses this one as a subquery (or temp table) and filters the results to 
only the customer’s most recent visit. */

		-- 	OPTION 1: Using ROW_NUMBER()
			-- 1.1 Labeling most recent visit as "1" for each customer's. 
					SELECT
						ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number,
						-- "DESC" is to sort by most recent visit date per customer.
						customer_id,
						market_date
					FROM 
						customer_purchases;
						-- note that we don't need the "DISTINCT" clause because it won't matter, we're going
						-- to filter just the single most recent visit. 

			-- 1.2 Filtering the results to only show each customer's most recent visit, using the above as a subquery (or temporary table). 
					SELECT 
						customer_id,
						market_date
					FROM 
						(
						SELECT  
							ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number,
							-- "DESC" is to sort by most recent visit date per customer.
							customer_id,
							market_date
						FROM
							customer_purchases
						)
						AS unique_combinations_data
					WHERE 
						visit_number = 1; -- filter result to only show the most recent visit per customer. 
						
						

		-- 	OPTION 2: Using DENSE_RANK()
			-- 2.1 Labeling most recent visit as "1" for each customer's. 
					SELECT
						DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number,
						-- "DESC" is to sort by most recent visit date per customer.
						customer_id,
						market_date
					FROM 
						( 
						SELECT DISTINCT -- note: for DENSE_RANK() we'd still need DISTINCT clause, otherwise, it'll show duplicate for same-date. 
							customer_id,
							market_date 
						FROM 
							customer_purchases
						)
						AS unique_combinations_data  
					ORDER BY  
						customer_id,
						market_date;


			-- 2.2 Filtering the results to only show each customer's most recent visit, using the above as a subquery (or temporary table). 
					SELECT 
						customer_id,
						market_date
					FROM 
						(
						SELECT
								DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number,
							-- "DESC" is to sort by most recent visit date per customer.
								customer_id,
								market_date
						FROM 
							( 
							SELECT DISTINCT -- note: for DENSE_RANK() we'd still need DISTINCT clause, otherwise, it'll show duplicate for same-date. 
									customer_id,
									market_date 
							FROM 
									customer_purchases
							)
						AS unique_combinations_data 
						)
						AS ranked_visit_number -- name this temp column 
					WHERE
						visit_number = 1; -- filter result to just the most recent visit per customer. 

													
							
							

/* 3. Using a COUNT() window function, include a value along with each row of the 
customer_purchases table that indicates how many different times that customer has purchased that product_id. */

				SELECT 
					customer_id,
					product_id,
					--quantity -- for double-checking purposes
					--market_date -- for double-checking purposes
					-- transaction_time -- for double-checking purposes 
					COUNT(*) as purchase_count
					-- "COUNT(*) is to count the number of times the specific unique combinations of the above 2 variables appear in dataset. 
				FROM 
					customer_purchases
				GROUP BY 
				-- Grouping the output rows by unique combinations of the below 2 variables,
				-- ensuring that the count is calculate for each grouping. 
					customer_id,
					product_id;
				

				
				
-- String manipulations
/* 1. Some product names in the product table have descriptions like "Jar" or "Organic". 
These are separated from the product name with a hyphen. 
Create a column using SUBSTR (and a couple of other commands) that captures these, but is otherwise NULL. 
Remove any trailing or leading whitespaces. Don't just use a case statement for each product! 

| product_name               | description |
|----------------------------|-------------|
| Habanero Peppers - Organic | Organic     |

Hint: you might need to use INSTR(product_name,'-') to find the hyphens. INSTR will help split the column. */


			SELECT 
				product_name,
				CASE -- if/then statement 
					WHEN 
						INSTR(product_name,'-') > 0
						-- INSTR() is to find where a hyphen '-' is in product_name
						-- >0 is to check true/false if a hyphen is found 
					THEN 
						TRIM(SUBSTR(product_name,INSTR(product_name,'-')+1))
						-- SUBSTR(... +1) is to extract the substring starting right after the hyphen 
						-- TRIM(...) is to remove any leading/trailing spaces from the extracted substring 
					ELSE 
						NULL 
						-- Return NULL if there's no hyphen in product_name 
					END AS 
						description
						-- Put the result in a new column name "description" 
			FROM 
				product;



	-- PERONAL NOTE: if we just wnt to see the list of product_name that has description: 
			SELECT 
				product_name,
				TRIM(SUBSTR(product_name,INSTR(product_name,'-')+1)) AS description
			FROM 
				product
			WHERE INSTR(product_name,'-') > 0;
				

				
/* 2. Filter the query to show any product_size value that contain a number with REGEXP. */

			SELECT 
				product_name,
				product_size,
				CASE -- if/then statement 
					WHEN 
						INSTR(product_name,'-') > 0
					THEN 
						TRIM(SUBSTR(product_name,INSTR(product_name,'-')+1))
					ELSE 
						NULL 					
					END AS 
						description
						-- Put the result in a new column name "description" 
			FROM 
				product
			WHERE 
				product_size REGEXP '[0-9]';
				-- REGEXP '[0-9]' is used to match any product_size value that contains a numerical digit. 



-- UNION
/* 1. Using a UNION, write a query that displays the market dates with the highest and lowest total sales.

HINT: There are a possibly a few ways to do this query, but if you're struggling, try the following: 
1) Create a CTE/Temp Table to find sales values grouped dates; 
2) Create another CTE/Temp table with a rank windowed function on the previous query to create 
"best day" and "worst day"; 
3) Query the second temp table twice, once for the best day, once for the worst day, 
with a UNION binding them. */


				-- I will approach this problem like this: 
				-- Step 1: Calculate total sales for each market date 
				-- Step 2: Group the total sales by market date 
				-- Step 3: Sort them by Descending order (best day) and Ascending order (worst day)
				-- Step 4: Select just the best day and the worst day 
				-- Step 4: Combine the results using UNION, with 3 columns: "market_date", "total_sales", and "label"
				-- 			where the values would either be "best_day" or "worst_day". 
				
				
				-- CODING below
				-- FINDING THE BEST DAY 
						SELECT 
							market_date,
							SUM(quantity * cost_to_customer_per_qty) AS total_sales
							-- Calculate the total sales (sum of the multiplications) 
							-- Put the result in a new column name "total_sales" 
						FROM 
							customer_purchases
						GROUP BY 
							market_date -- group the total_sales by date 
						ORDER BY 
							total_sales DESC -- sort by most total sales amount 
						LIMIT 1; -- select the top result (best day)
				
				
				-- FINDING THE WORST DAY 
						SELECT 
							market_date,
							SUM(quantity * cost_to_customer_per_qty) AS total_sales
							-- Calculate the total sales (sum of the multiplications) 
							-- Put the result in a new column name "total_sales" 
						FROM 
							customer_purchases
						GROUP BY 
							market_date -- group the total_sales by date 
						ORDER BY 
							total_sales ASC -- sort by least total sales amount 
						LIMIT 1; -- select the top result (worst day)
				
				
				-- UNION: COMBINING the 2 results, and giving them appropriate naming 
					-- BEST DAY portion: 
						SELECT 
							market_date,
							total_sales,
							'best day' as label -- display a new column name "label" and input the result of this function as "best day" 
						FROM 
							(
							SELECT 
								market_date,
								SUM(quantity * cost_to_customer_per_qty) AS total_sales
							FROM 
								customer_purchases
							GROUP BY 
								market_date  
							ORDER BY 
								total_sales DESC  
							LIMIT 1 
							)
							
					
						UNION -- combine command 
					
					-- WORST DAY portion: 
						SELECT 
							market_date,
							total_sales,
							'worst day' as label -- display a new column name "label" and input the result of this function as "worst day" 
						FROM 
							(
							SELECT 
								market_date,
								SUM(quantity * cost_to_customer_per_qty) AS total_sales
							FROM 
								customer_purchases
							GROUP BY 
								market_date  
							ORDER BY 
								total_sales ASC  
							LIMIT 1 
							);
				
				
				
				
		
