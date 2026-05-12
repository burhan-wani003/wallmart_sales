use superstore_project;

select * from cleaned_superstore;

--1.Total Sales, Profit, Orders

select 
	count(distinct order_id) as total_orders,
	sum(profit) as total_profit,
	sum(sales) as total_sales  
from cleaned_superstore;

--2.Profit Margin
select
	round(sum(profit) / sum(sales) *100,2) as profit_margin
from cleaned_superstore;

--3.Category Performance
select
	category,
	sum(sales) as total_sales,
	sum(profit) as total_profit,
	round(sum(profit) / sum(sales) * 100,2) as prft_margin
from cleaned_superstore
group by Category
order by total_profit desc;

--4. Sub-Category (Find Loss Areas)
select top 10
	sub_category,
	sum(sales) as total_sales,
	sum(profit) as total_profit
from cleaned_superstore
group by Sub_Category
order by total_profit asc;

--5. Region Analysis
select
	region,
	sum(sales) as sales,
	sum(profit) as profit
from cleaned_superstore
group by region
order by profit desc;

--6. Top 10 Profitable Products
select top 10
	product_name,
	sum(sales) as sales,
	sum(profit) as profit
from cleaned_superstore
group by Product_Name
order by profit desc;

--7. Top 10 Loss-Making Products
select top 10
	product_name,
	sum(profit) as total_loss
from cleaned_superstore
group by Product_Name
order by total_loss asc;

--8. Discount Impact (CRITICAL)
select
	discount,
	round(AVG(profit),2) as avg_profit
from cleaned_superstore
group by Discount
order by Discount;

--9. High Discount Loss Orders
select *
from cleaned_superstore
where Discount > 0.3 and profit < 0
order by profit desc;

--10. Customer Segmentation
select 
	segment,
	sum(sales) as sales,
	sum(profit) as profit
from cleaned_superstore
group by Segment
order by profit desc;

--11. Top Customers
select top 10
	customer_name,
	sum(sales) as total_spent,
	sum(profit) as profit
from cleaned_superstore
group by Customer_Name
order by profit desc;

--12. Repeat Customers
select
	customer_name,
	count(order_id) as order_count
from cleaned_superstore
group by Customer_Name
having count(Order_ID) > 5
order by order_count desc;