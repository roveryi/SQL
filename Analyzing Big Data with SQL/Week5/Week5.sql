```
ORDER BY Clause
Take previous query results and return in a specific order 
The ORDER BY column must in the SELECT list
```
# The order is arbitrary and unpredictable 
SELECT * FROM games;

# The order is specified by id
SELECT * FROM games ORDER BY id;

SELECT * FROM games ORDER BY list_price;

# Within tied rows, the order is arbitrary
SELECT * FROM games ORDER BY min_players;

# More than 1 column references in ORDER BY
# The tied rows order is determined by the second column reference
SELECT * FROM games ORDER BY max_players, list_price;

# Order BY clause with other clauses
SELECT shop, SUM(qty) FROM inventory
	WHERE price IS NOT NULL
	GROUP BY shop
	ORDER BY shop;

```
Controling order:
Ascending order by default
ORDER BY ... ASC;
ORDER BY ... DESC;

When use multiply column references, specify descending and ascending for each of them

```
# Order by descending order of list_price
SELECT * FROM games ORDER BY list_price DESC;

SELECT name, max_players, list_price FROM games 
	ORDER BY max_players DESC, list_price ASC;

```
Ordering Expressions
```
SELECT *
	FROM crayons
	ORDER BY (greatest(red, green, blue) - least(red, green, blue)) / greatest(red, green, blue) DESC;

SELECT *, (greatest(red, green, blue) - least(red, green, blue)) / greatest(red, green, blue) AS saturation
	FROM crayons ORDER BY saturation;

```
Missing values in order by
Different SQL engines deal with NULL values in ordering columns in different ways
Impala and PostgreSQL: NULL is higher than other values
Hive and MySQL: NULL is lower than other values 

Control the order of NULL (Impala, PostgreSQL, latest Hive):
NULLS FIRST
NULLS LAST 

Remove the NULL rows 
```
SELECT shop, game, price FROM inventory ORDER BY price NULLS FIRST;

SELECT shop, game, price FROM inventory 
	ORDER BY aisle DESC NULLS LAST, price ASC NULLS FIRST;

SELECT shop, game, price FROM inventory ORDER BY price IS NULL ASC, price;


```
Impala
ORDER BY 3; # order by the 3rd column 

Only sort the data when you need to because it is computationally expensive.
```


```
LIMIT Clause
Set the maximum number of row that the query returns 

When to use LIMIT Clause
Want to return a few rows to see the structure of the data
When write a query but don't know how many rows would return 

Using LIMIT with ORDER BY

Using LIMIT for Pagination
row limit 
row offset

Impala, PostgreSQL: LIMIT limit OFFSET offset
Newer versions of Hive: LIMIT offset, limit
MySQL supports both syntaxes

Without ORDER BY, order is arbitrary and unpredictable
Pagination then might duplicate or miss rows
Solution: always use ORDER BY to arrange rows for pagination 
```
# Arbitrary 5 rows are returned
SELECT * FROM flights LIMIT 5;

# Practice 
# write and run a new query with Impala that displays only the two combinations of airline 
# (carrier) and airport (origin) had the quickest flights (smallest average air_time) from 
# New York City to Honolulu. 
# The three New York City airports are EWR, JFK, and LGA. Honolulu airport is HNL.
SELECT carrier, origin, dest, AVG(air_time) AS avg_air_time 
	FROM flights 
	WHERE dest = 'HNL' AND origin IN('EWR', 'JFK', 'LGA') 
	GROUP BY origin, carrier, dest 
	ORDER BY avg_air_time 
	LIMIT 2;

``` 
Review
Syntactic order
	- SELECT
	- FROM
	- WHERE
	- GROUP BY
	- HAVING
	- ORDER BY
	- LIMIT
Engine execute order 
	- FROM 
	- WHERE
	- GROUP BY
	- HAVING
	- SELECT
	- ORDER BY
	- LIMIT
Exception: column alias 
```


```
Write a query to return the data in fly.flights for American Airlines (carrier is AA) so that they are sorted by distance with the longest distance first, and for those that tie distances, 
by air_time with the shortest air time first. 
```
ECT carrier, air_time, distance FROM flights WHERE carrier = 'AA' ORDER BY distance DESC, air_time ASC LIMIT 2

















