# WHERE clause
```
SELECT ... FROM tablename WHERE...;
WHERE clause only influence which rows are returned. (rwo filters)
CANNOT have multiple filters separated by comma in the WHERE list.
WHERE clause is optional. 
Use WHERE clause to answer questions.
```

# Using expressions in the WHERE clause
```
Expressions are composed of:
Literal values, column references, operators and functions 

Expressions in SELECT list:
1. Becomes column in result
2. Multiple expressions
3. Different data types are allowed

Expressions in WHERE list:
1. Filters rows in result
2. Only one expression
3. Expression must be Boolean
```
# which games are priced below $10?
SELECT name FROM fun.games WHERE list_price < 10; # results contains only one column 'name'
SELECT name, list_price FROM fun.games WHERE list_price < 10;

# which game's inventor is Elizabeth Magie
SELECT name, inventor FROM fun.games WHERE inventor = 'Elizabeth Magie';

# which games are suitable for 7 year-old
SELECT name, min_age FROM fun.games WHERE min_age <= 7;

# Practice 1
# Write and run a query on the wax.crayons table to find all the crayon colors with a value 
# for the column red that is less than 110. How many rows are returned?
impala-shell -d wax
SELECT color FROM crayons WHERE red < 110;

```
Comparison operators (Binary operators)
= : tests for equality (there is no variable assignment in SQL)
!= : tests for inequality 
<> : tests for inequality
< and > : numerical comparison 
<= and >= : numerical comparison

The values on two sides of operators can be column references, literal values and expressions (arithmetic function and built-in function).
```
# Query on the wax.crayons table to find all colors that green value larger than red
SELECT color FROM wax.crayons WHERE green > red;

# Query on the wax.crayons table to find all colors that blue value less than 50
SELECT color FROM wax.crayons WHERE blue < 50;

# Practice 2
# Which of the crayon colors have exactly the same red and green values?
SELECT color FROM wax.crayons WHERE red = green;

# Practice 3
# How many of the crayon colors have more blue than red in the R-G-B color model?
SELECT color FROM wax.crayons WHERE blue > red;

# Query on the wax.crayons table to find all colors that the sum of green, red and blue is greater than 650
SELECT color FROM wax.crayons WHERE green + red + blue > 650;

# The following statement does not work! 
# SQL engines process the WHERE clause before they compute the values in the SELECT list.
SELECT color, green + red + blue AS rgb_sum FROM wax.crayons WHERE rgb_sum > 650;
# The following statement works!
SELECT color, green + red + blue AS rgb_sum FROM wax.crayons WHERE green + red + blue > 650;

# The following statement also works, and the result contains two columns! 
# However, the result doesn't filter the rows, but return a boolean values as a column light.
SELECT color, green + red + blue > 650 AS light FROM wax.crayons;

# Practice 4
# Which of the following crayon colors are dark, that is, the sum of red, green, and blue values will be less than 325? 
# (Not all colors meeting the criteria are listed.) Check all that apply.
# Note: Although it's not needed to answer the question, try writing a query whose results include a column named dark, 
#which is true when the sum is less than 325. The result set for this query should only show rows where dark is true.
SELECT color FROM wax.crayons WHERE red+green+blue < 325;
SELECT color, red + green + blue < 325 AS dark WHERE red + green + blue < 325;

```
Data Type and Precision
It is fine to have 1 = 1.0
When two sides have different data types, different engines treat it differently.
SELECT '1' = 1
Impala fails: SELECT CAST('1' AS INT) = 1 
Hive runs sucessfully

Comparing floating numbers
i.e. 1/3 = 0.333333333...
Impala: 1/3 = 0.3333 is false, but 1/3 = 0.33333333333333333333333 is true
Solution 1: use rounding. i.e. round(1.0/3, 4) = 0.3333 is true
```

```
Logical Operators
AND (Binary)
OR (Binary)
NOT (Unary)

Order of Operators
NOT > AND > OR
NOT only applies to the equality immediately after it.
Alternatively, you can use parentheses.
```
# Query on the fun.game table to find the games for more than 6 person and the price islower than 10
SELECT * FROM fun.games WHERE max_players >= 6 AND list_price <= 10;

# Query on the fun.game table to find all the game except Risk
SELECT * FROM fun.games WHERE NOT name = 'Risk'

# Query on the fun.game table to find all games except Candy Land and Risk
# The following two statements are wrong!
SELECT * FROM fun.games WHERE NOT name = 'Candy Land' AND name = 'Risk'
SELECT * FROM fun.games WHERE NOT name = 'Candy Land' OR name = 'Risk'

# The following two statements are correct!
SELECT * FROM fun.games WHERE NOT name = 'Candy Land' AND NOT name = 'Risk';
SELECT * FROM fun.games WHERE name != 'Candy Land' AND name != 'Risk';
SELECT * FROM fun.games WHERE NOT (name = 'Candy Land' OR name = 'Risk');


# Practice 5
# You want a list of students who have a GPA of at least 3.5, and who have either no more than 3 detentions or more than 5 absences. 
# Which queries will accomplish this? Check all that apply.
SELECT * FROM students WHERE gpa >= 3.5 AND (NOT detentions > 3 OR absences > 5)
SELECT * FROM students WHERE gpa >= 3.5 AND (detentions <= 3 OR absences > 5)

