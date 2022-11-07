-- Use Subqueries
 -- A subquery is a query that is nested within another query. The subquery is often referred to as the inner query, and the query within which it is nested is referred to as the outer query
 SELECT MAX(UnitPrice) -- The maximum UnitPrice in the SalesLT.SalesOrderDetail table
 FROM SalesLT.SalesOrderDetail;

 SELECT Name, ListPrice
 FROM SalesLT.Product
 WHERE ListPrice > -- Retrieves products with a ListPrice higher than the maximum selling price
     (SELECT MAX(UnitPrice)
      FROM SalesLT.SalesOrderDetail);

 SELECT DISTINCT ProductID
 FROM SalesLT.SalesOrderDetail
 WHERE OrderQty >= 20; -- ProductID for each product that has been ordered in quantities of 20 or more
 
 SELECT Name FROM SalesLT.Product
 WHERE ProductID IN -- Finds the names of the products that have been ordered in quantities of 20 or more
     (SELECT DISTINCT ProductID 
      FROM SalesLT.SalesOrderDetail
      WHERE OrderQty >= 20);

 -- Often you can achieve the same outcome with a subquery or a join, and often a subquery approach can be more easily interpreted by a developer looking at the code
 -- than a complex join query because the operation can be broken down into discrete components:
 SELECT DISTINCT Name
 FROM SalesLT.Product AS p
 JOIN SalesLT.SalesOrderDetail AS o
    ON p.ProductID = o.ProductID
 WHERE OrderQty >= 20;

 -- Use correlated subqueries:
 SELECT od.SalesOrderID, od.ProductID, od.OrderQty
 FROM SalesLT.SalesOrderDetail AS od
 WHERE od.OrderQty = -- Retrieves the maximum purchased quantity for each product retrieved by the outer query
     (SELECT MAX(OrderQty)
      FROM SalesLT.SalesOrderDetail AS d
      WHERE od.ProductID = d.ProductID)
 ORDER BY od.ProductID;

 SELECT o.SalesOrderID, o.OrderDate, 
       (SELECT CompanyName -- Retrieve the company name for each customer using a correlated subquery in the SELECT clause
       FROM SalesLT.Customer AS c
       WHERE c.CustomerID = o.CustomerID) AS CompanyName
 FROM SalesLT.SalesOrderHeader AS o
 ORDER BY o.SalesOrderID;

 -- Challenge 1: Retrieve product price information
 SELECT * FROM SalesLT.SalesOrderDetail AS O, SalesLT.Product AS P;

 -- Retrieve products whose list price is higher than the average unit price:
 SELECT ProductID, Name, ListPrice FROM SalesLT.Product
 WHERE ListPrice >
    (SELECT AVG(UnitPrice)
    FROM SalesLT.SalesOrderDetail)
 ORDER BY ProductID;

 -- Retrieve Products with a list price of 100 or more that have been sold for less than 100:
 SELECT ProductID, Name, ListPrice FROM SalesLT.Product
 WHERE ProductID IN
    (SELECT ProductID
    FROM SalesLT.SalesOrderDetail
    WHERE UnitPrice < 100.00)
 AND ListPrice >= 100.00
 ORDER BY ProductID;

 -- Challenge 2: Analyze profitability
 SELECT * FROM SalesLT.Product;

 -- Retrieve the cost, list price, and average selling price for each product:
 SELECT P.ProductID, P.Name, P.StandardCost, P.ListPrice,
    (SELECT AVG(O.UnitPrice) 
    FROM SalesLT.SalesOrderDetail AS O
    WHERE P.ProductID = O.ProductID) AS 'Average Unit Price'
 FROM SalesLT.Product AS P
 ORDER BY ProductID;

 -- Retrieve products that have an average selling price that is lower than the cost:
 SELECT P.ProductID, P.Name, P.StandardCost, P.ListPrice,
    (SELECT AVG(O.UnitPrice) 
    FROM SalesLT.SalesOrderDetail AS O
    WHERE P.ProductID = O.ProductID) AS 'Average Unit Price'
 FROM SalesLT.Product AS P
 WHERE P.StandardCost >
    (SELECT AVG(O.UnitPrice) 
    FROM SalesLT.SalesOrderDetail AS O
    WHERE P.ProductID = O.ProductID)
 ORDER BY ProductID;
