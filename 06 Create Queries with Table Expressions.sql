-- Create queries with table expressions
 -- Create a view: Use the CREATE VIEW statement to create a view
 GO
 CREATE VIEW SalesLT.vProductsRoadBikes AS
 SELECT ProductID, Name, ListPrice
 FROM SalesLT.Product
 WHERE ProductCategoryID = 6;

 -- Query a view:
 GO
 SELECT ProductID, Name, ListPrice
 FROM SalesLT.vProductsRoadBikes
 WHERE ListPrice < 1000;

 -- Use a derived table: For complex queries to avoid adding to their complexity
 SELECT ProductID, Name, ListPrice,
        CASE WHEN ListPrice > 1000 THEN N'High' ELSE N'Normal' END AS PriceType -- Calculates whether the price of a product is considered high or normal
 FROM SalesLT.Product;

 SELECT DerivedTable.ProductID, DerivedTable.Name, DerivedTable.ListPrice -- Further build on this query based on additional criteria, without further adding to its complexity
 FROM
     (
         SELECT
         ProductID, Name, ListPrice,
         CASE WHEN ListPrice > 1000 THEN N'High' ELSE N'Normal' END AS PriceType
         FROM SalesLT.Product
     ) AS DerivedTable
 WHERE DerivedTable.PriceType = N'High';

 -- Challenge 1: Create a view
 -- Write a Transact-SQL query to create a view for customer addresses in Canada:
 GO
 CREATE VIEW SalesLT.vAddress AS
 SELECT AddressLine1, City, StateProvince, CountryRegion
 FROM SalesLT.Address
 WHERE CountryRegion = 'Canada';

 GO
 SELECT * FROM SalesLT.vAddress

 -- Challenge 2: Use a derived table
 SELECT ProductID, Name, Weight, ListPrice,
        CASE WHEN Weight > 1000 THEN N'Heavy' ELSE N'Normal' END AS WeightType -- Classifies products as heavy and normal based on their weight
 FROM SalesLT.Product;

 SELECT DerivedTable.ProductID, DerivedTable.Name, DerivedTable.Weight, DerivedTable.ListPrice
 FROM
     (
         SELECT
         ProductID, Name, Weight, ListPrice,
         CASE WHEN Weight > 1000 THEN N'Heavy' ELSE N'Normal' END AS WeightType
         FROM SalesLT.Product
     ) AS DerivedTable
 WHERE DerivedTable.WeightType = N'Heavy' AND DerivedTable.ListPrice > 2000; -- Find any heavy products with a list price over 2000