```
Other Relational Operators
IN: if the set on the left matches any of the value in the set on the right
BETWEEN: if the left side is between the lower and upper bound specified on the right

NOT IN: true when no matches exist
NOT BETWEEN: true when outside the range
```
SELECT * FROM fun.games WHERE name IN ('Monopoly', 'Clue', 'Risk')

# Practice 6
# Run a query on the VM using the IN operator to find the smallest pack of crayons 
# that includes all three of Plum, Salmon, and Vivid Tangerine. 
SELECT color, pack FROM wax.crayons WHERE color IN ('Plum','Salmon','Vivid Tangerine');


SELECT * FROM fun.games WHERE min_age BETWEEN 8 AND 10;
SELECT 1/3 BETWEEN 0.3332 AND 0.3334;

# Practice 7
# Run a query on the VM to find which of the following crayon colors has a red value 
# between 75 and 125 and a blue value between 125 and 175.
SELECT * FROM crayons WHERE red BETWEEN 75 AND 125 AND blue BETWEEN 125 AND 175;

```
Understanding Missing Value 
Missing and unknown values makes the filters fail.
NULL
NULL in filter: boolean could evaluate to null, the rows are omitted in the results, which is the same as false

Handle missing values
Standard logical operators cannot be used for detecting NULL. 
Any value compares to NULL always yields to NULL in the standard logical operations.
Operators:
IS NULL
IS NOT NULL
IS DISTINCT FROM: not equalily with NULL
IS NOT DISTINCT FROM

NULL != non-NULL value  -> NULL
NULL IS DISTINCT FROM non-NULL -> true

NULL != NULL -> NULL
NULL IS DISTINCT FROM NULL -> false
```

# Practice 8
# Write a query to return all rows for a flight in the flights table with the following information: 
# It departed on January 15, 2009, the carrier is capital letters US, the flight number is 1549, 
# and the origin airport is capital letters LGA. 
# Which column or columns in this row have NULL values? Check all that apply.
SELECT * FROM flights WHERE year = 2009 AND month = 1 AND day = 15 AND carrier = 'US' AND flight = 1549 AND origin = 'LGA';

SELECT * FROM fun.inventory WHERE price IS NULL.

# Practice 9
# Write and run a SELECT statement that queries the fly.flights table and returns all the rows representing 
# flights on January 15, 2009 that have non-missing departure time (dep_time) and missing arrival time (arr_time). 
SELECT * FROM flights WHERE year = 2009 AND month = 1 AND day = 15 AND dep_time IS NOT NULL AND arr_time IS NULL;

```
Conditional Functions 

if(condition, condition holds, condition fails)
CASE
nullif(x,y): 
ifnull(x,y): if x is null return y, else return x
coalesce(x,y)
```
SELECT shop, game, if(price IS NULL, 8.99, price) AS correct_price FROM fun.inventory;

SELECT shop, game, price,
CASE WHEN price IS NULL THEN 'missing price'
	 WHEN price > 10 THEN 'high price'
	 ELSE 'low price'
END	AS price_category FROM fun.inventory;

# What value does this CASE expression return when size = 40?
CASE WHEN size >= 34 THEN 'small'

       WHEN size >= 38 THEN 'medium'

       WHEN size >= 42 THEN 'large'

       WHEN size >= 46 THEN 'other'

       ELSE 'other'

​END

# Since size >= 34 evaluates as true, the statement returns 'small' and ends. Note that this is a bad CASE expression; the size >= 38, size >= 42, and size >= 46 cases are unreachable, because any value that is true for them would also be true for the first expression. 
# The CASE expression should be rewritten, for example, by reversing the order of the four WHEN clauses:
CASE WHEN size >= 46 THEN 'other'

          WHEN size >= 42 THEN 'large'

          WHEN size >= 38 THEN 'medium'

          WHEN size >= 34 THEN 'small'

          ELSE 'other'

END

# nullif application in the zero devision case
SELECT distance/nullif(air_time, 0) * 60 AS avg_speed FROM fly.flights;


```
Variable substitution in Beeline and impala-shell
Beeline
# Set a variable containing the name of the game
SET hivevar:game = Monopoly;
SELECT list_price FROM fun.games WHERE name = '${hivevar:game}';
SELECT shop, price FROM fun.inventory WHERE game = '${hivevar:game}';


# Set a list of color names 
SELECT hex FROM wax.crayons WHERE color = '${hivevar:color}';

beeline -u ... --hivevar color = "Red" -f hex_color.sql 
beeline -u ... --hivevar color = "Blue" -f hex_color.sql 
beeline -u ... --hivevar color = "green" -f hex_color.sql 

# impala-shell
SELECT hex FROM wax.crayons WHERE color = '${var:color}';
impala-shell --var color = "Purple Mountains\' Majesty" -f hex_color.sql 
```

```
Call Beeline and Impala Shell from Scripts

#!/bin/bash
impala-shell \
--quiet \
--delimited \
--output_delimiter=',' \
--print_header \
-q 'SELECT * FROM fly.flights WHERE air_time = 0;' \
-o zero_air_time.csv 
mail \
-a zero_air_time.csv \
-s 'Flights with zero air_time'\
fly@example.com\
```

























