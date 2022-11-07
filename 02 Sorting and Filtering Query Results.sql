-- Sort and Filter Query Results
 -- Sort results using the ORDER BY clause:
 SELECT Name, ListPrice
 FROM SalesLT.Product
 ORDER BY ListPrice DESC, Name ASC;

 -- Restrict results using TOP:
 SELECT TOP (20) WITH TIES Name, ListPrice -- WITH TIES also show products that share the same price (exceed the 20 limit)
 FROM SalesLT.Product
 ORDER BY ListPrice DESC;

 SELECT TOP (20) PERCENT WITH TIES Name, ListPrice -- Show the 20% most expensive products
 FROM SalesLT.Product
 ORDER BY ListPrice DESC;

 -- Retrieve pages of results with OFFSET and FETCH:
 SELECT Name, ListPrice
 FROM SalesLT.Product
 ORDER BY Name OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY; -- The results start at the 0 position (the beginning) and include only the next 10 rows, essentially defining the first page of results with 10 rows per page

 SELECT Name, ListPrice
 FROM SalesLT.Product
 ORDER BY Name OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY; -- This retrives the next page of results

 -- Use the ALL and DISTINCT options:
 SELECT ALL Color -- Should give same results as you get without the 'ALL'
 FROM SalesLT.Product;

 SELECT DISTINCT Color -- Show the unique color values
 FROM SalesLT.Product;

 SELECT DISTINCT Color, Size -- Show the unique combination of color and size values
 FROM SalesLT.Product;

 -- Filter results with the WHERE clause:
 SELECT Name, Color, Size
 FROM SalesLT.Product
 WHERE ProductModelID = 6
 ORDER BY Name;

 SELECT Name, Color, Size
 FROM SalesLT.Product
 WHERE ProductModelID <> 6
 ORDER BY Name;

 SELECT Name, ListPrice
 FROM SalesLT.Product
 WHERE ListPrice > 1000.00
 ORDER BY ListPrice;

 SELECT Name, ListPrice
 FROM SalesLT.Product
 WHERE Name LIKE 'HL Road Frame %'; -- % = followed by any string

 SELECT Name, ListPrice
 FROM SalesLT.Product
 WHERE ProductNumber LIKE 'FR-_[0-9][0-9]_-[0-9][0-9]'; -- Patterns similar to FR-xNNx-NN (x is a letter and N is a numeral)

 SELECT Name, ListPrice
 FROM SalesLT.Product
 WHERE SellEndDate IS NOT NULL;

 SELECT Name
 FROM SalesLT.Product
 WHERE SellEndDate BETWEEN '2006/1/1' AND '2006/12/31';

 SELECT ProductCategoryID, Name, ListPrice
 FROM SalesLT.Product
 WHERE ProductCategoryID IN (5,6,7);

 SELECT ProductCategoryID, Name, ListPrice, SellEndDate
 FROM SalesLT.Product
 WHERE ProductCategoryID IN (5,6,7) AND SellEndDate IS NULL; -- Combines criterias

 SELECT Name, ProductCategoryID, ProductNumber
 FROM SalesLT.Product
 WHERE ProductNumber LIKE 'FR%' OR ProductCategoryID IN (5,6,7); -- One or both criterias

 -- Challenge 1: Retrieve data for transportation reports
 SELECT * FROM SalesLT.Address;

 -- Retrieve a list of cities:
 SELECT DISTINCT City, StateProvince FROM SalesLT.Address ORDER BY City;

 -- Retrieve the heaviest products:
 SELECT Top (10) PERCENT ProductID, Name, Weight
 FROM SalesLT.Product
 ORDER BY Weight DESC;

 -- Challenge 2: Retrieve product data
 SELECT * FROM SalesLT.Product;

 SELECT Name, Color, Size
 FROM SalesLT.Product
 WHERE ProductModelID = 1; -- Retrieve product details for product model 1 

 SELECT ProductNumber, Name
 FROM SalesLT.Product
 WHERE Color IN ('Black','Red','White') AND Size IN ('S','M'); -- Filter products by color and size 

 SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-%'; -- Filter products by product number where ProductNumber begins with BK-

 SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]'; -- Where any character other than R, and ends with a - followed by any two numerals
