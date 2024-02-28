
QUESTION 1)-- Find the total number of rows in each table of schema
ANSWER 1)

select COUNT(*) from movie
select COUNT(*) from genre
select COUNT(*) from names
select COUNT(*) from project
select COUNT(*) from rating
select COUNT(*) from role_mapping

quest 2)-- identify which column have null value in movies table
ANSWER 2)
part 1 by using simple count
 
 SELECT
    COUNT(country) AS country_null,
    (SELECT COUNT(languages) FROM movie WHERE languages='') AS language_null
FROM movie
WHERE  country='';




part 2 by using switch statement
select sum(case when country= '' then 1 else 0 end) as country_nulls,
 sum(case when languages= '' then 1 else 0 end) as language_null
from movie 

                            segment 2 MOVIE RELEASED TREND
	--Determine the total number of movies released each year and analyse the month wise trend
    --calculate the number of  movies produced  in the USA  OR INDIA in the year 2017

quest 1)--Determine the total number of movies released each year and analyse the month wise trend
ANSWER 1)
	select year,substr(date_published,4,2),count(title) as movie_released 
    from movie
    group by year ,substr(date_published,4,2)
    order by year 
quest 2) --calculate the number of  movies produced  in the USA  OR INDIA in the year 2019
  ANSWER 2) 
   select count(id) as movie_produced_in_2019 from movie
    where country ='USA' or country='INDIA' and year =2019
   
   -- assignment movie released in 2017 movie released in 2018 movie released in 2019
SELECT
 
    SUM(CASE WHEN (country = 'USA' OR country = 'INDIA') AND year = 2017 THEN 1 ELSE 0 END) AS movie_produced_in_2017,
    SUM(CASE WHEN (country = 'USA' OR country = 'INDIA') AND year = 2018 THEN 1 ELSE 0 END) AS movie_produced_in_2018,
    SUM(CASE WHEN (country = 'USA' OR country = 'INDIA') AND year = 2019 THEN 1 ELSE 0 END) AS movie_produced_in_2019
FROM movie
WHERE country IN ('USA', 'INDIA') AND year IN (2017, 2018, 2019)
	










 
                              segment 3 : Production statistics  and genre analysis
 --Retrieve the unique list of genre present in the database
 --identify the unique list of  genre with highest number of movie produced overall
 --Determin the count of movie that belong to only one genre
 --calculate the average duration of the movie in each genre
 --Find the rank of the thriller genre among all genres in terms of number of movies produced
 

 question 1 ) Retrieve the unique list of genre present in the database
 ANSWER 1)
 CAN BE DONE IN TWO WAYS  -----
 1ST WAY 
 select Distinct genre from genre
      OR 
 2ND WAY     
 select distinct genre from movie m left join genre g on m.id=g.movie_id

question 2) identify the unique list of  genre with highest number of movie produced overall
ANSWER 2)
 select distinct genre,count(id)as movie_produced from movie m
 left join genre g on m.id=g.movie_id
 group by genre
order by count(id) desc 

question 3) --Determin the count of movie that belong to only one genre

written by self (no doubt to ask)
with cte as
 (SELECT id, g.genre,count(distinct genre)as genre_name FROM movie m
left join genre g on m.id=g.movie_id
group by id,g.genre
having count(id)<=1)
select genre,count(id) as movies from cte
group by genre

question 4) calculate the average duration of the movie in each genre

answer 4)
select genre,avg(duration)as avg_duration from movie 
left join genre on movie.id=genre.movie_id
group by genre
order by avg_duration desc

