create database imdbmovies;
-------------------------------- ASSINMENT 1:-
-- Segment 1: Database - Tables, Columns, Relationships

-- (1) -	What are the different tables in the database and how are they connected to each other in the database?
  Ans : there are 6 differet tables with entity relationship diagram in the database which are interlinked with eachother
  and they where named as movie, names, role mapping, director mapping genre and ratings.


-- (2)Find the total number of rows in each table of the schema.

select count(*) from movies; 
select count(*) from genre; 
select count(*) from director_mapping; 
select count(*) from ratings; 
select count(*) from role_mapping; 
select count(*) from names;

-- (3)Identify which columns in the movie table have null values.

select * from movies;
update movies set country=null where country='';
update movies set id=null where id='';
update movies set title=null where title='';
update movies set year=null where year='';
update movies set date_published=null where date_published='';
update movies set duration=null where country='';
update movies set worlwide_gross_income=null where worlwide_gross_income='';
update movies set languages=null where languages='';
update movies set production_company=null where production_company='';


 select count(*) from movies where country is null;

select
sum(case when id is null then 1 else 0 end) as id_nulls,
sum(case when title is null then 1 else 0 end) as title_nulls,
sum(case when year is null then 1 else 0 end) as year_nulls,
sum(case when date_published is null then 1 else 0 end) as date_published_nulls,
sum(case when duration is null then 1 else 0 end) as duration_nulls,
sum(case when country is null then 1 else 0 end) as country_nulls,
sum(case when worlwide_gross_income is null then 1 else 0 end) asworlwide_gross_income_nulls,
sum(case when languages is null then 1 else 0 end) as languages_nulls,
sum(case when production_company is null then 1 else 0 end) as production_company_nulls
 from movies;
 
 
 
 
 ----------------------------- ASSINMENT 2:-
  -- Segment 2: Movie Release Trends

-- (4)Determine the total number of movies released each year and analyse the month-wise trend.
​
select year , 
       substr(date_published , 4,2) as month , count(id) as movies_released from 
movies 
group by year  ,
         substr(date_published , 4,2) order by year , substr(date_published , 4,2)
         
         
-- (5)Calculate the number of movies produced in the USA or India in the year 2019.

select 
        count(id) as movies_released from 
movies 
where (country = 'India' or country = 'USA') and year = 2019




-------------------- ASSINMENT 3:-
-- Segment 3: Production Statistics and Genre Analysis

-- (6) -	Retrieve the unique list of genres present in the dataset.

select distinct genre from movies
         left join genre on (movies.id = genre.movie_id) 
         
-- (7)   -	Identify the genre with the highest number of movies produced overall.

select genre , count(movie_id) as movies from movies
         left join genre on (movies.id = genre.movie_id) 
group by genre order by 2 desc


-- (8)    -	Determine the count of movies that belong to only one genre.

WITH cte AS (
    SELECT id, COUNT(DISTINCT genre) AS genres
    FROM movies
    LEFT JOIN genre ON (movies.id = genre.movie_id)
    GROUP BY id
    HAVING COUNT(DISTINCT genre) = 1
)
select count(id) as movies from cte
 
 
 -- (9) -	Calculate the average duration of movies in each genre.
 
 SELECT g.genre, AVG(m.duration) AS avg_duration
FROM genre g
JOIN movies m ON g.movie_id = m.id
GROUP BY g.genre;
		 

-- (10)  -	Find the rank of the 'thriller' genre among all genres in terms of the numberof movies produced.

with cte as (
select genre , count(movie_id) as movies from movies
         left join genre on (movies.id = genre.movie_id) 
group by genre order by 2 desc
		 )
		 
		 select * , rank() over (order by movies desc) as genre_rank from cte
         
         
         
-------------------------- ASSINMENT 4:-
-- Segment 4: Ratings Analysis and Crew Members

-- (11) -Retrieve the minimum and maximum values in each column of the ratings table (except movie_id).
select * from ratings;

SELECT MAX(avg_rating) AS max_avg_rating,
       MIN(avg_rating) AS min_avg_rating
FROM ratings;
 
SELECT MAX(total_votes) AS max_total_votes,
       MIN(total_votes) AS min_total_votes
FROM ratings;

select max(median_rating) as max_median_rating,
       min(median_rating) as min_median_rating
from ratings;
 
 
 -- (12) Identify the top 10 movies based on average rating.

select movie_id from ratings order by avg_rating desc limit 10


