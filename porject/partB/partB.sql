--Number of movies per year

SELECT extract(year FROM release_date) AS year, COUNT(*) AS movies_per_year 
FROM movies_metadata 
GROUP BY year 
ORDER BY year;

--Number of movies per genre 

SELECT SUBSTRING(T.genre,9), COUNT(T.movieID) AS number_Of_Movies 
FROM (SELECT regexp_split_to_table(genres, ',') 
	AS genre, id AS movieID  FROM movies_metadata) AS T WHERE T.genre NOT LIKE '%id%'  
	GROUP BY substring(T.genre,9);

--Number of movies per year and genre 



--Average rating per genre


SELECT genres AS GENRE, AVG(rating) AS AVERAGE_RATING 
FROM Movies_Metadata INNER JOIN Ratings ON Movies_Metadata.id = Ratings.movieid 
GROUP BY GENRE 
ORDER BY GENRE;


--Number of ratings per user

SELECT userid AS USER, COUNT(rating) AS TOTAL_RATINGS 
FROM Ratings 
GROUP BY userid 
ORDER BY TOTAL_RATINGS DESC;


--Average rating per user

SELECT userid AS USER, AVG(rating) AS AVERAGE_RATING 
FROM Ratings 
GROUP BY userid 
ORDER BY AVERAGE_RATING DESC;


--View table 



CREATE VIEW view_table AS
SELECT userid AS USER, count(rating) 
AS NUMBER_OF_RATINGS, AVG(rating) 
AS AVERAGE_RATING FROM ratings 
GROUP BY userid ORDER BY NUMBER_OF_RATINGS DESC;