-- 
-- Exploring the datasets and tables
--

Select *
From customers;

Select *
from employees;

Select *
From offices;

Select *
From orderdetails;

Select *
From orders;

Select *
From payments;

Select *
From productlines;

Select *
From products;

Select *
From warehouses;

--
-- Exploring the product table
-- 

Select distinct(warehousecode), sum(quantityinstock)
from products
group by 1;

Select productLine, count(productLine), sum(quantityInStock), warehouseCode
From products
group by 1, 4;

Select distinct(warehouseCode), count(productLine), sum(quantityInStock)
From products
group by 1;

Select productline, count(productline), sum(quantityInStock)
from products
where warehousecode = 'a'
group by 1;

Select productline, count(productline), sum(quantityInStock)
from products
where warehousecode = 'b'
group by 1;

Select productline, count(productline), sum(quantityInStock)
from products
where warehousecode = 'c'
group by 1;

Select productline, count(productline), sum(quantityInStock)
from products
where warehousecode = 'd'
group by 1;

Select distinct(p.productLine), p.warehousecode, w.warehouseName
From products p
Join warehouses w
	on p.warehouseCode = w.warehouseCode
order by 2;

--
-- Exploring the order table
--
Select distinct(status), count(status)
From Orders
group by 1;

Select *
From Orders
Where status in ('shipped', 'resolved');


Select *
From Orders
Where status = 'cancelled';

Select *
From Orders
Where status in ('on hold', 'disputed', 'in process');

Select * 
From orders
Where shippeddate is null.

Select sum(shippeddate)
From orders
Where shippeddate is null;

--
-- Understanding the relatioship between the orders, products and warehouse so as to know the specific product and its various quantity that are still avaliable in the warehouse
-- 

Select od.orderNumber, od.productCode, od.quantityOrdered, o.status, p.productName, p.productLine, p.warehouseCode
from orderdetails od
Join orders o
	On od.orderNumber = o.orderNumber
Join products p
	On p.productCode = od.productCode;


Select distinct(od.orderNumber), od.quantityOrdered, o.status, p.productLine, p.warehouseCode
from orderdetails od
Join orders o
	On od.orderNumber = o.orderNumber
Join products p
	On p.productCode = od.productCode
Where status in ('shipped', 'resolved');
    
    
Select  p.warehouseCode, p.productLine, sum(od.quantityOrdered) As TotalQuantityOrdered
from orderdetails od
Join orders o
	On od.orderNumber = o.orderNumber
Join products p
	On p.productCode = od.productCode
Where status in ('shipped', 'resolved', 'disputed' ) 
Group by 1, 2
order by 1 ;

Select p.warehouseCode, p.productLine, sum(od.quantityOrdered) As TotalQuantityOrdered
from orderdetails od
Join orders o
	On od.orderNumber = o.orderNumber
Join products p
	On p.productCode = od.productCode
Where status in ('in process')
Group by 1, 2
order by 1;

Select  p.warehouseCode, p.productLine, sum(od.quantityOrdered) As TotalQuantityOrdered
from orderdetails od
Join orders o
	On od.orderNumber = o.orderNumber
Join products p
	On p.productCode = od.productCode
Where status in ('shipped', 'resolved', 'disputed','in process' ) 
Group by 1, 2
order by 1;

Select warehouseCode, productLine,  sum(quantityInStock) as TotalQuantityInStock
From products
group by 1, 2
Order by 1;

Select t1.warehousecode, t1.productLine, t1.TotalQuantityinstock, t2.TotalQuantityOrdered, (t1.TotalQuantityinstock - t2.TotalQuantityOrdered) As TotalRemainingQnatityInStock
From (Select warehouseCode, productLine,  sum(quantityInStock) as TotalQuantityInStock
		From products
		group by 1, 2
		Order by 1) T1
Join (Select  p.warehouseCode, p.productLine, sum(od.quantityOrdered) As TotalQuantityOrdered
		from orderdetails od
		Join orders o
			On od.orderNumber = o.orderNumber
		Join products p
			On p.productCode = od.productCode
		Where status in ('shipped', 'resolved', 'disputed', 'in process' ) 
		Group by 1, 2
		order by 1) T2
	On T1.warehousecode = T2. warehousecode
    and
		T1.productline = T2.productline;