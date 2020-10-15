/* UNION deletes duplicate rows by default, UNION ALL keeps duplicates */

Select productCode, count(distinct(priceEach)) as freq from orderdetails
group by productCode having freq > 5;

Select * from cfpb_complaints_2500 where Sub_product = '';
Update cfpb_complaints_2500 set Sub_product = NULL where Sub_product = '';
Delete from cfpb_complaints_2500 where Sub_product is NULL;

/* Which company received the largest amount of complaints on wednesday? */

Select Company, count(*) as freq from cfpb_complaints_2500
where dayname(Data_received) = 'Wednesday' group by company order by freq desc;

/* Which weekday and month do companies receive most complaints? */

Select dayname(Data_received), count(Data_received)as freq
from cfpb_complaints_2500 group by dayname(Data_received) order by freq desc;

Select monthname(Data_received), count(Data_received) as freq
from cfpb_complaints_2500 group by monthname(Data_received) order by freq desc;

/* Considering only the first seven days of the month */

Select monthname(Data_received), count(Data_received) as freq
from cfpb_complaints_2500 where day(Data_received) < 8 group by monthname(Data_received) order by freq desc;

/* Playing around with my birth date, how many days have I been alive? */

Select datediff(now(),'1996-03-13');

/* When will I have lived 10 000 days? */

Select date_add('1996-03-13', interval 10000 day);

/* Who have ordered Ferraris? */

Select orderNumber from orderdetails where productCode
in (Select distinct(productCode) from products where productName like '%Ferrari%');