question 5) Find the rank of the thriller genre among all genres in terms of number of movies produced
with cte as
(select genre,count(id)as movies from movie 
left join genre on movie.id=genre.movie_id
group by genre order by  movies )
select *,
rank() over(order by movies desc ) as_rank
from cte



         segment 4 Rating analysis and crew members
 -- Retrieve the minimum and maximum value in each column of the rating  table(except movie_id)
 --Identify the top 10 movies based on the average rating
 -- Summarise the Rating table based on movie count by median rating.
 --identify the production house that has produced the most number of hit movies (average rating>0),
 -- Determin the number of movies released in each genre during  March 2017  in the USA  with more  than 1000 votes
 -- Retrieve movie of each genre starting  with the word 'The' and having  and average rating >8
 
 question 1)-- Retrieve the minimum and maximum value in each column of the rating  table(except movie_id)
answer 1)
 
select max(avg_rating) as  maximum_average_rating,
min(avg_rating) as  minimum_average_rating,
max(total_votes) as maximum_total_votes,
min(total_votes) as minimu_total_votes,
max(total_votes) as maximum_median_votes,
min(total_votes) as minimum_median_votes
 from rating
 
 
 question 2) --Identify the top 10 movies based on the average rating
  answer 2) 
  select id,title,r.avg_rating from movie m
  left join rating r on m.id=r.movie_id
  order by r.avg_rating desc limit 10

     
       OR   
       
             ASSIGNMENT--      If i want movie Title along with the top 10 average based movies

WITH cte AS (
    SELECT m.title as Movie_Name, r.avg_rating
    FROM movie m
    LEFT JOIN rating r ON m.id = r.movie_id
    ORDER BY avg_rating DESC
)
SELECT *, dense_RANK() OVER(ORDER BY avg_rating DESC) AS Rank_of_Movie
FROM cte;

QUESTION 3) -- Summarise the Rating table based on movie count by median rating.
ANSWER 3)

select median_rating,count(movie_id)as Num_of_Movies from rating
group by median_rating
order by median_rating desc

QUESTION 4) --identify the production house that has produced the most number of hit movies (average rating>0),
ANSWER--4)
 
SELECT production_company,count(id)as movies from movie m
left join rating r on  m.id=r.movie_id
where r.avg_rating>8 
group by production_company 
order by count(id) desc	


QUESTION 5) Determin the number of movies released in each genre during  March 2017  in the USA  with more  than 1000 votes

ANSWER 5--)

SELECT g.genre,count(id) from movie m
left join genre g on m.id=g.movie_id
left join rating r on m.id=r.movie_id
where year='2017' and country='USA' AND total_votes>1000
group by genre


QUESTION 6) -- Retrieve movie of each genre starting  with the word 'The' and having  and average rating >8
answer 6) 
SELECT g.genre,m.title from movie m
join genre g on m.id=g.movie_id
join rating r on m.id=r.movie_id
where m.title  like 'The%' and r.avg_rating>8


                                      SEGMENT 5
--    CREW ANALYSIS
1).Identify the columns in names table that have null values.
2) Determin the top 3 directors in the top three genre with movies having an average rating> 8
3) Find the top two actors whose movies have a median rating>=8
4) Identify the top 3 production houses based on the  number of  votes received by their movies
5) Rank actors based on their average rating  in Indian  movies released  in India
6) Identify the Top  five actress IN Hindi movies released in India based on their average rating


QUESTION 1) Identify the columns in names table that have null values.

select 
   sum(case when id='' then 1 else 0 end) as Null_for_id,
    sum(case when name='' then 1 else 0 end) as Null_for_Name,
   sum(case when date_of_birth='' then 1 else 0 end) as Null_for_DOB,
   sum(case when known_for_movies='' then 1 else 0 end) as known_for_movies,
   sum(case when height='' then 1 else 0 end) as Null_for_height
from names
   
QUESTION 2)Determin the top 3 directors in the top three genre with movies having an average rating> 8
answer 2)

              how to extract top 3 genre
SELECT g.genre ,count(m.id)as movies from movie m
left join genre g on m.id=g.movie_id 
group by genre order by  movies desc limit 3


