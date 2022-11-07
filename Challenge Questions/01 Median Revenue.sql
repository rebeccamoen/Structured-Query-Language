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