-- (13) -Summarise the ratings table based on movie counts by median ratings.

 select * from ratings
 
SELECT median_rating, COUNT(*) AS movie_counts
FROM ratings
GROUP BY median_rating;


-- (14) -	Identify the production house that has produced the most number of hit movies (average rating > 8).

SELECT production_company, COUNT(movies.id) AS movies
FROM movies
LEFT JOIN ratings ON (movies.id = ratings.movie_id)
WHERE avg_rating > 8
GROUP BY production_company
ORDER BY movies DESC;

-- (15) -Determine the number of movies released in each genre 
-- during March 2017 in the USA with more than 1,000 votes.

SELECT genre, COUNT(id) AS movies_released
FROM movies
LEFT JOIN genre ON (movies.id = genre.movie_id)
LEFT JOIN ratings ON (movies.id = ratings.movie_id)
WHERE total_votes > 1000 
GROUP BY genre;


-- (16) -	Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.


SELECT g.genre, m.title, r.avg_rating
FROM movies m
LEFT JOIN genre g ON m.id = g.movie_id
LEFT JOIN ratings r ON m.id = r.movie_id
WHERE m.title LIKE 'The%'
  AND r.avg_rating > 8;
  
  
  
  -------------------------- ASSINMENT 5:-
 --  Segment 5: Crew Analysis
​
-- (17) -	Identify the columns in the names table that have null values.

select * from names; 

update names set id=null where id='';
update names set name=null where name='';
update names set height=null where height='';
update names set date_of_birth=null where date_of_birth='';
update names set known_for_movies=null where known_for_movies='';

select
sum(case when id is null then 1 else 0 end) as id_nulls,
sum(case when name is null then 1 else 0 end) as name_nulls,
sum(case when height is null then 1 else 0 end) as height_nulls,
sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;


-- (18) -Determine the top three directors in the top three genres with movies having an average rating > 8.

SELECT genre, COUNT(id) AS movies
FROM movies 
LEFT JOIN genre ON (movies.id = genre.movie_id)
GROUP BY genre
order by movies desc limit 3;

WITH cte AS (
    SELECT
        genre,
        name_id AS director_id,
        COUNT(id) AS movies
    FROM movies 
    LEFT JOIN genre ON (movies.id = genre.movie_id)
    LEFT JOIN director_mapping ON (movies.id = director_mapping.movie_id)
    GROUP BY name_id, genre
    ORDER BY genre, movies DESC)
    ,
cte2 as
(SELECT * , 
       ROW_NUMBER() OVER (partition by genre ORDER BY movies DESC)ranking
FROM cte 
WHERE director_id IS NOT NULL
),


cte3 as
(SELECT genre, COUNT(id) AS movies
FROM movies 
LEFT JOIN genre ON (movies.id = genre.movie_id)
GROUP BY genre
order by movies desc limit 3)
SELECT director_id, name , genre  from cte2
left join names on (cte2.director_id = names.id)
WHERE ranking <= 3
and genre in (select genre from cte3)


-- (19)- Find the top two actors whose movies have a median rating >= 8.

select * from movies m left join role_mapping r 
on (m.id = r.movie_id)
where category = 'actor'

SELECT
    rm.name_id AS actor_id,
    nm.name AS actor_name,
    COUNT(DISTINCT m.id) AS movie_count,
    ROUND(
        IF(COUNT(DISTINCT r.movie_id) % 2 = 0,
            (MAX(r.median_rating) + MIN(r.median_rating)) / 2,
            MAX(r.median_rating)
        ), 2
    ) AS median_rating
FROM
    role_mapping rm
    JOIN movies m ON rm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    JOIN names nm ON rm.name_id = nm.id
WHERE
    rm.category = 'actor' AND
    r.median_rating >= 8
GROUP BY
    actor_id, actor_name
ORDER BY
    median_rating DESC
LIMIT 2;


-- (20) --Identify the top three production houses based on the number of votes received by their movies.

SELECT
    m.production_company,
    SUM(r.total_votes) AS total_votes_received
FROM
    movies m
    LEFT JOIN ratings r ON m.id = r.movie_id
GROUP BY
    m.production_company
HAVING
    total_votes_received IS NOT NULL
ORDER BY
    total_votes_received DESC
LIMIT 3;


-- (21)  -Rank actors based on their average ratings in Indian movies released in India.

