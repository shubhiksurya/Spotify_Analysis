CREATE DATABASE spotify_db;
USE spotify_db;
CREATE TABLE spotify_DA (
    id INT AUTO_INCREMENT PRIMARY KEY,
    artist varchar(50),
	songname varchar(50),
	duration_ms int,
	explicit varchar(10),
	release_year year,
	popularity int,
	danceability float,
	energy float,
    loudness float,
	speechiness float,	
    acousticness	float, 
    instrumentalness float,
	liveness float,
	valence float,
	tempo float,
	genre varchar(50)

);
drop table spotify_da;
select * from spotify_da;

-- Total songs and artists
SELECT COUNT(*) AS total_songs, COUNT(DISTINCT artist) AS unique_artists FROM spotify_da;

-- Songs per year
SELECT release_year, COUNT(*) AS num_songs
FROM spotify_da
GROUP BY release_year
ORDER BY release_year;

-- Top 10 most popular songs
SELECT songname, artist, popularity
FROM spotify_da
ORDER BY popularity DESC
LIMIT 10;

-- Average popularity by genre
SELECT genre, ROUND(AVG(popularity),3) AS avg_popularity
FROM spotify_da
GROUP BY genre
ORDER BY avg_popularity DESC;

-- Longest songs
SELECT songname, artist, duration_ms
FROM spotify_da
ORDER BY duration_ms DESC
LIMIT 20;

-- Fastest songs
SELECT songname, artist, tempo
FROM spotify_da
ORDER BY tempo DESC
LIMIT 20;

-- Count of explicit
SELECT explicit, COUNT(*) AS count_explicit
FROM spotify_da
GROUP BY explicit;

-- Popularity comparison
SELECT explicit, ROUND(AVG(popularity),2) AS avg_popularity
FROM spotify_da
GROUP BY explicit;

-- Most danceable songs
SELECT songname, artist, danceability
FROM spotify_da
ORDER BY danceability DESC
LIMIT 20;

-- Average valence and energy per genre
SELECT genre, ROUND(AVG(valence),2) AS avg_valence, ROUND(AVG(energy),2) AS avg_energy
FROM spotify_da
GROUP BY genre
ORDER BY avg_valence DESC;

-- Top Artists and Their Hit Tracks 
-- Goal: Identify artists who dominate Spotify with hit songs, along with their average popularity, number of songs, and top track. Perfect for a bar chart or ranked table.
SELECT artist,
       COUNT(*) AS total_songs,
       ROUND(AVG(popularity),2) AS avg_popularity,
       MAX(popularity) AS top_song_popularity,
       SUBSTRING_INDEX(GROUP_CONCAT(songname ORDER BY popularity DESC), ',', 1) AS top_song
FROM spotify_da
GROUP BY artist
HAVING total_songs > 2   -- only artists with multiple songs
ORDER BY avg_popularity DESC
LIMIT 20;


-- Popularity vs Audio Features 
-- Goal: Compare how audio features affect popularity — danceability, energy, valence, instrumentalness. Ideal for scatter plots or radar charts.

SELECT songname,
       artist,
       popularity,
       ROUND(danceability,2) AS danceability,
       ROUND(energy,2) AS energy,
       ROUND(valence,2) AS valence,
       ROUND(instrumentalness,2) AS instrumentalness
FROM spotify_da
ORDER BY popularity DESC
LIMIT 50;

-- Temporal Trends: Hits Over Years 
-- Goal: How popularity and audio traits change over time. Shows Spotify trends, evolution of music style. Perfect for line charts or time series.
SELECT release_year,
       COUNT(*) AS total_songs,
       ROUND(AVG(popularity),2) AS avg_popularity,
       ROUND(AVG(danceability),2) AS avg_danceability,
       ROUND(AVG(energy),2) AS avg_energy,
       ROUND(AVG(valence),2) AS avg_valence,
       ROUND(AVG(instrumentalness),2) AS avg_instrumentalness,
       ROUND(AVG(duration_ms)/60000,2) AS avg_duration_minutes
FROM spotify_da
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year;

-- Features & Genres Driving Popularity
-- Goal: For a music distribution company like ASUP, see which audio features + genres are associated with high popularity.
SELECT genre,
       ROUND(AVG(popularity),2) AS avg_popularity,
       ROUND(AVG(danceability),2) AS avg_danceability,
       ROUND(AVG(energy),2) AS avg_energy,
       ROUND(AVG(valence),2) AS avg_valence,
       ROUND(AVG(instrumentalness),2) AS avg_instrumentalness,
       COUNT(*) AS total_songs
FROM spotify_da
GROUP BY genre
HAVING total_songs > 10  -- ignore genres with too few songs
ORDER BY avg_popularity DESC;
