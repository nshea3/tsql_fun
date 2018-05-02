USE TSQL2012;

--Exercies 1-1
--Write query that returns the maximum value in the orderdate column
--for each employee
select empid, MAX(orderdate) as maxorderdate
from Sales.Orders
group by empid


--Encapsulate query from exercise 1-1 in a derived table 
-- Write join between derived table and Orders table to return the orders 
-- with max order date for each employee
;WITH mostrecentsale AS (select empid, MAX(orderdate) as maxorderdate
from Sales.Orders
group by empid)
select mostrecentsale.empid, orderdate, orderid, custid from mostrecentsale LEFT JOIN Sales.Orders
on Sales.Orders.empid = mostrecentsale.empid
and Sales.Orders.orderdate = mostrecentsale.maxorderdate;


--Write a query that calculates row number for each order based on orderdate,
--orderid numbering

select orderid, orderdate, custid, empid, ROW_NUMBER() over(order by orderdate asc, orderid asc) as rownum
from Sales.Orders;


--Write a query that returns rows with row numbers 11 through 20 based on the row number definition
-- in exercise 2-1. Use a CTE to encapsulate the code from 2-1
;WITH sortedorders as (select orderid, orderdate, custid, empid, ROW_NUMBER() 
over(order by orderdate asc, orderid asc) as rownum
from Sales.Orders)
select * from sortedorders
where sortedorders.rownum > 10
and sortedorders.rownum < 21;



--Write a solution using a recursive CTE that returns the management chain leading 
--to Zoya Dolgopyatova (employee id 9)

;with suboordinate as 
(select empid, mgrid, firstname, lastname from HR.Employees S
where S.empid = 9
UNION ALL
select C.empid, C.mgrid, C.firstname, C.lastname from suboordinate as M
join HR.Employees as C
on M.mgrid = C.empid)
select * from suboordinate;


