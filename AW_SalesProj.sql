create table AWProduct (
	ProductKey integer,
	ProductSubcategoryKey integer,
	ProductSKU varchar(30),
	ProductName varchar(100),
	ModelName varchar(100),
	ProductDescription varchar(500),
	ProductColor char(20),
	ProductSize varchar(10),
	ProductStyle varchar(10),
	ProductCost numeric,
	ProductPrice numeric,
	primary key (ProductKey));
	
	
	create table AllSales (
	OrderDate	date,
	StockDate date,
	OrderNumber varchar(30),
	ProductKey integer,
	CustomerKey integer,
	TerritoryKey integer,
	OrderLineItem numeric,
	OrderQuantity numeric);
	
create table aw_territory (
	SalesTerritoryKey integer,
	Region char(50),
	Country char(50),
	Continent char(50));
	
create table awcat(
	ProductCategoryKey integer,
	CategoryName char(30));
	
/*EXAMPLE QUESTIONS*/

/*TASK ONE*: Retrieve customers who have made at least one purchase*/
select distinct(aw_cust.CustomerKey), aw_cust.FirstName, aw_cust.LastName, allsales.OrderQuantity
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey


/*TASK TWO*: find names of customers who have made any purchases*/
SELECT aw_cust.FirstName, aw_cust.LastName, allsales.OrderQuantity
FROM aw_cust
LEFT JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
WHERE allsales.customerKey IS NULL or allsales.customerKey = 0;


/*PRACTICE QUESTIONS: DAY ONE*/

/*TASK ONE: write a query to find the top 5 customers with the highest total order amount*/

SELECT aw_cust.CustomerKey, aw_cust.FirstName, aw_cust.LastName, SUM(awproduct.ProductPrice * allsales.OrderQuantity) AS total_order_amount
FROM aw_cust
JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
JOIN awproduct ON allsales.ProductKey = awproduct.ProductKey
GROUP BY aw_cust.CustomerKey, aw_cust.FirstName, aw_cust.LastName
ORDER BY total_order_amount DESC
LIMIT 5;

/*TASK TWO: Retrieve the names of customers who have placed orders in the past 30 days*/

SELECT aw_cust.FirstName, aw_cust.FirstName, COUNT(OrderNUmber) AS orders_count
FROM aw_cust
JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
WHERE allsales.OrderDate >= NOW() - INTERVAL '30 days'
GROUP BY aw_cust.FirstName, aw_cust.FirstName
ORDER BY orders_count DESC;


/*TASK THREE: Find the product that have been ordered at least three times*/

select awproduct.ProductKey, awproduct.ProductName, count(allsales.OrderNumber) as orders_count
from awproduct
join allsales on awproduct.ProductKey = allsales.ProductKey
group by awproduct.ProductKey, awproduct.ProductName
having count(allsales.OrderNumber) >= 3

/*TASK FOUR: Retreive the order details for orders placed by customers from a specific Country*/
select aw_cust.FirstName, aw_cust.LastName, aw_territory.Country
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join aw_territory on allsales.TerritoryKey = aw_territory.SalesTerritoryKey
where Country = 'United States'

/*TASK FIVE: Write a query to find the customers who have placed orders for products with a price greater than $100*/

select aw_cust.FirstName, aw_cust.LastName, awproduct.ProductName, awproduct.ProductPrice
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
where awproduct.ProductPrice > 100

/*TASK SIX: Get the average order amount for each customer*/

select distinct(aw_cust.CustomerKey), aw_cust.FirstName, aw_cust.LastName, avg(awproduct.ProductPrice * allsales.OrderQuantity) as average_orders_amount
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
group by distinct(aw_cust.CustomerKey), aw_cust.FirstName, aw_cust.LastName
order by avg(awproduct.ProductPrice * allsales.OrderQuantity) desc


