use walmart;

select * from wallmart_cleaned;

select count(*) from wallmart_cleaned;


select distinct payment_method, count(*) as transactions from wallmart_cleaned group by payment_method;

select count(distinct branch) as stores from wallmart_cleaned;

--select city,count(*) as total_stores from wallmart_cleaned group by city;

--Qno 2:- Identify the highest-rated category in each branch, displaying the branch,category, Avg-rating
select * from (select branch, category,avg(rating) as Avg_Rating, RANK() over (partition by branch order by avg(rating) desc ) as rank from wallmart_cleaned group by branch, category) ranked_data where rank = 1

--Qno 3:- Identify the busiest day for each  branch based on the number of transactions
--select branch,datename(weekday,date) as day_name, count(*) as no_transactions from wallmart_cleaned group by branch, datename(weekday,date) order by branch, no_transactions desc;

select * from (select branch,datename(weekday,date) as day_name, count(*) as no_transactions, RANK() over (partition by branch order by count(*) desc ) AS rank from wallmart_cleaned group by branch, datename(weekday,date))ranked_data where rank = 1;


--Qno 4 calculate the total quantity of items sold per payment method. List payment method and total quantity
select distinct payment_method, sum(quantity) as total_quantity from wallmart_cleaned group by payment_method;

-- Q5: Determine the average, minimum, and maximum rating of categories for each city
SELECT city,category,avg(rating) as avg_rating, min(rating) as min_rating, max(rating) as max_rating from wallmart_cleaned group by city,category

-- Q6: Calculate the total profit for each category
select category,sum(total * profit_margin) as total_profit from wallmart_cleaned group by category order by total_profit desc;

-- Q7: Determine the most common payment method for each branch.Display the branch and preferred method
with cte as (select branch, payment_method, count(*) as total_trans, rank() over (partition by branch order by count(*) desc) as rank from wallmart_cleaned group by branch, payment_method) select * from cte where rank = 1;

-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts. Find out each of the shift and number of invoices 
SELECT 
	branch,
	case
		when datepart(hour,time) < 12 then 'Morning'
		when datepart(hour,time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift,
	count(*) as num_invoices
from wallmart_cleaned
group by branch, case
		when datepart(hour,time) < 12 then 'Morning'
		when datepart(hour,time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end
ORDER BY branch, num_invoices DESC;

-- Q9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)
WITH revenue_2022 AS 
(
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM wallmart_cleaned
    WHERE YEAR(CAST([date] AS DATE)) = 2022
    GROUP BY branch
),

revenue_2023 AS 
(
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM wallmart_cleaned
    WHERE YEAR(CAST([date] AS DATE)) = 2023
    GROUP BY branch
)

SELECT TOP 5
    r22.branch,
    r22.revenue AS last_year_revenue,
    r23.revenue AS current_year_revenue,

    ROUND(
        ((r22.revenue - r23.revenue) * 100.0) / r22.revenue,
        2
    ) AS revenue_decrease_ratio

FROM revenue_2022 r22
INNER JOIN revenue_2023 r23
    ON r22.branch = r23.branch

WHERE r22.revenue > r23.revenue

ORDER BY revenue_decrease_ratio DESC;