```
Aggregation
Counting: how many rows 
Adding: compute sum
Computing average
Finding the minimum/maximum

Common Aggregate Function
Not capital sensitive, but generally used in capital letters
COUNT(*): count all rows 
SUM(x): add all supplied values and return result
AVG(x): return the average of all supplied values
MIN(x): return the lowest values
MAX(x): return the highest values

SELECT SUM(1) FROM tablename; # Can also be used for counting the rows

Using Aggregate Functions in the SELECT Statement

Aggregate expression: combine values from multiple rows
Non-aggregate or scalar expression: return one value per row

Valid mixing of aggregate and scalar operations 
	- round(AVG(list_price))
	- SUM(salary*0.062)
Invalid mixing of aggregate and scalar operations
	- SELECT salary - AVG(salary) FROM employees;
	- SELECT first_name, SUM(salary) FROM employees;

WHERE clause 
Do not try to use aggregation in the WHERE clause 
WEHER clause always produces individual rows

GROUP BY clause
```
# Count 
SELECT COUNT(*) FROM employees; # return one column and one row
SELECT COUNT(*) AS num_rows FROM employees;

# Sum
SELECT SUM(salary) FROM employees;

# Practice 1
# What is the average list price of the games in the fun.games table in US dollars?
SELECT AVG(list_price) FROM fun.games;

# Multiple aggregate functions
SELECT MIN(salary) AS lowest_salary, MAX(salary) AS highest_salary FROM employees;

# Expression of aggregate functions
SELECT MAX(salary) - MIN(salary) AS spread FROM employees;

# Practice 2
# If 1 US dollar is equivalent to 66.75 Indian rupees, what is the average list price of the games in the fun.games table in Indian rupees, rounded to two places after the decimal? 
SELECT round(AVG(list_price)*66.75, 2) FROM fun.games;

# WHERE clause 
SELECT COUNT(*) FROM employees WHERE salary > 30000;

# Practice 3
SELECT round(AVG(distance/air_time)*60) FROM flights WHERE air_time > 60;

# greatest function
SELECT MAX(red), MAX(green), MAX(blue) FROM wax.crayons; # Return 3 values
SELECT greatest(red, green, blue) FROM wax.crayons; # Return total number of rows values 


```
GROUP BY clause
Return the aggregate of each subset/group.
SELECT COUNT(*) FROM employees; # How many employees are there 
SELECT COUNT(*), office_id FROM employees GROUP BY office_id; # How many employees are in each office_id

GROUP BY and WHERE 
SELECT office_id, COUNT(*) FROM employees WHERE salary > 35000 GROUP BY office_id;

Selection of grouping column
SELECT shop, COUNT(*) FROM inventory GROUP BY shop;
SELECT shop, SUM(qty) FROM inventory GROUP BY shop;
How many games? How many total copies? How many different games?
```
# Practice 4
# "What is the average number of seats for each type of aircraft in the table?" Then use the results to enter the average number of seats for the blimps/dirigibles in the table.
SELECT type, AVG(seats) FROM planes GROUP BY type;

```
GROUPTING Expression
GROUP BY list_price < 10; 
GROUP BY if(list_price < 10, 'low price', 'high price')
GROUP BY CASE
	WHEN list_price < 10 THEN 'low price'
	ELSE 'high price'
END

Ways to specify a GROUP BY clause
	- Column reference
	- Grouping expression
	- Column alias (with some SQL engines)
	Sepcify the grouping expression in the SELECT list, and directly use column alias in the GROUP BY clause;
	SELECT list_price < 10 AS low_price, COUNT(*) FROM games GROUP BY low_price;
	- Two or more of the above (GROUP BY list)
	One group for each combination 
	SELECT min_age, max_players, COUNT(*) FROM games GROUP BY min_age, max_players;

Grouping without Aggregation 
	-When using GROUP BY, the SELECT list can have only:
		Aggregate expressions
		Expressions used in GROUP BY
		Literal values
	- Use SELECT DISTINCT instead of GROUP BY with no aggregation

```
SELECT min_age FROM games GROUP BY min_age; # three rows 
SELECT DISTINCT min_age FROM games; # better 

SELECT min_age, MAX(list_price) FROM games GROUP BY min_age;

SELECT min_age, round(AVG(list_price), 2) AS avg_list_price, 0.21 AS tax_rate, round(AVG(list_price)*1.21, 2) AS avg_w_tax FROM games GROUP BY min_age;

```
NULL values in Grouping and Aggregation
Any value compares to NULL yields to NULL
Aggregate functions ignore NULL values!
When no non-NULL values in the column, would return NULL.
```
SELECT AVG(price) FROM inventory; # average computes the average of all non-NULL values

# Practice 6
# Write and run a query using Impala to find the average air speed (distance divided by air_time) of all flights in the fly.flights table, in miles per hour. 
SELECT AVG(distance/(nullif(air_time,0)/60)) FROM fly.flights;