/*TASK SEVEN: find the products that have never been ordered*/
select awproduct.ProductKey, awproduct.ProductName, allsales.OrderQuantity
from awproduct
join allsales on awproduct.ProductKey = allsales.ProductKey
where allsales.OrderQuantity is null


/*TASK EIGHT: Retrieve names of customers who have placed orders on weekends*/

SELECT DISTINCT aw_cust.FirstName, aw_cust.LastName, allsales.Orderdate,
       TO_CHAR(allsales.Orderdate, 'Day') AS day_name
FROM aw_cust
JOIN allsales on aw_cust.CustomerKey = allsales.CustomerKey
WHERE EXTRACT(DOW FROM allsales.Orderdate) IN (0, 6)
ORDER BY aw_cust.FirstName


/*TASK NINE: Get the total oder amount for each month*/
SELECT 
    TO_CHAR(allsales.Orderdate, 'YYYY-MM') AS month,  TO_CHAR(allsales.OrderDate, 'FMMonth') AS month_name,
    SUM(awproduct.ProductPrice * allsales.OrderQuantity) AS total_order_amount
FROM awproduct
join allsales on awproduct.ProductKey = allsales.ProductKey
GROUP BY TO_CHAR(allsales.Orderdate, 'YYYY-MM'),  TO_CHAR(allsales.Orderdate, 'FMMonth')
ORDER BY month;

/*TASK TEN: write a query to find customers who have placed orders for more than two different products*/
SELECT aw_cust.CustomerKey, aw_cust.Firstname, aw_cust.Lastname, awproduct.ProductName
FROM aw_cust
JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = allsales.ProductKey
GROUP BY aw_cust.CustomerKey, aw_cust.Firstname, awproduct.ProductName
HAVING COUNT(DISTINCT allsales.ProductKey) > 2;

/*without the product name*/
SELECT aw_cust.CustomerKey, aw_cust.Firstname, aw_cust.Lastname
FROM aw_cust
JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = allsales.ProductKey
GROUP BY aw_cust.CustomerKey, aw_cust.Firstname
HAVING COUNT(DISTINCT allsales.ProductKey) > 2;

/*EXAMPLE QUESTIONS FOR DAY TWO*/
/*TASK ONE: retrieve the order details along with the customer full names for all orders*/
SELECT 
    allsales.OrderNumber,
     allsales.OrderDate,
     sum(allsales.OrderQuantity * awproduct.ProductPrice) as total_orders_amount,
    aw_cust.FirstName || ' ' || aw_cust.LastName AS full_name
FROM aw_cust
JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
group by allsales.OrderNumber, allsales.OrderDate,
    aw_cust.FirstName || ' ' || aw_cust.LastName
	
	
/*TASK TWO: find the products and their corresponding categories*/

select awproduct.ProductKey, awproduct.ProductName, awsubcat.SubcategoryName
from awproduct
join awsubcat on awproduct.ProductSubcategoryKey = awsubcat.ProductSubcategoryKey
group by awproduct.ProductKey, awsubcat.SubcategoryName



/*Task three: Get a list of customers and the total order amount*/
select aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, sum(allsales.OrderQuantity * awproduct.ProductPrice) as total_orders_amount
from aw_cust
join allsales on aw_cust.customerkey = allsales.customerkey
join awproduct on allsales.ProductKey = awproduct.ProductKey
group by aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.lastname


/*PRACTICE QUESTIONS: DAY TWO*/

/*TASK ONE: Retrieve the order detais along with the customer name and product name for each other*/
select aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, allsales.OrderNumber, awproduct.ProductName
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
group by aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName, allsales.OrderNumber, awproduct.ProductName


/*TASK TWO: Get a list of customers who have never placed orders*/
SELECT 
    aw_cust.CustomerKey,
    aw_cust.FirstName || ' ' || aw_cust.LastName as FullName
FROM aw_cust
LEFT JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
WHERE allsales.OrderNumber IS NULL;



