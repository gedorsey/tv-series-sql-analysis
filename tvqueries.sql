-- Query 1: Top 10 highest-rated TV shows
SELECT Title, Rating, Votes, Genres
FROM imdb_tvshows
ORDER BY Rating DESC
LIMIT 10;

-- Query 2: Average rating by genre
SELECT Genres, ROUND(AVG(Rating), 2) AS avg_rating, COUNT(*) AS num_shows
FROM imdb_tvshows
GROUP BY Genres
ORDER BY avg_rating DESC
LIMIT 15; 

-- Query 3: Most voted TV shows (most popular by audience engagement)
SELECT Title, Votes, Rating, Genres
FROM imdb_tvshows
ORDER BY Votes DESC
LIMIT 10;

-- Note: Highly rated shows don't always have the most votes. Example: The Chosen was rated 9.7 in Query 1 but isn't listed in Query 3

-- Query 4: How many shows exist per genre
SELECT Genres, COUNT(*) AS num_shows
FROM imdb_tvshows
GROUP BY Genres
ORDER BY num_shows DESC
LIMIT 15; 

-- Query 5: Highest rated shows with significant viewership (over 100,000 votes)
SELECT Title, Rating, Votes, Genres
FROM imdb_tvshows
WHERE Votes > 100000
ORDER BY Rating DESC
LIMIT 10; 

-- Note: The Chosen and Bluey had the highest raw ratings, but when you filter for shows with real audience scale, Breaking Bad and Game of Thrones rise to the top.

-- Adding Run Time column for further Analysis

ALTER TABLE imdb_tvshows ADD COLUMN runtime_years INTEGER; 
 
UPDATE imdb_tvshows
SET runtime_years = 
    CASE 
        WHEN LENGTH(Years) > 5 THEN CAST(SUBSTR(Years, 6, 4) AS INTEGER) - CAST(SUBSTR(Years, 1, 4) AS INTEGER)
        ELSE 2026 - CAST(SUBSTR(Years, 1, 4) AS INTEGER)
    END;

SELECT Title, Years, runtime_years
FROM imdb_tvshows
LIMIT 15; 

-- Query 6: Longest running TV shows
SELECT Title, Years, runtime_years, Rating
FROM imdb_tvshows
ORDER BY runtime_years DESC
LIMIT 15;

-- Note: Longest running shows don't necessarily have the highest rating or most votes 

-- Query 7: Does a longer runtime mean a better rating?
SELECT 
    CASE
        WHEN runtime_years <= 2 THEN '1-2 years'
        WHEN runtime_years <= 5 THEN '3-5 years'
        WHEN runtime_years <= 10 THEN '6-10 years'
        ELSE '10+ years'
    END AS runtime_bucket,
    ROUND(AVG(Rating), 2) AS avg_rating,
    COUNT(*) AS num_shows
FROM imdb_tvshows
GROUP BY runtime_bucket
ORDER BY avg_rating DESC; 

-- Note: Shows running 3-5 years have the highest avg rating (7.44). 
-- Shows running 10+ years have the lowest (7.20), suggesting quality decline over time. 

-- Query 8: Top 10 most common genres among highly rated shows (rating above 8.0)
SELECT Genres, COUNT(*) AS num_shows, ROUND(AVG(Rating), 2) AS avg_rating
FROM imdb_tvshows
WHERE Rating > 8.0
GROUP BY Genres
ORDER BY num_shows DESC
LIMIT 10; 

-- Note: Comedy outperforms by a large margin with 59 highly rated shows

-- Query 9: Hidden gems (high rating but low votes - underrated shows)
SELECT Title, Rating, Votes, Genres
FROM imdb_tvshows
WHERE Rating > 8.5
AND Votes < 10000
ORDER BY Rating DESC
LIMIT 15;



