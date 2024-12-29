SELECT * FROM walmart_db.wallmart;
Select
	count(*)
from walmart_sales;


Select
	*
from walmart_sales
limit 10;


select 
	payment_method,
    count(*)
from walmart_sales
group by payment_method;


-- *Business problems*

-- ● Question 1. : What are the different payment methods, and how many transactions and items were sold with each method?

select
	payment_method,
    count(*) as no_of_transactions,
    sum(quantity) as no_of_items_sold
from walmart_sales
group by payment_method
order by no_of_transactions desc;

-- ● Question 2. : Which category received the highest average rating in each branch?

Select
	*
from walmart_sales
limit 10;

select
	*
from
(SELECT 
    branch, category, AVG(rating) as Avg_Rating,
    rank() over(partition by branch order by AVG(rating) desc) as ranking
FROM
    walmart_sales
GROUP BY branch , category) as data
where ranking = 1;


-- ● Question 3. : What is the busiest day of the week for each branch based on transaction volume?

select
*
from
(SELECT
    branch,
    count(*) as no_of_transactions,
    DATE_FORMAT(STR_TO_DATE(`date`, '%d/%m/%y'), '%W') AS day,
    rank() over(partition by branch order by count(*) desc) as ranking
FROM walmart_sales
group by branch , day) as a
where ranking = 1 ;

-- ● Question 4. : How many items were sold through each payment method?


select
payment_method,
count(distinct(category)) as catg
from walmart_sales
group by payment_method;


-- ● Question 5. : What are the average, minimum, and maximum ratings for each category in each city?


select
	city,
    category,
	avg(rating) as Average_Rating,
    min(rating) as Minimum_Rating,
    max(rating) as Maximum_Rating
from
walmart_sales
group by city, category;

-- ● Question 6. : What is the total profit for each category, ranked from highest to lowest?

-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.

select
	category,
    round(sum(total),2) as total_revenue,
    round(sum(unit_price * quantity * profit_margin),2) as total_profit
from walmart_sales
group by category
order by total_profit desc;


-- Question 7. : What is the most frequently used payment method in each branch?
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

select *
from
(select
	branch,
    payment_method,
    count(*) as total_transactions,
   rank() over(partition by branch order by count(*) desc) as ranking
from
	walmart_sales
    group by branch, payment_method) as tab
    where ranking = 1;



-- ● Question 8. : How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

SELECT 
    branch,
    CASE
        WHEN TIME(time) BETWEEN '05:00:00' AND '11:59:59' THEN 'MORNING'
        WHEN TIME(time) BETWEEN '12:00:00' AND '16:59:59' THEN 'AFTERNOON'
        WHEN TIME(time) BETWEEN '17:00:00' AND '20:59:59' THEN 'EVENING'
        ELSE 'NIGHT'
    END AS time_of_day,
    COUNT(*) AS no_of_tranx
FROM
    walmart_sales
GROUP BY branch , time_of_day
ORDER BY branch , no_of_tranx DESC;


-- Q9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023);

with revenue_2022
as 
(select 
	branch,
    sum(total) as total_revenue
from walmart_sales
where year(str_to_date(date, '%d/%m/%y'))=2022
group by branch),

revenue_2023
as 
(select 
	branch,
    sum(total) as total_revenue
from walmart_sales
where year(str_to_date(date, '%d/%m/%y'))=2023
group by branch)

select
r2022.branch,
r2022.total_revenue as last_yr_revenue,
r2023.total_revenue as current_yr_revenue,
round(((r2022.total_revenue - r2023.total_revenue) / r2022.total_revenue)*100,2) as revenue_decreased_ratio
from
revenue_2022 as r2022
join
revenue_2023 as r2023 on r2022.branch = r2023.branch
where r2022.total_revenue > r2023.total_revenue
order by revenue_decreased_ratio desc;


