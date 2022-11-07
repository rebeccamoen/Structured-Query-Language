-- Query Multiple Tables with Joins
 -- INNER Joins: An inner join is used to find related data in two tables
 SELECT SalesLT.Product.Name As ProductName, SalesLT.ProductCategory.Name AS Category
 FROM SalesLT.Product
 INNER JOIN SalesLT.ProductCategory -- Don't need to add INNER because it is the default kind of join
     ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID;

 SELECT p.Name As ProductName, c.Name AS Category
 FROM SalesLT.Product AS p -- The use of table aliases can greatly simplify a query
 JOIN SalesLT.ProductCategory As c
     ON p.ProductCategoryID = c.ProductCategoryID;

 SELECT oh.OrderDate, oh.SalesOrderNumber, p.Name As ProductName, od.OrderQty, od.UnitPrice, od.LineTotal
 FROM SalesLT.SalesOrderHeader AS oh
 JOIN SalesLT.SalesOrderDetail AS od
     ON od.SalesOrderID = oh.SalesOrderID
 JOIN SalesLT.Product AS p
     ON od.ProductID = p.ProductID
 ORDER BY oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID;

 -- OUTER Joins: An outer join is used to retrieve all rows from one table, and any corresponding rows from a related table
 -- In cases where a row in the outer table has no corresponding rows in the related table, NULL values are returned for the related table fields
 SELECT c.FirstName, c.LastName, oh.SalesOrderNumber
 FROM SalesLT.Customer AS c
 LEFT OUTER JOIN SalesLT.SalesOrderHeader AS oh -- This identifies which of the tables in the join is the outer table (the one from which all rows should be preserved), here Customer is the outer table
     ON c.CustomerID = oh.CustomerID -- Had a RIGHT join been used, the query would have returned all records from the SalesOrderHeader table and only matching data from the Customer table
 ORDER BY c.CustomerID; --  You can also use a FULL outer join to preserve unmatched rows from both sides of the join

 SELECT c.FirstName, c.LastName, oh.SalesOrderNumber
 FROM SalesLT.Customer AS c
 LEFT JOIN SalesLT.SalesOrderHeader AS oh -- Using the LEFT (or RIGHT) keyword automatically identifies the join as an OUTER join, don't need to write OUTER
     ON c.CustomerID = oh.CustomerID
 ORDER BY c.CustomerID;

 SELECT c.FirstName, c.LastName, oh.SalesOrderNumber
 FROM SalesLT.Customer AS c
 LEFT JOIN SalesLT.SalesOrderHeader AS oh
     ON c.CustomerID = oh.CustomerID
 WHERE oh.SalesOrderNumber IS NULL -- Return only the customers who have not placed any orders
 ORDER BY c.CustomerID;

 SELECT p.Name As ProductName, oh.SalesOrderNumber
 FROM SalesLT.Product AS p -- Uses outer joins to retrieve data from three tables
 LEFT JOIN SalesLT.SalesOrderDetail AS od -- All subsequent outer joins must be of the same direction (LEFT or RIGHT)
     ON p.ProductID = od.ProductID
 LEFT JOIN SalesLT.SalesOrderHeader AS oh
     ON od.SalesOrderID = oh.SalesOrderID
 ORDER BY p.ProductID;

 SELECT p.Name As ProductName, c.Name AS Category, oh.SalesOrderNumber
 FROM SalesLT.Product AS p
 LEFT OUTER JOIN SalesLT.SalesOrderDetail AS od
     ON p.ProductID = od.ProductID
 LEFT OUTER JOIN SalesLT.SalesOrderHeader AS oh
     ON od.SalesOrderID = oh.SalesOrderID
 INNER JOIN SalesLT.ProductCategory AS c
     ON p.ProductCategoryID = c.ProductCategoryID
 ORDER BY p.ProductID;

 -- Use a cross join: A cross join matches all possible combinations of rows from the tables being joined
 SELECT p.Name, c.FirstName, c.LastName, c.EmailAddress
 FROM SalesLT.Product as p
 CROSS JOIN SalesLT.Customer as c;

 -- Use a self join: A self join isn’t actually a specific kind of join, but it’s a technique used to join a table to itself by defining two instances of the table, each with its own alias
 -- This approach can be useful when a row in the table includes a foreign key field that references the primary key of the same table
 SELECT pcat.Name AS ParentCategory, cat.Name AS SubCategory
 FROM SalesLT.ProductCategory as cat
 JOIN SalesLT.ProductCategory pcat
    ON cat.ParentProductCategoryID = pcat.ProductCategoryID
 ORDER BY ParentCategory, SubCategory;

 -- Challenge 1: Generate invoice reports
 SELECT * FROM SalesLT.Address, SalesLT.CustomerAddress;

 -- Retrieve customer orders:
 SELECT C.CompanyName, SO.SalesOrderID, SO.TotalDue FROM SalesLT.Customer as C JOIN SalesLT.SalesOrderHeader AS SO ON C.CustomerID = SO.CustomerID;

 -- Retrieve customer orders with addresses:
 SELECT CA.CustomerID, C.CompanyName, A.AddressLine1, A.City, A.StateProvince, A.CountryRegion, A.PostalCode, SO.SalesOrderID, SO.TotalDue
 FROM SalesLT.Customer as C 
 JOIN SalesLT.SalesOrderHeader AS SO 
    ON C.CustomerID = SO.CustomerID
 JOIN SalesLT.CustomerAddress as CA
    ON C.CustomerID = CA.CustomerID
 JOIN SalesLT.Address as A
    ON CA.AddressID = A.AddressID
 WHERE CA.AddressType LIKE 'Main Office';

 -- Challenge 2: Retrieve customer data
 SELECT * FROM SalesLT.Customer AS C, SalesLT.SalesOrderHeader AS SO;

 -- Retrieve a list of all customers and their orders:
 SELECT C.CompanyName, C.FirstName + ' ' + C.LastName AS Contact, SO.SalesOrderID, SO.TotalDue 
 FROM SalesLT.Customer AS C
 JOIN SalesLT.SalesOrderHeader AS SO
    ON C.CustomerID = SO.CustomerID
 ORDER BY SO.SalesOrderID DESC;

 -- Retrieve a list of customers with no address:
 SELECT C.CustomerID, C.CompanyName, C.FirstName + ' ' + C.LastName AS Contact, C.Phone
 FROM SalesLT.Customer AS C
 JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
 WHERE CA.AddressID IS NULL;

 -- Challenge 3: Create a product catalog
 SELECT * FROM SalesLT.Product, SalesLT.ProductCategory;

 -- Retrieve product information by category:
 SELECT PPC.Name AS 'Parent Category', PC.Name AS 'Sub Category', P.Name AS 'Product Name'
 FROM SalesLT.ProductCategory AS PPC 
 JOIN SalesLT.ProductCategory AS PC 
    ON PPC.ProductCategoryID = PC.ParentProductCategoryID
 JOIN SalesLT.Product AS P 
    ON P.ProductCategoryID = PC.ProductCategoryID
 ORDER BY 'Parent Category', 'Sub Category', 'Product Name';
