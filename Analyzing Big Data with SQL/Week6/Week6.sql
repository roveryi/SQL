```
UNION Operator
Combine two SELECT statements vertically

UNION ALL: return unordered vertically combined table
UNION DISTINCT

UNION = UNION DISTINCT (if no keywork is specified)

The UNION tables should have the same schema;

```
# UNION ALL
SELECT id, name FROM fun.games
UNION ALL
SELECT id, name FROM toy.toys;


SELECT country FROM customers 
UNION ALL
SELECT country FROM offices;

# Remove Duplicate
SELECT country FROM customers
UNION DISTINCT
SELECT country FROM offices;

# This doesn't work, column should use column alias to have the same name
SELECT name, list_price FROM fun.games
UNION ALL
SELECT name, price FROM toy.toys;
# This statment works
SELECT name, list_price AS price FROM fun.games
UNION ALL
SELECT name, price FROM toy.toys;

# This doesn't work, column should have the same data type 
# One of the year column is INT, the other is STR
SELECT year FROM fly.flights 
UNION DISTINCT
SELECT year FROM fun.games;
# This statment works
SELECT year FROM fly.flights
UNION DISTINCT
SELECT CAST(year AS INT) AS year FROM fun.games;

```
UNION with ORDER BY and LIMIT
	- ORDER BY
	With Impala, the ORDER BY clause at the end of this query arranges the rows from the 
	offices table in descending order by country, but it has no effect on the arrangement 
	of rows from the customers table. Furthermore, when the UNION operator combines the rows 
	from the two tables, there is no guarantee that it will preserve row ordering. 
	Therefore, there is no way to know for sure which value will be in the first row of this 
	result set.
	- LIMIT
```
# ORDER BY arrange combined tables 
# This only works with some SQL engines like MySQL, doesn't work with Hive and Impala
SELECT name, list_price AS price FROM fun.games
UNION ALL
SELECT name, price FROM toy.toys
ORDER BY price;
# Use subquarry in Hive and Impala

```
JOIN operator
Merge two tables horizontally with relationship
Related data are often stored in different tables

Syntax
# Join key columns, Inner join
SELECT * FROM table_name1 JOIN table_name2 ON expressions

In the inner join, only the matched rows are returned, the rows without a match are not returned
SELECT ... FROM table_name1 INNER JOIN table_name2 ON expressions;

# Outer join 
3 Types of outer join 
	- left outer join: if the left table has rows that doesn't exist in the right table, it would return it 
	SELECT ... FROM table_name1 LEFT OUTER JOIN table_name2 ON expressions;

	- right outer join: if the right table has rows that doesn't exist in the left table, it would return it 
	SELECT ... FROM table_name1 RIGHT OUTER JOIN table_name2 ON expressions;

	- full outer join
	SELECT ... FROM table_name1 FULL OUTER JOIN table_name2 ON expressions;

The order of the tables in left and right outer join matters.
LEFT OUTER JOIN is more used.
```
# This is a valid statment, but there would be columns with the same name
SELECT FROM toys JOIN makers ON toys.maker_id = makers.id
# In this case, use column alias make the results easier to understand
SELECT toys.id AS id, toys.name AS toy, price, maker_id, makers.name AS maker, city
	FROM toys JOIN makers ON toys.maker_id = makers.id;
# Use table alias to reduce the length of the statement
SELECT t.id AS id, t.name AS toy, price, maker_id, m.name AS maker, city 
	FROM toys AS t JOIN makers AS m ON t.maker_id = m.id;