/*TASK THREE: Retrieve the names of customers along with the total quantity they ordered*/
select distinct aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, sum(allsales.OrderQuantity) as total_orders_Qty
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
group by aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName


/*TASK FOUR: Find the products that have been oredered by customers from a specific country*/
select aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, aw_territory.Country, awproduct.ProductName
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join aw_territory on allsales.TerritoryKey = aw_territory.SalesTerritoryKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
where Country = 'Canada'
group by aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName, aw_territory.Country, awproduct.ProductName


/*TASK FIVE: Get the total order amount of each customer including those who have not placed any orders*/
SELECT 
    aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, 
	COALESCE(SUM(allsales.OrderQuantity * awproduct.ProductPrice), 0) AS total_order_amount
FROM aw_cust
LEFT JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
LEFT JOIN awproduct on allsales.ProductKey = awproduct.ProductKey 
GROUP BY aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName
ORDER BY aw_cust.FirstName || ' ' || aw_cust.LastName;


/*TASK SIX: Retrieve the order details for orders placed by customers with a specific occupation*/
select aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, aw_cust.Occupation, allsales.OrderNumber, awproduct.ProductName
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
where aw_cust.Occupation = 'Professional'
group by aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName, aw_cust.Occupation, allsales.OrderNumber, awproduct.ProductName
order by  aw_cust.FirstName || ' ' || aw_cust.LastName


/*TASK SEVEN: Find the customers who have placed orders for product with a price higher than the average proice of all products*/
SELECT DISTINCT aw_cust.FirstName || ' ' || aw_cust.LastName as FullName
FROM aw_cust
JOIN allsales ON aw_cust.CustomerKey = allsales.CustomerKey
JOIN awproduct ON allsales.ProductKey = awproduct.ProductKey
WHERE awproduct.ProductPrice > (select AVG(awproduct.ProductPrice) from awproduct)


/*TASK EIGHT: Retrieve the names of customers along the total number of orders they have placed*/
SELECT DISTINCT aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, count(allsales.OrderNumber) as total_orders_number
FROM aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
group by aw_cust.FirstName || ' ' || aw_cust.LastName


/*TASK NINE: Get a list of product and the total quantity ordered for the products*/
select awproduct.ProductKey, awProduct.ProductName, sum(allsales.Orderquantity) as total_order_quantity
from awproduct
join allsales on awproduct.ProductKey = allsales.ProductKey
group by awproduct.ProductKey, awProduct.ProductName
order by awProduct.ProductName



/*MODULE 3: Advanced Filtering and Sorting*/
/*EXAMPLE QUESTIONS: TASK ONE*/
/*Retrieve all customers whose name starts with j*/
select aw_cust.CustomerKey, aw_cust.FirstName
from aw_cust
where aw_cust.FirstName like 'J%'

/*TASK TWO: Find the products with names containing the word 'red'*/
select awproduct.ProductKey, awproduct.ProductName
from awproduct
where awproduct.ProductName like '%red%'

/*TASK THREE: Get the list of customers sorted by their order date in descending order*/
SELECT 
    distinct aw_cust.customerKey,
    aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, allsales.OrderDate
FROM aw_cust
JOIN allsales on aw_cust.CustomerKey = allsales.CustomerKey
ORDER BY allsales.OrderDate DESC;


/*PRACTICE QUESTIONS*/
/*TASK ONE: Retrieve all customers with names starting with 'A' and ending with 'n'*/
select aw_cust.FirstName || ' ' || aw_cust.LastName as FullName
from aw_cust
where aw_cust.FirstName || ' ' || aw_cust.LastName like 'A%N'

/*only firstname*/
select aw_cust.FirstName
from aw_cust
where aw_cust.FirstName like 'A%N'


/*Only last name*/
select aw_cust.LastName
from aw_cust
where aw_cust.LastName like 'A%N'


/*TASK TWO: Find the products with names containing at least one digit*/
SELECT 
    awproduct.ProductKey,
    awproduct.ProductName,
    awproduct.ProductPrice