given below code is for full concept-------
WITH cte AS (
    SELECT  d.name_id, g.genre, n.name,COUNT(*) AS movie_count,
        ROW_NUMBER() OVER (PARTITION BY g.genre ORDER BY COUNT(*) DESC) AS director_rank
    FROM director_mapping d
    LEFT JOIN names n ON d.name_id = n.id
    LEFT JOIN movie m ON d.movie_id = m.id
    LEFT JOIN genre g ON m.id = g.movie_id
    LEFT JOIN rating r ON m.id = r.movie_id
    WHERE  r.avg_rating > 8
    GROUP BY d.name_id, g.genre, n.name order by movie_count desc)
SELECT genre, name,SUM(movie_count) AS total_movie_count, director_rank FROM cte 
WHERE  director_rank <= 3
GROUP BY genre, name, director_rank;








QUESTION 3) Find the top two actors whose movies have a median rating>=8
answer 3)
select movie_id from role_mapping where category='actor'

--This one i think is accurate 
SELECT ro.name_id,COUNT(r.movie_id) AS movies 
FROM role_mapping ro
LEFT JOIN rating r ON  ro.movie_id=r.movie_id 
WHERE ro.category = 'actor' AND r.median_rating > 8
GROUP BY ro.name_id LIMIT 2;


-- This one told by instructor but i dont think its right to use movie table when we dont have need
select r.name_id,count(m.id) as movies from movie m
left join role_mapping r on m.id=r.movie_id
left join rating s on m.id=s.movie_id
where r.category ='actor' and s.median_rating>8
group by r.name_id limit 2	



QUESTION 4) Identify the top 3 production houses based on the  number of  votes received by their movies
answer 4)
SELECT DISTINCT PRODUCTION_COMPANY as Production_House ,SUM(TOTAL_VOTES)AS VOTES FROM MOVIE M
LEFT JOIN RATING R ON R.MOVIE_ID=M.ID
GROUP BY PRODUCTION_COMPANY
ORDER BY VOTES DESC LIMIT 3



QUESTION 5) Rank actors based on their average rating  in Indian  movies released  in India

ANSWER 5)

WITH CTE AS (
    SELECT DISTINCT  R.NAME_ID, AVG(S.AVG_RATING) AS AVERAGE
    FROM MOVIE M
    LEFT JOIN ROLE_MAPPING R ON M.ID = R.MOVIE_ID
    LEFT JOIN RATING S ON M.ID = S.MOVIE_ID
    LEFT JOIN PROJECT P ON M.ID = P.ï»¿id
    WHERE P.COUNTRY = 'INDIA' and r .category='actor'
    GROUP BY R.NAME_ID
    ORDER  BY AVERAGE DESC
)
SELECT *, ROW_NUMBER() OVER (ORDER BY AVERAGE DESC) AS RANKING
FROM CTE

QUESTION 6)


ANSWER 6)Identify the Top  five actress IN Hindi movies released in India based on their average rating
WITH CTE AS (
    SELECT DISTINCT  R.NAME_ID, AVG(S.AVG_RATING) AS AVERAGE
    FROM MOVIE M
    LEFT JOIN ROLE_MAPPING R ON M.ID = R.MOVIE_ID
    LEFT JOIN RATING S ON M.ID = S.MOVIE_ID
    LEFT JOIN PROJECT P ON M.ID = P.ï»¿id
    WHERE P.COUNTRY = 'INDIA' AND R.CATEGORY='actress' AND M.LANGUAGES='Hindi'
    GROUP BY R.NAME_ID
    ORDER  BY AVERAGE DESC limit 5
)
SELECT *, ROW_NUMBER() OVER (ORDER BY AVERAGE DESC) AS RANKING
FROM CTE;

                           SEGMENT  6 --Broader Understanding of Data 
