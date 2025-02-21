SELECT * FROM spotify

----EDA

SELECT Min(duration_min)
FROM spotify

SELECT * FROM
spotify
WHERE duration_min = 0

DELETE FROM spotify 
WHERE duration_min = 0

------------------
--DATA ANALYSIS EASY CATEGORY---

SELECT * FROM spotify
WHERE stream >= 1000000000

--------------------------

SELECT DISTINCT album, artist FROM spotify


--------------------------------
SELECT
	album,
	ROUND(AVG(danceability::NUMERIC),2) AS dance
FROM
	spotify
GROUP BY
	album

-------------------------------------

SELECT 
	DISTINCT album,
	track,
	SUM(views) Total_views
FROM
	spotify
GROUP BY 
	album, track
ORDER BY 
	Total_views DESC

--------------------------------------
SELECT 
	* 
FROM
(
	SELECT 
		track,
		COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as most_streamed_on_youtube,
		COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as most_streamed_on_spotify 
		
	from 
		spotify
	
	GROUP BY track
) AS T1
WHERE most_streamed_on_spotify > most_streamed_on_youtube AND most_streamed_on_youtube <> 0 
ORDER BY 3 DESC
LIMIT 10;



------------------------------------------

SELECT * 
FROM 
(
SELECT 
	artist,
	track,
	views,
	RANK() OVER(PARTITION BY artist ORDER BY views DESC) as rank_
FROM 
	spotify
GROUP BY
	1,2,3
ORDER BY artist ) as T

WHERE rank_ <=3

-----------------------------------------------

WITH avg_s
AS
(
SELECT 
	track,
	liveness,
	(SELECT AVG(liveness) from spotify) AS avg_
FROM
	spotify
)
SELECT
	*
FROM
	avg_s
WHERE
	liveness> avg_

---------
SELECT * FROM spotify;

WITH e_diff
AS
(
SELECT 
	album,
	MAX(energy) as MAX_,
	MIN(energy) as MIN_
FROM
	spotify
GROUP BY
	1
ORDER BY
	1 
)

SELECT 
	album,
	ROUND((max_ - min_)::numeric,5) as energy_diff
FROM
	e_diff
ORDER BY
	2 DESC


	
-- QUERY optimization

                 

EXPLAIN ANALYZE  -- et 57.06ms pt 0.127ms     after_index et 56.490 pt 0.963
SELECT * 
FROM 
(
SELECT 
	artist,
	track,
	views,
	RANK() OVER(PARTITION BY artist ORDER BY views DESC) as rank_
FROM 
	spotify
GROUP BY
	1,2,3
ORDER BY artist ) as T

WHERE rank_ <=3

CREATE INDEX artist_index ON spotify(artist)

