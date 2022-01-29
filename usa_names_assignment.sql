-- 1. How many rows are in the names table?
select count(*)
from usa_names;

-- 2. How many total registered people appear in the dataset?
select sum(num_registered)
from usa_names;

-- 3. Which name had the most appearances in a single year in the dataset?
select name, num_registered
from usa_names
order by num_registered desc
limit 1;

-- 4. What range of years are included?
select min(range_of_years.year), max(range_of_years.year)
from (select distinct year from usa_names order by year desc) range_of_years;

-- 5. What year has the largest number of registrations?
select year as largest_registrations_year
from usa_names
group by year
order by sum(num_registered) desc
limit 1;

-- 6. How many different (distinct) names are contained in the dataset?
select count(distinct name) as distinct_names
from usa_names;

-- 7. Are there more males or more females registered?
select (case when males > females then 'true' else 'false' end) as are_more_males_than_females_registered
from (select count(gender) from usa_names where gender = 'M') males,
     (select count(gender) from usa_names where gender = 'F') females;

-- 8. What are the most popular male and female names overall (i.e., the most total registrations)?
select distinct name, gender, sum(num_registered) over (partition by name, gender) as total_registrations
from usa_names
order by total_registrations desc


-- 9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?
select distinct name, gender, sum(num_registered) over (partition by name, gender) as total_registrations
from usa_names
where year between 2000 and 2009
order by total_registrations desc

-- 10. Which year had the most variety in names (i.e. had the most distinct names)?
select year, count(distinct name) as total_distinct_names
from usa_names
group by year
order by total_distinct_names desc

-- 11. What is the most popular name for a girl that starts with the letter X?
select distinct name, sum(num_registered) over (partition by name, gender) as total_registrations
from usa_names
where gender = 'F'
  and name like 'X%'
order by total_registrations desc
limit 1;

-- 12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?
select count(distinct name) as distinct_names
from usa_names
where name like 'Q%'
  and name not like '_u%';

-- 12. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.
select case
           when sum(t.stephen) > sum(t.steven) then 'Stephen is more popular'
           when sum(t.stephen) < sum(t.steven) then 'Steven is more popular'
           else 'They are equally popular' end as popularity
from (select case when name = 'Stephen' then 1 else 0 end as stephen,
             case when name = 'Steven' then 1 else 0 end  as steven
      from usa_names) as t;

-- 14. What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?
-- not sure about this one...
select count(distinct name) / (select count(distinct name) from usa_names) as percent_unisex
from usa_names
where name in
      (select name from usa_names where gender = 'M')
  and name in
      (select name from usa_names where gender = 'F');

-- 15. How many names have made an appearance in every single year since 1880?
select count(distinct name)
from usa_names
where year between 1880 and 2022

-- 16. How many names have only appeared in one year?
select count(distinct name_per_year.name)
from (select name, count(year) as num_years from usa_names group by name) as name_per_year
where name_per_year.num_years = 1;

-- 17. How many names only appeared in the 1950s?
select distinct count(distinct name) as names_1950s
from usa_names
where year between 1950 and 1959
  and name not in
      (select distinct name from usa_names where year < 1950 or year > 1959);

-- 18. How many names made their first appearance in the 2010s?
select count(distinct name) as first_appearance_names_2010s
from usa_names
where year > 2009
  and year < 2020;

-- 19. Find the names that have not be used in the longest.
select name, 2022 - max(year) as num_years_not_used
from usa_names
group by name
order by num_years_not_used desc

-- 20. Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.
-- In what years did the number of male registrations outnumber female registrations