FROM awproduct
WHERE awproduct.ProductName ~* '[0-9]';


/*TASK THREE: Get the list of the product names sorted by their prices in ascending order*/
select awproduct.ProductKey, awproduct.ProductName, awproduct.ProductPrice
from awproduct
order by awproduct.ProductPrice asc

/*TASK FOUR: Retrieve customers whose names contains exactly five characters*/
select aw_cust.FirstName
from aw_cust
where CHAR_LENGTH(aw_cust.FirstName) = 5;

/*TASK FIVE: fINDING THE PRODUCT NAMES STARTING WITH 'S' AND ENDING WITH 'E'*/
select awproduct.ProductKey, awproduct.ProductName
from awproduct
where awproduct.ProductName like 'S%e'


/*TASK SIX: Get the the list of customers sorted by their firstname and then by their last name*/
SELECT aw_cust.CustomerKey, aw_cust.FirstName, aw_cust.LastName
FROM aw_cust
ORDER BY FirstName, LastName;

/*TASK SEVEN: Retrieve the orders placed on a specific date and then sorted by the customers name in alphabetical order*/
select aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, allsales.OrderNumber, allsales.OrderQuantity, allsales.OrderDate
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.Customerkey
where allsales.OrderDate = '2017-04-01'
order by aw_cust.FirstName || ' ' || aw_cust.lastname asc

/*TASK EIGHT: Find the products with names containing exactly three letters*/
select awproduct.ProductKey, awproduct.ProductName
from awproduct
where char_length(awproduct.ProductName) = 3


/*TASK NINE Get the ist of product names and their prices sorted in descending order*/
select awproduct.ProductKey, awproduct.ProductName, awproduct.ProductPrice
from awproduct
order by awproduct.ProductPrice desc

/*TASK TEN: Retrieve customers whose names contain a space character*/
SELECT aw_cust.CustomerKey, aw_cust.FirstName
FROM aw_cust
WHERE aw_cust.FirstName LIKE '% %';



/*DAY 4: Aggregations and Grouping*/
/*EXAMPLE QUESTIONS*/
/*TASK ONE: Calculate the total order amount for each customer*/
select aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, sum(allsales.OrderQuantity * awproduct.ProductPrice) as total_order_amount
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
group by aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName


/*TASK TWO: Find the average order amount for each customer occupation*/
select aw_cust.Occupation, avg(allsales.OrderQuantity * awproduct.ProductPrice) as average_order_amount
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
group by aw_cust.Occupation

/*TASK THREE: Get the maximum and minimum order quantity for each product*/
select awproduct.ProductKey, awproduct.ProductName, max(allsales.OrderQuantity), min(allsales.OrderQuantity)
from awproduct
join allsales on awproduct.ProductKey =  allsales.ProductKey
group by awproduct.ProductKey, awproduct.ProductName



/*PRACTICE QUESTIONS*/
/*TASK ONE: Calculate the total order and total amount for each order*/
select awproduct.ProductKey, awproduct.ProductName, count(allsales.OrderQuantity) as total_order_quantity, sum(allsales.OrderQuantity * awproduct.ProductPrice) as total_order_amount
from awproduct
join allsales on awproduct.ProductKey =  allsales.ProductKey
group by awproduct.ProductKey, awproduct.ProductName


/*TASK TWO: FIND THE AVERAGE AGE AND THE NUMBER OF CUSTOMERS FOR EACH OCCUPATION*/
SELECT 
    Occupation,
    round(AVG(EXTRACT(YEAR FROM AGE(BirthDate))),2) AS average_age,
    COUNT(*) AS number_of_customers
FROM 
    aw_cust
GROUP BY 
    Occupation
ORDER BY 
    Occupation;


