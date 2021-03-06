/****** Script for SelectTopNRows command from SSMS  ******/
USE TSQL2012
GO
--Create a view that returns the total quantity for each employee and year

if OBJECT_ID('Sales.VEmpOrders') is not null
drop view sales.VEmpOrders;
GO

create view Sales.VEmpOrders
AS(
select empid, YEAR(orderdate) as orderyear, SUM(OrderDetails.qty) as qty
from TSQL2012.Sales.Orders join TSQL2012.Sales.OrderDetails
on TSQL2012.Sales.Orders.orderid = TSQL2012.sales.OrderDetails.orderid
group by empid, YEAR(orderdate))

GO

--Query against Sales.VEmpOrders that returns running total quantity for each employee
--and year

select empid, orderyear, qty, SUM(qty) OVER(partition by empid order by orderyear) as runqty from
Sales.VEmpOrders 
order by empid, orderyear
GO


--Inline function that accepts a supplier ID (@supid AS INT) and requested number of products
--(@n AS INT). Function should return @n products with the highest unit prices that
--are supplied by the specified supplier ID

IF OBJECT_ID('Production.TopProducts') IS NOT NULL DROP FUNCTION Production.TopProducts;
GO
create function Production.TopProducts(@supid AS INT, @n AS INT) RETURNS TABLE
AS
RETURN 
	SELECT TOP (@n) productid, productname, supplierid, categoryid, unitprice, discontinued
	FROM Production.Products
	WHERE supplierid = (@supid)
	ORDER BY unitprice DESC

GO

select * from Production.TopProducts(5, 2);

--Using the cross apply operator and the function you created in Exercise 4-1, return
--for each supplier, two most expensive products 

select SUPS.supplierid, companyname, productid, productname, unitprice from 
Production.Suppliers SUPS 
CROSS APPLY Production.TopProducts(SUPS.supplierid, 2)
