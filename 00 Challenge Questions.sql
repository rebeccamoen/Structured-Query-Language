-- Challenge Questions 
 -- Challenge Question 1: Median Revenue
 SELECT DISTINCT
    YEAR(OrderDate) AS Years,
    MIN(SubTotal) OVER (PARTITION BY YEAR(OrderDate)) AS MinSale,
    MAX(SubTotal) OVER (PARTITION BY YEAR(OrderDate)) AS MaxSale,
    AVG(SubTotal) OVER (PARTITION BY YEAR(OrderDate)) AS AvgSale,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY SubTotal) OVER (PARTITION BY YEAR(OrderDate)) AS MedianSale
 FROM Sales.SalesOrderHeader
 ORDER BY Years;
 GO

 -- Challenge Question 2: Year over Year Comparisons
 WITH Sales_FY(SalesPersonID, FY, FQ, FQSales) AS
 (
    SELECT
        SalesPersonID,
        DATEPART(YEAR, DATEADD (MONTH, -6, OrderDate)) AS FY,
        DATEPART(QUARTER, DATEADD (MONTH, -6, OrderDate)) AS FQ,
        FQSales = SUM(SubTotal)
    FROM Sales.SalesOrderHeader
    WHERE OnlineOrderFlag = 0
    GROUP BY SalesPersonID, DATEPART(YEAR, DATEADD (MONTH, -6, OrderDate)), DATEPART(QUARTER, DATEADD (MONTH, -6, OrderDate))
 ) 
 SELECT
    P.LastNAme,
    S1.*,
    S2.FQSales AS SalesSameFQLastYr,
    S1.FQSales - S2.FQSales AS Change,
    ((S1.FQSales - S2.FQSales)/S2.FQSales) * 100 AS [%Change]
 FROM Sales_FY AS S1
    LEFT JOIN Sales_FY AS S2
        ON S1.SalesPersonID = S2.SalesPersonID
        AND S1.FQ = S2.FQ
        AND S1.FY-1 = S2.FY
    INNER JOIN Person.Person AS P
        ON S1.SalesPersonID = P.BusinessEntityID
 WHERE S1.FY = 2013
 ORDER BY SalesPersonID, FY DESC, FQ DESC;

 -- Challenge Question 3: Vacation Hours
 SELECT SUBSTRING(E.NationalIDNumber, (LEN(E.NationalIDNumber)-3), 4) AS SSN, P.FirstName, P.LastName, E.JobTitle, E.VacationHours FROM HumanResources.Employee AS E
    JOIN Person.Person AS P ON E.BusinessEntityID = P.BusinessEntityID
 ORDER BY E.VacationHours DESC;

 -- Challenge Question 4: Special Team
 SELECT SO.SalesPersonID, P.LastName, P.FirstName, ST.Name, SO.SubTotal, YEAR(OrderDate) AS Year
 FROM Sales.SalesOrderHeader AS SO
    JOIN Person.Person AS P ON SO.SalesPersonID = P.BusinessEntityID
    JOIN Sales.SalesTerritoryHistory AS STH ON SO.SalesPersonID = STH.BusinessEntityID
    JOIN Sales.SalesTerritory AS ST ON STH.TerritoryID = ST.TerritoryID
 WHERE (YEAR(OrderDate) = 2014) AND (Name='Canada' OR Name='Southwest' OR Name='Northwest')
 ORDER BY SubTotal DESC
