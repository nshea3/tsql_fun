use TSQL2012;
select orderid,orderdate, custid, empid from Sales.Orders
where orderdate >= '2007-06-01 00:00:00.000'
and orderdate < '2007-07-01 00:00:00.000'
order by orderdate;

--Using last day function
--
select orderid,orderdate, custid, empid from Sales.Orders
where orderdate = EOMONTH(orderdate);

select empid, firstname, lastname from HR.Employees
where lastname like '%a%a%';

--This is turning out wrong, do not know why
select orderid, SUM(itemtotalvalue) as totalvalue from
(select orderid, unitprice * qty as itemtotalvalue from Sales.OrderDetails) as sales_totalval
group by sales_totalval.orderid
having SUM(itemtotalvalue) > 10000;

select top 3 shipcountry, AVG(freight) as avgfreight from
(select shipcountry, freight from Sales.Orders) as freightcountry
group by shipcountry
order by avgfreight desc;

select custid, orderdate, orderid, 
ROW_NUMBER() over (partition by custid order by orderdate, orderid) as rownum from Sales.Orders
order by custid;

select empid, firstname, lastname, titleofcourtesy, 
case when titleofcourtesy in ('Ms.', 'Mrs.') then 'Female'
when titleofcourtesy = 'Mr.' then 'Male'
else 'Unknown'
 end as gender
 from HR.Employees;

select custid, region from Sales.Customers
order by case when region is null then 1 else 0 end, region;