/*TASK THREE: Get the total number of products in each category */
select count(awproduct.ProductName) as total_number_product, awsubcat.SubcategoryName
from awproduct
join awsubcat on awproduct.ProductSubcategoryKey = awsubcat.ProductSubcategoryKey
group by awsubcat.SubcategoryName



/*TASK FOUR: Find the customers with the highest and lowest total order amount*/
select aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, max(sum(awproduct.ProductPrice * allsales.OrderQuantity)) as highest_order_amount,
	min(sum(awproduct.ProductPrice * allsales.OrderQuantity)) as lowest_order_amount
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
group by aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName



SELECT aw_cust.FirstName || ' ' || aw_cust.LastName AS FullName, MAX(total_sales) AS max_total_sales
FROM (
    SELECT 
        aw_cust.CustomerKey,
        aw_cust.FirstName,
        aw_cust.LastName,
        SUM(awproduct.ProductPrice * allsales.OrderQuantity) AS total_sales
    FROM 
        aw_cust
    JOIN 
        allsales ON aw_cust.CustomerKey = allsales.CustomerKey
	join awproduct on allsales.ProductKey = awproduct.ProductKey
    GROUP BY 
        aw_cust.CustomerKey, aw_cust.FirstName, aw_cust.LastName
) AS subquery
GROUP BY 
    FullName;



/*TASK FIVE: Get the maximum and minimum age for each customers' occupation*/

SELECT 
    Occupation,
    MAX(EXTRACT(YEAR FROM AGE(aw_cust.BirthDate))) AS max_age,
    MIN(EXTRACT(YEAR FROM AGE(aw_cust.BirthDate))) AS min_age
FROM 
    aw_cust
GROUP BY 
    Occupation;


/*To extract the real age of customers*/
select distinct aw_cust.FirstName || ' ' || aw_cust.LastName AS FullName, extract(year from age(aw_cust.BirthDate)) as customers_age
from aw_cust
group by FullName, aw_cust.BirthDate



/*TASK SIX: Calculate the total sales amount and the number of orders for each month*/
SELECT 
    DATE_TRUNC('month', allsales.OrderDate) AS month,
    SUM(awproduct.ProductPrice * allsales.OrderQuantity) AS total_sales,
    COUNT(*) AS number_of_orders
FROM 
    allsales
join awproduct on allsales.ProductKey = awproduct.ProductKey
GROUP BY 
    month
ORDER BY 
    month;



/*TASK SEVEN: Find the average price and the number of products for each customer*/
select distinct aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName as FullName, count(awproduct.ProductName) as number_of_product, 
	round(avg(awproduct.ProductPrice),2) as product_average_price
from aw_cust
join allsales on aw_cust.CustomerKey = allsales.CustomerKey
join awproduct on allsales.ProductKey = awproduct.ProductKey
group by aw_cust.CustomerKey, aw_cust.FirstName || ' ' || aw_cust.LastName



/*DAY 5: Advanced Data Manipulation*/
/*EXAMPLE QUESTIONS*/
/*TASK ONE: Update the email address of a specific customer*/
update aw_cust
set EmailAddress = 'brad.beck24@gmail.com'
where CustomerKey = '22388'

/*Check*/
select CustomerKey, EmailAddress
from aw_cust
where CustomerKey = '22388'


/*TASK TWO: Delete all orders placed by a certan customer*/
delete from aw_cust
where CustomerKey = '22388'

/*check*/
select FirstName, LastName
from aw_cust
where CustomerKey = '22388'

/*TASK THREE: Insert a new product into the database and a ensure transactional integrity*/
begin;
insert into awproduct (ProductKey,	ProductSubcategoryKey,	ProductSKU,	ProductName,	ModelName,	ProductDescription,	ProductColor,	ProductSize,	ProductStyle,	ProductCost,	ProductPrice)
values (210,	30,	'FL-U509-R',	'Sport-110 Helmet, Red',	'Sport-110',	'Universal fit, well-vented, lightweight',	'Red',	0,	0,	23.0863,	34.99);
commit;



