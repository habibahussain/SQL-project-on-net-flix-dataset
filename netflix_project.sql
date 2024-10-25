select * from netflix;
select type ,count(*) as total_content from netflix
group by type;
-- 15 business problem----
-- Q1 count the number of movies vs tv shows
select type ,
count(*) as total_content from netflix
group by type;
-- find the most common rating for movies and tv show 
select type,
rating from 
(select type, rating, count(*) as common_rating,
rank()over(partition by type order by count(*) desc) as ranking
from netflix 
group by 1,2) as t1 
 where  ranking =1 ;

 -- list all the movies  specific year
 select * from netflix;
 
 select * from netflix 
 where type = 'Movie' and release_year =2020;


 -- find the top 5 countries with the most content on netflix 
select UNNEST(string_to_array(country,',')) as new_country ,count(show_id) as total_content from netflix
 group by 1
 order by total_content 
 desc limit 5;
 -- identify the longest movie 
  select * from  netflix where duration=
(select max(duration) from netflix);

 -- find the content added in last 5 year 
 
select * 
 from netflix
WHERE  
TO_DATE (DATE_ADDED,'MONTH DD,YYYY')>= CURRENT_DATE - INTERVAL '5 YEARS';




--- 7. fIND ALL THE MOVIES /TV DIRECTED BY 'Rajiv Chilaka'

select * from netflix 
where director = 'Rajiv Chilaka';

-- 8 list all the tv show with more than 5 season
select  *
from netflix 
where type = 'TV Show' and  

SPLIT_PART(duration,' ',1)::numeric >5;

-- count the number of content items in genre 
select  genre, count(*) as no_of_content
from netflix 
group by genre;

select
UNNEST(string_to_array(listed_in,',')) as genre,
count(show_id)

from netflix
 group by 1
;

-- 10  find  each year and the average number of content release in india on netflix 
-- return top 5 year with highest vg content release !!!
select 
 extract ( year  from To_Date(date_added,'month DD, YYYY')) as  year,
 count(*),
 round(
 count(*):: numeric /(select count(*) from netflix where country = 'India'):: numeric*100,2) as avg_content 
 
 from netflix where country ='India'
  group by 1;
 
-- select all the content where genre = documentries 

select * from netflix 
where listed_in  Ilike '%Documentaries%';

-- find all the content without a director
select * from netflix 
where  director is null;


 -- 13 find how many movies actor salman khan appear in last 10 year
  select * from netflix 
  where casts 
  ILike '%Salman Khan%'
   and 
    release_year > extract (year from current_date)-10;

	--  14 find the top 10 actor who have appread in the highest number of movie produce in india 
	select  
	unnest(string_to_array(casts,',')) as  actor ,
	count(*) as total_content
	from  netflix
	where 
	country ilike '%india%'
	group by actor
	order by total_content desc  limit 10;

	/**15 categorize the content based on the presence of the 
	 keyword 'kill ' and violance a bad and all as other 
	 content as 'Good' count how many iteam fall into each category
	 **/
	 with new_table as (
	 select *,
	 case 
	 when  description ilike '%kill%'  or description ilike '%violence%'
	  then 'Bad_content'
	   else 'Good_content'
	   end as category
	 
	 from netflix)
	 select category ,
	 count(*) as total_content 
	 from new_table 
	 group by 1;

	 















	 