SELECT aisle, COUNT(*) FROM inventory GROUP BY aisle; # NULL group would be created 


```
COUNT function 

SELECT shop, COUNT(*) FROM inventory GROUP BY shop; # Count the NULL values 

Alternatively 
SELECT COUNT(price) FROM inventory; # Return the number of NON-NULL values in the column
SELECT shop, COUNT(price) FROM inventory GROUP BY shop; 

COUNT the DISTINCE
SELECT COUNT(DISTINCT aisle) FROM inventory;
SELECT COUNT(DISTINCT ...) FROM ...;
Alternatively
SELECT DISTINCT ... FROM ...;

DISTINCT keyword 
	- Inside the COUNT function, return the number of unique values
	- RIght after the SELECT keyword, with no aggregation, return unique rows

ALL keyword (does nothing)
```
SELECT shop, COUNT(*) FROM inventory GROUP BY shop; # Count the Null value
SELECT shop, COUNT(price) FROM inventory GROUP BY shop; # Ignore the Null value

SELECT COUNT(DISTINCE aisle) FROM inventory; # COUNT(DISTINCE)

# Practice 7
# Use Impala in the VM to find how many unique non-NULL combinations of year, month, and day exist in the fly.flights table.
SELECT COUNT(DISTINCT year, month, day) FROM fly.flights;
SELECT COUNT(*) FROM fly.flights GROUP BY year, month, day;

# Practice 8
# The following 3 statments are the same;
SELECT COUNT(tz) AS time_zones FROM fly.airports;
SELECT COUNT(*) AS time_zones FROM fly.airports WHERE tz IS NOT NULL;
SELECT COUNT(ALL tz) AS time_zones FROM fly.airports;

```
Tips for Grouping and Aggregation
Pushing down the calculation to database, make all calculation in the database
Data transfer, storage 

Grouping columns are usually categorical columns 
	- Integer columns like year, month
	- Character columns 
Use COUNT(DISTINCT) before pushdown

```

```
Filtering on Aggregates
Cannot use aggregates in WHERE clause
WHERE is treated before GROUP BY
WHERE deals with individual rows

HAVING clause
Filter the data with aggregation 
Works on the aggregated columns
NULL will not be included in the HAVING results set

Generally, when using HAVING clause, the things in the HAVING clause would be the same as SELECT list.
But it is not required.

In some SQL engines, column alias can be used in HAVING clause
```
SELECT shop, SUM(price * qty) FROM inventory GROUP BY shop;
SELECT shop, SUM(price * qty) FROM inventory GROUP BY shop WHERE SUM(price*qty) > 300; # Wrong
SELECT shop, SUM(price * qty) FROM inventory GROUP BY shop HAVING SUM(price * qty) > 300; # Correct!

# WHich shops have at least two different games in stock that cost less than $20;
# Find the shops and games having cost less than $20
# Find the number of games greater than 2
SELECT shop, COUNT(*) FROM inventory WHERE price < 20 GROUP BY shop HAVING COUNT(*) >= 2;

# Practice 9
# The fly.planes table contains data about planes, including the columns ​manufacturer (who built the plane) and seats (how many seats the plane has). 
# The average number of seats in all planes built by a manufacturer, but only for manufacturers who have at least one plane with more than 100 seats?
SELECT manufacturer, AVG(seats), COUNT(*) FROM fly.planes GROUP BY manufacturer HAVING MAX(seats) >= 100;

# Practice 10
# A “long-haul” flight is sometimes defined as a flight with air time of 7 hours or longer. Choose the SELECT statement that returns a result set describing how many long-haul flights each carrier has, along with the average air time of each carrier’s long-haul flights—but only for the carriers that have over 5000 long-haul flights represented in the flights table.
SELECT carrier, AVG(air_time) FROM fly.flights WHERE air_time >= 7*60 GROUP BY carrier HAVING COUNT(*) > 5000;


# The flights dataset includes the departure delay (in minutes) and the scheduled time of departure (as an integer, for example 3:14 in the afternoon is 1514). Write and run a query to find the average delay of only those flights that were scheduled to depart after 1:00 in the afternoon. 
SELECT AVG(dep_delay) FROM flights WHERE sched_dep_time > 1300;
# n the fly.flights table, the air time of each flight is given in minutes by the air_time column. Write and run a query to find the average air_time of the flights, in hours, to the nearest tenth of an hour
SELECT round(AVG(air_time), 1) FROM fly.flights;
# Write and run a query on the fly.planes table that would answer the question, "How many different manufacturers are there for each type of aircraft?"
SELECT type, COUNT(DISTINCT manufacturer) FROM planes GROUP BY type;
# Write and run a query in the VM to find all the airports with average departure delays of more than 30 minutes.
SELECT origin, AVG(dep_delay) FROM flights GROUP BY origin HAVING AVG(dep_delay) > 30;