SELECT
    rm.name_id AS actor_id,
    nm.name AS actor_name,
    AVG(r.avg_rating) AS average_rating,
    RANK() OVER (ORDER BY AVG(r.avg_rating) DESC) AS actor_rank
FROM
    movies m
    LEFT JOIN ratings r ON m.id = r.movie_id
    LEFT JOIN role_mapping rm ON m.id = rm.movie_id
    LEFT JOIN names nm ON rm.name_id = nm.id
WHERE
    m.country = 'India' AND
    rm.category = 'actor'
GROUP BY
    actor_id, actor_name
ORDER BY
    average_rating DESC;
    
    
-- (22) -Identify the top five actresses in Hindi movies released in India based on their average ratings.


SELECT
    rm.name_id AS actress_id,
    nm.name AS actress_name,
    AVG(r.avg_rating) AS average_rating
FROM
    movies m
    LEFT JOIN ratings r ON m.id = r.movie_id
    LEFT JOIN role_mapping rm ON m.id = rm.movie_id
    LEFT JOIN names nm ON rm.name_id = nm.id
WHERE
    m.country = 'India' AND
    m.languages LIKE '%Hindi%' AND
    rm.category = 'actress'
GROUP BY
    actress_id, actress_name
ORDER BY
    average_rating DESC
LIMIT 5;


-------------------- ASSINMENT 6:-
-- Segment 6: Broader Understanding of Data

-- (23)- Classify thriller movies based on average ratings into different categories.

select id , avg_rating ,
case when avg_rating > 5  then 'Hit Movie'
     when avg_rating < 5 then 'Flop Movie'
else 'Avg Movie' end as Movie_category
from movies m left join genre g on (m.id = g.movie_id)
left join ratings r on (m.id = r.movie_id)
where genre = 'Thriller'


-- (24) -analyse the genre-wise running total and moving average of the average movie duration.

select id , genre , duration ,
sum(duration) over(partition by genre order by id asc) cum_sum,
avg(duration) over(partition by genre order by id asc) moving_average
from movies
left join genre on (movies.id = genre.movie_id) order by genre , id


-- (25) -Identify the five highest-grossing movies of each year that belong to the top three genres.

WITH cte AS (
    SELECT
        year, title, worlwide_gross_income, genre
    FROM
        movies
        INNER JOIN genre ON movies.id = genre.movie_id
)
SELECT
    year,
    genre,
    worlwide_gross_income
FROM
    cte
ORDER BY
    year, worlwide_gross_income DESC
LIMIT 5;


-- (26)-Determine the top two production houses that have produced the highest number of hits among multilingual movies.

WITH cte AS (
    SELECT
        m.id, m.production_company, m.languages, r.avg_rating
    FROM
        movies m
        INNER JOIN ratings r ON m.id = r.movie_id
)
SELECT
    production_company
FROM
    cte
WHERE
    languages LIKE '%,%'
ORDER BY
    production_company DESC
LIMIT 2;

-- (27) -	Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.

WITH cte AS (
    SELECT
        nm.name, r.avg_rating
    FROM
        names nm
        INNER JOIN ratings r ON nm.id = r.movie_id
)
SELECT
    name
FROM
    cte
WHERE
    avg_rating > 8;

-- (28) -	Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.

SELECT
    director_mapping.name_id AS director_id,
    COUNT(movies.id) AS Num_of_movies,
    AVG(movies.duration) AS avg_movie_duration,
    AVG(ratings.avg_rating) AS avg_rating
FROM
    movies
    LEFT JOIN genre ON (movies.id = genre.movie_id)
    LEFT JOIN ratings ON (movies.id = ratings.movie_id)
    LEFT JOIN director_mapping ON (movies.id = director_mapping.movie_id)
WHERE
    director_mapping.name_id IS NOT NULL
GROUP BY
    director_mapping.name_id
ORDER BY
    Num_of_movies DESC;

SELECT * FROM names;

SELECT * FROM director_mapping;


-------------------- ASSINMENT 7:-
-- Segment 7: Recommendations

-- (29) -	Based on the analysis, provide recommendations for the types of content Bolly movies should focus on producing.

Based on the analysis, Bolly movies should consider prioritizing content in the '1001 - 5000' total_votes
range as it tends to receive higher median ratings. Genres like drama,  romance, and
comedy have shown consistent popularity across various count ranges and should be emphasized.
Maintaining a median rating between 7 and 8 is crucial, highlighting the importance of compelling 
storytelling and production quality to engage viewers effectively.