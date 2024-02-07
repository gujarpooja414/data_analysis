-- time_of_day to see what time of day, the sales are higher
select time ,
   ( CASE  
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
    ) AS time_of_day
from sales;

---------add column---------------------
ALTER TABLE sales ADD time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
	CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

--day_name to see what day, the sales are higher
-----add column-----------------
select pur_date, to_char(pur_date,'day') as day_name from sales;
ALTER TABLE sales ADD day_name VARCHAR(20);
UPDATE sales
SET day_name = to_char(pur_date,'day');

--month_name to see what month, the sales are higher
-----------add column------------------
select pur_date, to_char(pur_date,'mon') as month_name from sales;
ALTER TABLE sales ADD month_name VARCHAR(20);
UPDATE sales
SET month_name = to_char(pur_date,'mon');



-------------------------------------------------------------------------
-------------------------------------------------------------------------
---------------------product analysis------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------

--1.how many cities does the data have
select distinct city from sales;

--2. In which city is each branch
select distinct city,branch from sales;

--3.how many unique product line does the data have
select count(distinct product_line) from sales;

--what is the most common payment mode
select payment, count(*) from sales group by payment order by count(*) desc;

--what is the most selling product line
select * from (select product_line, count(*) from sales group by product_line order by count(*) desc) where rownum=1;

--what is the total revenue by month
select month_name,sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

--what month had largest cogs
select month_name, sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

--what product line has largest revenue
select product_line, sum(total) as revenue
from sales
group by product_line
order by revenue desc;

--what city has largest revenue
select city, sum(total) as revenue
from sales
group by city
order by revenue desc;

--what product line has largest vat
select product_line, avg(tax_pct) as avg_tax
from sales
group by product_line
order by avg_tax desc;

--which branch sold more products that average product sold
select branch, sum(quantity) as qty 
from sales
group by branch
having sum(quantity) >(select avg(quantity) from sales);

--what is most common product line by gender
select gender,product_line,count(gender) as total_count
from sales
group by gender,product_line
order by total_count desc ;

--what is average rating of each product line
select product_line, round(avg(rating),2) as avg_rate
from sales
group by product_line
order by avg_rate desc;

--------------------------------------------------------
--------------------------------------------------------
---------sales analysis---------------------------------
--------------------------------------------------------
--------------------------------------------------------

--number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sales 
from sales
where day_name='sunday'
group by time_of_day
order by total_sales desc;

--which customer type brings most revenue
select customer_type, sum(total) as revenue
from sales
group by customer_type;

--which city has largest tax percent
select city, sum(tax_pct) as tax
from sales
group by city
order by tax;

--which customer type pays more tax
select customer_type, sum(tax_pct) as tax
from sales
group by customer_type
order by tax desc;

---------------------------------------------------
---------------------------------------------------
---------------customer analysis-------------------
---------------------------------------------------
---------------------------------------------------

--how many unique customer types does the data have
select distinct customer_type from sales;

--how many unique payment method does the data have
select distinct payment from sales;

--what is the most common customer type
select customer_type, count(*) as total
from sales
group by customer_type;

--what is the gender of most of the customer
select gender, count(*) as total
from sales
group by gender
order by total desc;

--what is gender distribution per branch
select gender, count(*) as total
from sales
where branch='A'
group by gender
order by total desc;
select gender, count(*) as total
from sales
where branch='B'
group by gender
order by total desc;
select gender, count(*) as total
from sales
where branch='C'
group by gender
order by total desc;

--which time of day do customer gives most rating
select time_of_day, avg(rating) as rate
from sales
group by time_of_day
order by rate desc;

--which time of day do customer gives most rating per branch
select time_of_day, avg(rating) as rate
from sales
where branch='A'
group by time_of_day
order by rate desc;

--which day of week has best avg rating
select day_name, avg(rating) as rate
from sales
group by day_name
order by rate desc;

--which day of week has best avg rating per branch
select day_name, avg(rating) as rate
from sales
where branch='A'
group by day_name
order by rate desc;