--  classify thriller movies based on average rating into different catagories.
--  Analysis the genre-wise running total(CUMSUM) and moving average of the average movie duration
--  identify the five highest grossing movies of each year that belong to top three 
-- Determin the Top two Production house that have produced highest number of hit 
-- Identify the top three actoress based on the number of Super hit movies (average rating
-- Retrieve the details of top  nine directors bases on the number of movies,including 

QUESTION 1) --  classify thriller movies based on average rating into different catagories.
ANSWER 1)


SELECT m.id,r.AVG_RATING ,
CASE
        WHEN r.avg_rating >= 8.0 THEN 'Hit'
        WHEN r.avg_rating >= 6.0 THEN 'Average'
        ELSE 'Flop' end as Movie_catagory
FROM MOVIE M
LEFT JOIN GENRE G ON M.ID=G.MOVIE_ID
LEFT JOIN RATING R ON M.ID=R.MOVIE_ID
WHERE G.GENRE='Thriller' 

QUESTION 2)  Analysis the genre-wise running total(CUMSUM) and moving average of the average movie duration
ANSWER 2)

SELECT id ,genre,duration,
sum(duration) over (partition by genre  order by id) cum_sum, 
avg(duration) over (partition by genre  order by id) moving_Average
from movie
left join genre on (movie.id=genre.movie_id) 



QUESTION 3) identify the five highest grossing movies of each year that belong to top three GENRE

ANSWER3)SELF
WITH CTE AS (SELECT m.id, g.genre, m.title, m.worlwide_gross_income,m.year,
        RANK() OVER (PARTITION BY m.year, g.genre ORDER BY m.worlwide_gross_income DESC) AS ranking
    FROM movie m
    LEFT JOIN genre g ON m.id = g.movie_id
),
CTE_GenreRank AS (SELECT DISTINCT genre,
        RANK() OVER (ORDER BY movies DESC) AS genre_rank
    FROM (
        SELECT  genre,COUNT(id) AS movies
        FROM CTE
        GROUP BY genre LIMIT 3
    ) genre_count
    LIMIT 3
)
SELECT cte.title, cte.worlwide_gross_income, cte.year, cte.genre
FROM CTE cte
JOIN CTE_GenreRank genre_rank ON cte.genre = genre_rank.genre
WHERE cte.ranking <= 5
ORDER BY cte.year, genre_rank.genre_rank, cte.ranking;

QUESTION 4)  Determin the Top two Production house that have produced highest number of hits among multilingual movies.
ANSWER 4)SELF

SELECT m.production_company,languages, count(id) as Total_movies
FROM movie m
LEFT JOIN rating r ON m.id = r.movie_id
WHERE  languages like '%,%'  AND r.avg_rating > 8
GROUP BY m.production_company,languages
order by total_movies desc limit 2 

QUESTION 5)Identify the top three actoress based on the number of Super hit movies (average rating>8) IN THE DRAMA  GENRE
ANSWER 5)  SELF

SELECT id,g.genre,count( m.id) as movie_produced
FROM movie m
left join rating r on m.id=r.movie_id
left join role_mapping ro on m.id=ro.movie_id
left join genre g on m.id=g.movie_id
where ro.category='actress' and r.avg_rating>8 and g.genre='Drama'
group by id,g.genre order by movie_produced desc  limit 3

QUESTION 6)  Retrieve the details of top  nine directors bases on the number of movies,including average inter movie duration,rating,more
ANSWER 6)

WRITTEN BY ME BUT CONFUSION AT ONLY ONE PLACE OUTPUT IS CORRECT
select 
 d.name_id as director_id,
 n.name as director_name,
 count(m.id)as num_Movies_produced,
 avg(m.duration)as average_duration,
 avg(r.avg_rating) from movie m
 left join genre g on m.id=g.movie_id
left join director_mapping d on m.id=d.movie_id
left join rating r on m.id=r.movie_id
LEFT join names n on d.name_id=n.id
where d.name_id is not null
group by d.name_id,n.name order by num_Movies_produced desc

    