/*PRACTICE QUESTIONS*/
/*TASK ONE: Increase the prices of products by 10%*/
UPDATE awproduct
SET ProductPrice = ProductPrice * 1.10;


/*TASK TWO: Delete all orders older than 1 year and their associated order items*/
BEGIN;

-- Delete all order items associated with orders older than 1 year
DELETE FROM allsales
WHERE OrderDate < NOW() - INTERVAL '1 year';

select *
from allsales

/*TASK THREE: Insert a new category into the database and update all products of a specific category to new category in a single action*/
insert into awcat (ProductCategoryKey,	CategoryName)
values (5, 'Electronics')

/*check*/
select *
from awcat

/*TASK FOUR: Update the discount percentage for all products in a specific price range*/
UPDATE products
SET discount_percentage = 20  -- Replace with the new discount percentage
WHERE price BETWEEN 100 AND 500;  -- Replace with the specific price range


/*TASK FIVE: Delete all reviews with a rating lower than 3*/
DELETE FROM reviews
WHERE rating < 3;  -- Replace 3 with the threshold rating value


/*TASK SIX: Insert a new customerinto the database along with their associated orders and order items in a single transaction*/ 
INSERT INTO aw_cust (CustomerKey,	Prefix,	FirstName,	LastName,	BirthDate,	MaritalStatus,	Gender,	EmailAddress,	AnnualIncome,	TotalChildren,	EducationLevel,	Occupation,	HomeOwner)
VALUES (01000, 'MR.', 'JOHN', 'DOE', '1960-10-01', 'M', 'F', 'john.doe@example.com', 78000, 4, 'Bachelors', 'Professional', 'Y');



/*TASK SEVEN: Increase the salary of all employees in a specific department by 15%*/
/*TASK SEVEN: Increase the prices of all product in a specific category by 15%*/ 
update awproduct
set Productprice = ProductPrice * 1.15
join allsales on awproduct.ProductKey = allsales.ProductKey
join awcat on aales.PoductCategoryKey = awcat.ProductCategoryKey
where awcat.CategoryName = 'Accessories'



/*TASK EIGHT: Delete all product that not been ordered*/
DELETE FROM awproduct
WHERE ProductKey NOT IN (
    SELECT DISTINCT ProductKey
    FROM allsales
);


/*TASK NINE: Insert a new supplier into the database along with their associated products and ensure that all the records are inserted or none at all*/
BEGIN;

-- Insert a new supplier
INSERT INTO suppliers (supplier_id, supplier_name, contact_name, contact_email, phone)
VALUES (1001, 'ABC Supplies', 'John Smith', 'john.smith@abc.com', '123-456-7890');

-- Insert associated products for the new supplier
INSERT INTO products (product_id, product_name, price, supplier_id)
VALUES 
    (2001, 'Product A', 25.50, 1001),  -- Replace with actual product details
    (2002, 'Product B', 40.00, 1001),  -- Replace with actual product details
    (2003, 'Product C', 15.75, 1001);  -- Replace with actual product details

COMMIT;



/*TASK TEN: Update the order dates for all orders placed on weekends to the following Monday*/ 

UPDATE allsales
SET OrderDate = CASE
                    WHEN EXTRACT(DOW FROM OrderDate) = 6 THEN OrderDate + INTERVAL '2 day'  -- Saturday (DOW = 6), move to Monday
                    WHEN EXTRACT(DOW FROM OrderDate) = 0 THEN OrderDate + INTERVAL '1 day'  -- Sunday (DOW = 0), move to Monday
                    ELSE OrderDate  -- Leave the date unchanged if not a weekend
                 END
WHERE EXTRACT(DOW FROM OrderDate) IN (6, 0);  -- Filter for Saturday (6) or Sunday (0)



/*DAY 6: Advanced Database Concepts: Understand views and their usage, as well as indexing and optimization techniques*/