-- Combine query results with set operators
 -- Write a query that uses the UNION operator:
 -- UNION - Excludes duplicates
 -- UNION ALL - Includes duplicates
 SELECT CompanyName 
 FROM SalesLt.Customer  
 WHERE CustomerID BETWEEN 1 and 20000   
 UNION
     SELECT CompanyName 
     FROM SalesLt.Customer  
     WHERE CustomerID BETWEEN 20000 and 40000;

 -- Write a query that uses the INTERSECT operator:
 -- INTERSECT returns distinct rows that are output by both the left and right input queries operator
 -- EXCEPT returns distinct rows from the left input query that aren't output by the right input query
 DECLARE @t1 AS table -- Prepare tables
 (Name nvarchar(30) NOT NULL);
 DECLARE @t2 AS table
 ([Name] nvarchar(30) NOT NULL);
 INSERT INTO @t1 ([Name])
     VALUES
         (N'Daffodil'),
         (N'Camembert'),
         (N'Neddy'),
         (N'Smudge'),
         (N'Molly');
 INSERT INTO @t2 ([Name])
     VALUES
         (N'Daffodil'),
         (N'Neddy'),
         (N'Molly'),
         (N'Spooky');
 SELECT [Name]
 FROM @t1
 INTERSECT
 SELECT [Name]
 FROM @t2
     ORDER BY [Name];

 -- Write a query that uses the CROSS APPLY operator:
 -- CROSS APPLY (Equivalent to an INNER JOIN) returns rows from the left table if it matches with the right table
 -- OUTER APPLY (Equivalent to a LEFT OUTER JOIN) returns aløl rows from the left table and NULL for rows which have no corresponding matches in the right table
 GO
 CREATE OR ALTER FUNCTION dbo.ProductSales (@CustomerID int) -- Pass the CustomerID fom the select statement to the table-valued function in a CROSS APPLY statement
 RETURNS TABLE -- A table-valued function to return the product category and quantity ordered by specific customers
 RETURN
     SELECT C.[Name] AS 'Category', SUM(D.OrderQty) AS 'Quantity'
         FROM SalesLT.SalesOrderHeader AS H
             INNER JOIN SalesLT.SalesOrderDetail AS D
                 ON H.SalesOrderID = D.SalesOrderID
             INNER JOIN SalesLT.Product AS P
                 ON D.ProductID = P.ProductID
             INNER JOIN SalesLT.ProductCategory AS C
                 ON P.ProductCategoryID = C.ProductCategoryID
         WHERE H.CustomerID = @CustomerID
             GROUP BY C.[Name]

 GO
 SELECT C.CustomerID, C.CompanyName, P.Category, P.Quantity
 FROM SalesLT.Customer AS C
     CROSS APPLY dbo.ProductSales(C.CustomerID) AS P;

 -- Challenge 1: Return all company names
 SELECT CompanyName 
 FROM SalesLt.Customer  
 WHERE CustomerID BETWEEN 1 and 20000   
 UNION ALL -- Return ALL company names, including duplicates
     SELECT CompanyName 
     FROM SalesLt.Customer  
     WHERE CustomerID BETWEEN 20000 and 40000;

 -- Challenge 2: Return names from t1
 DECLARE @t1 AS table
 (Name nvarchar(30) NOT NULL);
 DECLARE @t2 AS table
 ([Name] nvarchar(30) NOT NULL);
 INSERT INTO @t1 ([Name])
     VALUES
         (N'Daffodil'),
         (N'Camembert'),
         (N'Neddy'),
         (N'Smudge'),
         (N'Molly');
 INSERT INTO @t2 ([Name])
     VALUES
         (N'Daffodil'),
         (N'Neddy'),
         (N'Molly'),
         (N'Spooky');
 SELECT [Name]
 FROM @t1
 EXCEPT -- Return names from t1 that do not appear in t2
 SELECT [Name]
 FROM @t2
     ORDER BY [Name];
