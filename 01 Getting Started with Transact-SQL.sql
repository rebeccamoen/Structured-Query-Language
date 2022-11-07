-- Get Started with Transact-SQL
-- Use SELECT queries to retrieve data
SELECT ProductNumber, Color, Size, Color + ', ' + Size AS ProductDetails
FROM SalesLT.Product;

-- Work with data types
SELECT CAST(ProductID AS varchar(5)) + ': ' + Name AS ProductName -- CAST function is an ANSI standard and can be used to remove or reduce format while still converting
SELECT CONVERT(varchar(5), ProductID) + ': ' + Name AS ProductName -- CONVERT is a SQL Server specific function
FROM SalesLT.Product;

SELECT SellStartDate, -- CONVERT can be used for formatting date and time values when converting to text-based data
    CONVERT(nvarchar(30), SellStartDate) AS ConvertedDate,
    CONVERT(nvarchar(30), SellStartDate, 126) AS ISO8601FormatDate
FROM SalesLT.Product;

SELECT Name, TRY_CAST(Size AS Integer) AS NumericSize -- TRY_CAST function for sizes that are not numeric (S, M, or L)
FROM SalesLT.Product;

-- Handle NULL values
SELECT ProductNumber, ISNULL(Color, '') + ', ' + ISNULL(Size, '') AS ProductDetails -- ISNULL replaces NULL values with a specified literal value
FROM SalesLT.Product;

SELECT Name, NULLIF(Color, 'Multi') AS SingleColor -- NULLIF does the opposite and replaces the value with NULL instead
FROM SalesLT.Product;

SELECT Name, COALESCE(SellEndDate, SellStartDate) AS StatusLastUpdated -- COALESCE return the first non-NULL value
FROM SalesLT.Product;

SELECT Name,
    CASE -- The CASE expression goes through conditions and returns a value when the first condition is met
            WHEN SellEndDate IS NULL THEN 'Currently for sale' -- Like an if/then/else statement
            ELSE 'No longer available' -- If there is no ELSE part and no conditions are true, it returns NULL
        END AS SalesStatus
FROM SalesLT.Product;

SELECT Name,
    CASE Size -- Two CASE variants, simple CASE (one specific column/value) and searched CASE (one or more expressions)
            WHEN 'S' THEN 'Small'
            WHEN 'M' THEN 'Medium'
            WHEN 'L' THEN 'Large'
            WHEN 'XL' THEN 'Extra-Large'
            ELSE ISNULL(Size, 'n/a')
        END AS ProductSize
FROM SalesLT.Product;


-- Challenge 1: Retrieve customer data
SELECT *
FROM SalesLT.Customer;

SELECT FirstName, MiddleName, LastName, Suffix
FROM SalesLT.Customer;
SELECT SalesPerson, Title + ' ' + LastName AS CustomerName, Phone
FROM SalesLT.Customer;


-- Challenge 2: Retrieve customer order data
SELECT *
FROM SalesLT.SalesOrderHeader;

-- Retrieve a list of customer companies:
SELECT CAST(CustomerID AS varchar(5)) + ': ' + CompanyName AS Company
FROM SalesLT.Customer; -- Company: 78: Preferred Bikes

-- Retrieve a list of sales order revisions:
SELECT SalesOrderNumber + ' (' + STR(RevisionNumber, 1) + ')' AS OrderRevision, -- OrderRevision: 5071774 (2)
    CONVERT(nvarchar(30), OrderDate, 102) AS OrderDate -- OrderDate: 2008.06.01
FROM SalesLT.SalesOrderHeader;


-- Challenge 3: Retrieve customer contact details
SELECT *
FROM SalesLT.Customer;

-- Remove existing email addresses for some records:
UPDATE SalesLT.Customer
    SET EmailAddress = NULL
    WHERE CustomerID % 7 = 1;

-- Retrieve customer contact names with middle names if known:
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS CustomerName
FROM SalesLT.Customer;

-- Retrieve primary contact details (Method 1):
SELECT LastName,
    CASE
            WHEN EmailAddress IS NULL THEN Phone -- If no email address, show phone number
            ELSE EmailAddress 
        END AS Contact
FROM SalesLT.Customer;

-- Retrieve primary contact details (Method 2):
SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer;

-- Retrieve shipping status:
SELECT *
FROM SalesLT.SalesOrderHeader;

-- Remove ship date for some records:
UPDATE SalesLT.SalesOrderHeader
    SET ShipDate = NULL
    WHERE SalesOrderID > 71899;

-- Retrieve shipping status:
SELECT SalesOrderID, OrderDate,
    CASE 
            WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
            ELSE 'Shipped'
        END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;
