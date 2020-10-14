/* Calculations with MySQL */

select 2.345*3.456/4.567;

/* Retrieving records from a table */

select vote, ID, sex, income from chile;

/* Showing everything in the table */

select * from chile;

/* Showing all data points in the table where the region is 'M' (metropolitan) */

Select * from chile where region = 'M';

/* Creating a new table with data points that fit specific criteria */

create table Statusquo_research as (select age, sex, statusquo, vote from chile where statusquo < -1 or statusquo > 1);

/*
** Other option:
** create table Statusquo_research as (select age, sex, statusquo, vote from chile where statusquo not between -1 and 1);
*/

/* Calculating the difference in percentage of people from different education+income groups voting for Pinochet */

Select * from chile where age < 50 and education = 'S' and income > 75000 and vote = 'Y';
Select * from chile where age <50 and education = 'S' and income > 75000;
Select 14/43;

/* 14 people in this group voted for Pinochet out of 43 total --> 0.3256 --> 33% */

Select * from chile where age < 50 and education = 'P' and income < 10000 and vote = 'Y';
Select * from chile where age <50 and education = 'P' and income < 10000;
Select 107/257;

/* 107 people in this group voted for Pinochet out of 257 total --> 0.416 --> 42% */

/* Order by */

Select * from tripadvisor_review_sample_without_reviewtext
where overall_rating = 1
and author_num_cities_visited > 10
and author_num_reviews > 15
and author_num_hotelreviews > 10
and review_date between '2012-10-21' and '2012-12-21'
and  username > 'd' order by review_date desc;

Select * From chile
Where (region = 'N' or region = 'S') and
(population between 5000 and 90000) and
((age between 23 and 31) or (age between 35 and 46) or (age between 55 and 65)) and
((income between 2500 and 10000) or (income > 75000)) and
(statusquo not between -0.5 and 0.5) and
(education != 'S') and
(vote = 'A' or vote = 'U')
order by income desc, age asc, statusquo desc
limit 14,11;
