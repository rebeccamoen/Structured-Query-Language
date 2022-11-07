-- Use pivoting and grouping sets
 -- Pivot data using the PIVOT operator:
 GO
 CREATE VIEW SalesLT.vCustGroups AS
 SELECT AddressID, CHOOSE(AddressID % 3 + 1, N'A', N'B', N'C') AS custgroup, CountryRegion
 FROM SalesLT.Address;

 GO
 SELECT AddressID, custgroup, CountryRegion
 FROM SalesLT.vCustGroups;

 SELECT CountryRegion, p.A, p.B, p.C
 FROM SalesLT.vCustGroups PIVOT (
         COUNT(AddressID) FOR custgroup IN (A, B, C)
 ) AS p; -- The result set shows the total number of customers in each customer group for each country

 -- Group data using a grouping subclause: Use subclauses like GROUPING SETS, ROLLUP, and CUBE to group data in different ways
 -- ROLLUP allows to dictate a hierarchy and provides a grand total for your groupings
 -- Alternatively, use CUBE to get all possible combinations for groupings
 GO
 CREATE VIEW SalesLT.vCustomerSales AS 
 SELECT Customer.CustomerID, Customer.CompanyName, Customer.SalesPerson, SalesOrderHeader.TotalDue 
 FROM SalesLT.Customer 
 INNER JOIN SalesLT.SalesOrderHeader 
     ON Customer.CustomerID = SalesOrderHeader.CustomerID;

 GO
 SELECT * FROM SalesLT.vCustomerSales;
 
 -- The use of ROLLUP enabled you to group the data in a way that allowed you to get the subtotal for historical sales for each sales person, and a final grand total for all sales at the bottom of the result set
 SELECT SalesPerson, CompanyName, SUM(TotalDue) AS TotalSales
 FROM SalesLT.vCustomerSales
     GROUP BY ROLLUP (SalesPerson, CompanyName); 

 -- Challenge 1: Pivot product data
 SELECT *
 FROM (
    SELECT P.ProductID, C.Name, ISNULL(P.Color, 'Uncolored') AS Color
    FROM SalesLT.Product AS P
    JOIN SalesLT.ProductCategory AS C
        ON P.ProductCategoryID = C.ProductCategoryID
 ) AS PPC PIVOT (
    COUNT(ProductID) FOR Color IN (Silver, Black, Yellow, Red, Blue, Grey, Multi, Uncolored)
 ) AS PVT
    ORDER BY Name;

 -- Challenge 2: Group sales data
 SELECT CompanyName, SalesPerson, SUM(TotalDue) AS TotalSales
 FROM SalesLT.vCustomerSales
    GROUP BY ROLLUP (CompanyName, SalesPerson); 
