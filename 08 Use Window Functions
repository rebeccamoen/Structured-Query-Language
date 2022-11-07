-- Use window functions
 -- Ranking function: The query uses a CTE (common table expression) called sales to add the RANK window function
 WITH sales AS -- To create a CTE, use a WITH clause
 (
     SELECT C.Name AS 'Category', CAST(SUM(D.LineTotal) AS numeric(12, 2)) AS 'SalesValue'
     FROM SalesLT.SalesOrderDetail AS D
     INNER JOIN SalesLT.Product AS P
         ON D.ProductID = P.ProductID
     INNER JOIN SalesLT.ProductCategory AS C
         ON P.ProductCategoryID = C.ProductCategoryID
     WHERE C.ParentProductCategoryID = 4
         GROUP BY C.Name
 )
 SELECT Category, SalesValue, RANK() OVER(ORDER BY SalesValue DESC) AS 'Rank'
 FROM sales
     ORDER BY Category; -- The RANK function required the rows to be ordered by SalesValue, but the final result set was ordered by Category

 -- Offset function: Use the LAG window function to return each year’s budget, together with the previous year’s budget value
 CREATE TABLE dbo.Budget
 (
     [Year] int NOT NULL PRIMARY KEY,
     Budget int NOT NULL
 );

 INSERT INTO dbo.Budget ([Year], Budget)
     VALUES
         (2017, 14600),
         (2018, 16300),
         (2019, 18200),
         (2020, 21500),
         (2021, 22800);

 SELECT [Year], Budget, LAG(Budget, 1, 0) OVER (ORDER BY [Year]) AS 'Previous'
     FROM dbo.Budget
     ORDER BY [Year]; 

 -- Aggregation function: Use PARTITION BY to count the number of subcategories in each category
 SELECT C.Name AS 'Category', SC.Name AS 'Subcategory', COUNT(SC.Name) OVER (PARTITION BY C.Name) AS 'SubcatCount'
 FROM SalesLT.SalesOrderDetail AS D
 INNER JOIN SalesLT.Product AS P
     ON D.ProductID = P.ProductID
 INNER JOIN SalesLT.ProductCategory AS SC
     ON P.ProductCategoryID = SC.ProductCategoryID
 INNER JOIN SalesLT.ProductCategory AS C
     ON SC.ParentProductCategoryID = C.ProductCategoryID
     GROUP BY C.Name, SC.Name
     ORDER BY C.Name, SC.Name;

 -- Challenge 1: Return a RANK value for products
 WITH sales AS
 (
    SELECT PPC.Name AS 'Category', PC.Name AS 'SubCategory', CAST(SUM(SO.LineTotal) AS numeric(12, 2)) AS 'SalesValue'
    FROM SalesLT.SalesOrderDetail AS SO
    INNER JOIN SalesLT.Product as P
        ON P.ProductID = SO.ProductID
    INNER JOIN SalesLT.ProductCategory as PC 
        ON P.ProductCategoryID = PC.ProductCategoryID
    INNER JOIN SalesLT.ProductCategory as PPC 
        ON PC.ParentProductCategoryID = PPC.ProductCategoryID
    GROUP BY PPC.Name, PC.Name
 )
 SELECT Category, SubCategory, SalesValue, RANK() OVER(PARTITION BY Category ORDER BY SalesValue DESC) AS 'Rank'
 FROM sales
 ORDER BY Category, SalesValue DESC;

 -- Challenge 2: Return the next year’s budget value
 SELECT [Year], Budget, LEAD(Budget, 1, 0) OVER (ORDER BY [Year]) AS 'Next'
 FROM dbo.Budget
 ORDER BY [Year]; 

 -- Challenge 3: Return the first and last budget values for each year
 SELECT [Year], Budget, FIRST_VALUE(Budget) OVER (ORDER BY Year ASC) AS FirstValue, LAST_VALUE(Budget) OVER (ORDER BY Year ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS LastValue
 FROM dbo.Budget
 ORDER BY Year; 

 -- Challenge 4: Count the products in each category
 SELECT C.Name AS 'Category', SC.Name AS 'Subcategory', COUNT(P.Name) OVER (PARTITION BY C.Name) AS 'ProductCount'
 FROM SalesLT.SalesOrderDetail AS D
 INNER JOIN SalesLT.Product AS P
     ON D.ProductID = P.ProductID
 INNER JOIN SalesLT.ProductCategory AS SC
     ON P.ProductCategoryID = SC.ProductCategoryID
 INNER JOIN SalesLT.ProductCategory AS C
     ON SC.ParentProductCategoryID = C.ProductCategoryID
     GROUP BY C.Name, SC.Name, P.Name
     ORDER BY C.Name, SC.Name, P.Name;
