use Project_NTI1

-- 1. Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
Select top 1 pp.product_name ,pb.brand_name, pc.category_name, pp.model_year ,  pp.list_price
from production.products pp inner join production.brands pb
on pp.brand_id = pb.brand_id
inner join  production.categories pc
on pp.category_id = pc.category_id
order by list_price Desc

select top 1 product_name , list_price , model_year
from production.products
order by list_price Desc

-- 2. How many total customers does BikeStore have? Would you consider people with order status 3 as customers substantiate your answer?
Select COUNT(customer_id) '#Customers'
from sales.customers

Select SO.order_status , COUNT(sc.customer_id) '#Customers with order statue =3'
from sales.customers SC inner join sales.orders SO
on SC.customer_id = SC.customer_id
where SO.order_status=3
group by SO.order_status


-- 3. How many stores does BikeStore have?
Select count(store_id) '#Stores'
from sales.stores

-- 4. What is the total price spent per order?
-- Hint: total price = [list_price] *[quantity]*(1-[discount])
Alter table sales.order_items
Add Total_price float

Update sales.order_items
set Total_price =[list_price] *[quantity]*(1-[discount])

Select order_id , SUM(Total_price) 'Total price spent per order'
from sales.order_items
group by order_id


-- 5. What’s the sales/revenue per store?
-- Hint: Sales revenue = ([list_price] *[quantity]*(1-[discount]))
Select SO.store_id ,SUM(SOI.Total_price) 'sales/revenue'
from sales.order_items SOI full outer join sales.orders SO
on SOI.order_id = SO.order_id
Group by SO.store_id

-- 6. Which category is most sold?
Select top 1 PC.category_name , SUM(soi.order_id) 'Total orders by category name'
from sales.order_items soi INNER JOIN production.products pp
On soi.product_id = pp.product_id
inner join production.categories pc 
on pp.category_id = pc.category_id
GROUP BY PC.category_name

-- 7. Which category rejected more orders?


-- 8. Which bike is the least sold?
select top 1 pp.product_name , SUM(soi.quantity) 'Total quantity ordered'
from production.products pp Right outer join sales.order_items soi
on pp.product_id =soi.product_id
group by pp.product_name 
order by  'Total quantity ordered' ASC

-- 9. What’s the full name of a customer with ID 259?
Select CONCAT(first_name , ' ' , last_name) Full_name
from sales.customers
where customer_id = 259

-- 10. What did the customer on question 9 buy and when? What’s the status of this order?
Select pp.product_name  , so.customer_id
from sales.orders so inner join sales.order_items soi
on so.order_id = soi.order_id
inner join production.products pp
on pp.product_id = soi.product_id
where so.customer_id = 259

-- 11.Which staff processed the order of customer 259? And from which store?
select ss.staff_id , CONCAT(ss.first_name , ' ' , ss.last_name) 'Staff full name',
so.customer_id , sst.store_name
from sales.staffs ss inner join sales.orders so
on ss.staff_id = so.staff_id
inner join sales.stores sst
on sst.store_id = so.store_id
where so.customer_id = 259

-- 12. How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?
Select COUNT(staff_id) 'Total staff'
from sales.staffs 

select manager_id , CONCAT(first_name ,' ' , last_name) 'Managers full name'
from sales.staffs
where manager_id is not null

-- 13. Which brand is the most liked?
Select top 1 pb.brand_id, pb.brand_name , SUM(soi.quantity) 'Total orders for each brand'
from sales.order_items soi inner join production.products pp
on pp.product_id = pp.product_id
inner join production.brands pb
on pp.brand_id = pb.brand_id
group by pb.brand_id,pb.brand_name 
order by 'Total orders for each brand' DESC

-- 14. How many categories does BikeStore have, and which one is the least liked?
Select COUNT(category_id) '#Categories'
from production.categories

Select top 1 pc.category_id , pc.category_name , SUM(soi.quantity) 'Total orders for each category'
from sales.order_items soi inner join production.products pp
on pp.product_id = pp.product_id
left outer join production.categories pc
on pp.category_id = pc.category_id
group by pc.category_name , pc.category_id
order by 'Total orders for each category' ASC

-- 15. Which store still have more products of the most liked brand?
select top 1 pp.brand_id , ps.store_id ,ss.store_name, sum(ps.quantity) 'Number of product'
from production.stocks ps inner join production.products pp
on pp.product_id = ps.product_id
inner join sales.stores ss
on ss.store_id = ps.store_id 
where pp.brand_id = 9
group by pp.brand_id , ps.store_id ,ss.store_name
order by 'Number of product' DESC


-- 16. Which state is doing better in terms of sales?
Select top 1 ss.state , SUM(soi.Total_price) 'Sales'
from sales.order_items soi inner join sales.orders so
on soi.order_id = so.order_id
inner join sales.stores ss
on ss.store_id = so.store_id
group by ss.state
order by 'Sales' DESC


-- 17. What’s the discounted price of product id 259?
Select discount
from sales.order_items
where product_id =259

-- 18. What’s the product name, quantity, price, category, model year and brand
-- name of product number 44?
Select * 
from production.products
where product_id=44


-- 19. What’s the zip code of CA?
Select zip_code
from sales.stores
where state ='CA'

-- 20. How many states does BikeStore operate in?
Select COUNT(distinct state) '#States_of_BikeStores'
from sales.stores

Select COUNT(distinct state) '#States_of_Customers_of_BikeStores'
from sales.customers

-- 21. How many bikes under the children category were sold in the last 8 months?
Select pc.category_name , SUM(soi.quantity) 'Total quantity sold under the children category'
from production.categories pc inner join production.products pp 
on pc.category_id = pp.category_id
inner join sales.order_items soi 
on pp.product_id = soi.product_id
inner join sales.orders so 
on so.order_id = soi.order_id
where pc.category_name like '%Children%' 
and so.order_date >= DATEADD(MONTH, -8, GETDATE())
group by pc.category_name



-- 22. What’s the shipped date for the order from customer 523?
Select customer_id , shipped_date
from sales.orders
where customer_id = 523


-- 23. How many orders are still pending?
Select COUNT(order_id) '#Pending'
from sales.orders
where shipped_date is Null


-- 24. What’s the names of category and brand does "Electra white water 3i -2018" fall under?
Select product_name , brand_name ,category_name 
from production.categories pc inner join production.products as pp
on pc.category_id = pp.category_id
inner join production.brands as pb
on pb.brand_id = pp.product_id
where pp.product_name='Electra white water 3i -2018'


select *
from production.products
where product_name='Electra white water 3i -2018'

