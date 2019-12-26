SELECT origin, dest, COUNT(*)/COUNT(DISTINCT year) AS avg_annual_flights, AVG(distance), AVG(arr_delay) 
	FROM flights 
	WHERE distance > 300 AND distance < 400 
	GROUP BY origin, dest 
	ORDER BY avg_annual_flights DESC  
	LIMIT 5;

SELECT f.origin AS origin, f.dest AS dest, SUM( p.seats)/COUNT(DISTINCT f.year) AS seats 
	FROM flights AS f JOIN planes AS p ON f.tailnum = p.tailnum 
	GROUP BY origin, dest 
	ORDER BY seats DESC 
	LIMIT 5;

SELECT f.origin AS origin, f.dest AS dest, SUM(p.seats)/COUNT(DISTINCT f.year) AS seats 
	FROM flights AS f JOIN planes AS p ON f.tailnum = p.tailnum 
	WHERE f.origin = 'SFO' AND f.dest = 'LAX' 
	GROUP BY origin, dest;

SELECT f.origin AS origin, f.dest AS dest, SUM(p.seats)/COUNT(DISTINCT f.year) AS seats 
	FROM flights AS f JOIN planes AS p ON f.tailnum = p.tailnum 
	WHERE f.origin = 'LAX' AND f.dest = 'SFO' 
	GROUP BY origin, dest;
