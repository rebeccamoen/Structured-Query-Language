-- Using Built-in Functions
 -- Scalar functions: return a single value based on one or more input parameters, often a data field
 SELECT YEAR(SellStartDate) AS SellStartYear, ProductID, Name -- The YEAR function retrieve the year from the SellStartDate field
 FROM SalesLT.Product
 ORDER BY SellStartYear;

 SELECT YEAR(SellStartDate) AS SellStartYear, -- Additional scalar functions that operate on datetime values
        DATENAME(mm,SellStartDate) AS SellStartMonth, -- mm returns the month name, and dw returns the weekday name
        DAY(SellStartDate) AS SellStartDay,
        DATENAME(dw, SellStartDate) AS SellStartWeekday, -- DATEDIFF function returns the specified time interval between and start date and an end date (measured in years yy)
        DATEDIFF(yy,SellStartDate, GETDATE()) AS YearsSold, -- GETDATE function when used with no parameters returns the current date and time
        ProductID, 
        Name
 FROM SalesLT.Product
 ORDER BY SellStartYear;

 SELECT CONCAT(FirstName + ' ', LastName) AS FullName -- CONCAT = Concatenate, "putting things together as a connected series"
 FROM SalesLT.Customer;

 SELECT UPPER(Name) AS ProductName, -- The product name, converted to upper case by the UPPER function
        ProductNumber, -- The product number, which is a string code that encapsulates details of the product
        ROUND(Weight, 0) AS ApproxWeight, -- The weight of the product, rounded to the nearest whole number by using the ROUND function
        LEFT(ProductNumber, 2) AS ProductType, -- The product type, which is indicated by the first two characters of the product number, starting from the left (using the LEFT function)
        SUBSTRING(ProductNumber,CHARINDEX('-', ProductNumber) + 1, 4) AS ModelCode, -- The model code, which is extracted from the product number by using the SUBSTRING function, which extracts the four characters immediately following the first - character, which is found using the CHARINDEX function
        SUBSTRING(ProductNumber, LEN(ProductNumber) - CHARINDEX('-', REVERSE(RIGHT(ProductNumber, 3))) + 2, 2) AS SizeCode -- The size code, which is extracted using the SUBSTRING function to extract the two characters following the last - in the product code. The last - character is found by taking the total length (LEN) of the product ID and finding its index (CHARINDEX) in the reversed (REVERSE) first three characters from the right (RIGHT)
 FROM SalesLT.Product;

 -- Use logical functions: used to apply logical tests to values, and return an appropriate value based on the results of the logical evaluation
 SELECT Name, Size AS NumericSize
 FROM SalesLT.Product
 WHERE ISNUMERIC(Size) = 1;

 SELECT Name, IIF(ISNUMERIC(Size) = 1, 'Numeric', 'Non-Numeric') AS SizeType -- ISNUMERIC function returns Numeric if the result is 1 (true), and Non-Numeric otherwise
 FROM SalesLT.Product;

 SELECT prd.Name AS ProductName,
        cat.Name AS Category, -- The CHOOSE function returns the value in the ordinal position in a list based on the a specified index value
        CHOOSE (cat.ParentProductCategoryID, 'Bikes','Components','Clothing','Accessories') AS ProductType -- The list index is 1-based so in this query the function returns Bikes for category 1, Components for category 2, etc.
 FROM SalesLT.Product AS prd
 JOIN SalesLT.ProductCategory AS cat
     ON prd.ProductCategoryID = cat.ProductCategoryID;

 -- Use aggregate functions: return an aggregated value, such as a sum, count, average, minimum, or maximum
 SELECT COUNT(*) AS Products, -- The number of products in the table. This is returned by using the COUNT function to count the number of rows (*)
        COUNT(DISTINCT ProductCategoryID) AS Categories, -- The number of categories. This is returned by using the COUNT function to count the number of distinct category IDs in the table
        AVG(ListPrice) AS AveragePrice -- The average price of a product. This is returned by using the AVG function with the ListPrice field
 FROM SalesLT.Product;

 SELECT COUNT(p.ProductID) AS BikeModels, AVG(p.ListPrice) AS AveragePrice
 FROM SalesLT.Product AS p
 JOIN SalesLT.ProductCategory AS c
     ON p.ProductCategoryID = c.ProductCategoryID
 WHERE c.Name LIKE '%Bikes'; -- The average price for products with category names that end in “bikes”

 -- Group aggregated results with the GROUP BY clause: aggregate functions are especially useful when combined with the GROUP BY clause to calculate aggregations for different groups of data
 SELECT Salesperson, COUNT(CustomerID) AS Customers -- Returns the number of customers assigned to each salesperson
 FROM SalesLT.Customer
 GROUP BY Salesperson
 ORDER BY Salesperson;

 SELECT c.Salesperson, SUM(oh.SubTotal) AS SalesRevenue -- Returns the total sales revenue for each salesperson who has completed any sales
 FROM SalesLT.Customer c
 JOIN SalesLT.SalesOrderHeader oh
     ON c.CustomerID = oh.CustomerID
 GROUP BY c.Salesperson
 ORDER BY SalesRevenue DESC;

 SELECT c.Salesperson, ISNULL(SUM(oh.SubTotal), 0.00) AS SalesRevenue -- Returns the sales totals for salespeople who have sold items, and 0.00 for those who haven’t
 FROM SalesLT.Customer c
 LEFT JOIN SalesLT.SalesOrderHeader oh
     ON c.CustomerID = oh.CustomerID
 GROUP BY c.Salesperson
 ORDER BY SalesRevenue DESC;

 -- Filter groups with the HAVING clause: after grouping data, you may want to filter the results to include only the groups that meet specified criteria
 SELECT Salesperson, COUNT(CustomerID) AS Customers -- Returns only salespeople who have more than 100 customers assigned to them
 FROM SalesLT.Customer
 GROUP BY Salesperson
 HAVING COUNT(CustomerID) > 100 -- The HAVING clause needs to be applied after the aggregations and GROUP BY clause!
 ORDER BY Salesperson;

 -- Challenge 1: Retrieve order shipping information
 SELECT * FROM SalesLT.SalesOrderHeader;

 -- Retrieve the order ID and freight cost of each order:
 SELECT SalesOrderID, ROUND(Freight, 2) AS FreightCost FROM SalesLT.SalesOrderHeader; -- The Freight value rounded to two decimal places
 SELECT SalesOrderID, ROUND(Freight, 2) AS FreightCost, LOWER(ShipMethod) AS ShippingMethod FROM SalesLT.SalesOrderHeader; -- The ShipMethod field, formatted in lower case

 -- Shipping date details:
 SELECT SalesOrderID, ROUND(Freight, 2) AS FreightCost, LOWER(ShipMethod) AS ShippingMethod,
    YEAR(ShipDate) AS ShipYear,
    DATENAME(mm,ShipDate) AS ShipMonth,
    DAY(ShipDate) AS ShipDay
 FROM SalesLT.SalesOrderHeader; 

 -- Challenge 2: Aggregate product sales
 SELECT * FROM SalesLT.Product;
 SELECT * FROM SalesLT.SalesOrderDetail;

 -- Retrieve total sales by product:
 SELECT p.Name, SUM(o.LineTotal) AS 'Total Revenue' -- Returns the total sales revenue for each salesperson who has completed any sales
 FROM SalesLT.Product p
 JOIN SalesLT.SalesOrderDetail o
     ON p.ProductID = o.ProductID
 GROUP BY p.Name
 ORDER BY 'Total Revenue' DESC;

 -- Filter the product sales list to include only products that cost over 1,000:
 SELECT p.Name, SUM(o.LineTotal) AS 'Total Revenue'
 FROM SalesLT.Product p
 JOIN SalesLT.SalesOrderDetail o
     ON p.ProductID = o.ProductID
 WHERE o.LineTotal > 1000
 GROUP BY p.Name
 ORDER BY 'Total Revenue' DESC;

 -- Filter the product sales groups to include only total sales over 20,000:
 SELECT p.Name, SUM(o.LineTotal) AS 'Total Revenue'
 FROM SalesLT.Product p
 JOIN SalesLT.SalesOrderDetail o
     ON p.ProductID = o.ProductID
 WHERE o.LineTotal > 1000
 GROUP BY p.Name
 HAVING SUM(o.LineTotal) > 20000
 ORDER BY 'Total Revenue' DESC;
