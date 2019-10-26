-- 1. What is the undiscounted subtotal for each Order (identified by OrderID).

select distinct [Order Details].OrderID, sum([Order Details].Quantity * [Order Details].UnitPrice) as Subtotal
from [Order Details]
group by OrderID

-- 2. What products are currently for sale (not discontinued)?

select *
from Products
where Discontinued = 1

-- 3. What is the cost after discount for each order? 
-- Discounts should be applied as a percentage off.

select distinct [Order Details].OrderID, 
	sum(case
	when [Order Details].Discount != 0 then
	(([Order Details].Quantity * [Order Details].UnitPrice)) / [Order Details].Discount
	else ([Order Details].Quantity * [Order Details].UnitPrice)
	end) as Subtotal 
from [Order Details]
group by OrderID

-- 4. I need a list of sales figures broken down by category name.
-- Include the total amount sold over all time and the total number of items sold.
select Categories.CategoryName, 
	sum([Order Details].Quantity) as [Total Quantity],
	sum(case
	when [Order Details].Discount != 0 then
	(([Order Details].Quantity * [Order Details].UnitPrice)) / [Order Details].Discount
	else ([Order Details].Quantity * [Order Details].UnitPrice)
	end) as Subtotal 
from [Order Details]
	join Products
	on [Order Details].ProductID = Products.ProductID
	join Categories
	on Products.CategoryID = Categories.CategoryID
group by Categories.CategoryName

-- 5. What are our 10 most expensive products?
select top 10 ProductName, UnitPrice
from Products
order by UnitPrice desc

-- 6. In which quarter in 1997 did we have the most revenue?


select top 1 sum([Order Details].Quantity * [Order Details].UnitPrice) as Subtotal, 
DATEPART(Quarter, OrderDate) as [Quarter]
from [Order Details]
	join Orders
	on Orders.OrderID = [Order Details].OrderID
where YEAR(OrderDate) = '1997' 
group by DATEPART(Year, OrderDate), DATEPART(Quarter, OrderDate)
order by Subtotal desc

-- 7. Which products have a price that is higher than average?
select ProductName, UnitPrice
	from Products
	where UnitPrice > 
(select avg(UnitPrice) from Products)
group by ProductName, UnitPrice