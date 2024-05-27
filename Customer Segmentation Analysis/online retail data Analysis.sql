select * from online_retail;
/*seperating the invoicedate column containes the date and time mixed into 'inovicedate and time column' seperately for better understanding*/
ALTER TABLE online_retail RENAME COLUMN InvoiceDate TO OriginalInvoiceDate;
ALTER TABLE online_retail ADD COLUMN InvoiceDate DATE;
ALTER TABLE online_retail ADD COLUMN Time TIME;
UPDATE online_retail
SET InvoiceDate = OriginalInvoiceDate::DATE,
    Time = OriginalInvoiceDate::TIME;
ALTER TABLE online_retail DROP COLUMN OriginalInvoiceDate;
SELECT InvoiceDate, Time FROM online_retail LIMIT 5;

--1)Distribution of Order Values Across All Customers:
SELECT SUM(Quantity * UnitPrice) AS OrderValue
FROM online_retail;

--2)Number of Unique Products Purchased by Each Customer:
SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProducts
FROM online_retail
GROUP BY CustomerID;

--3)Customers with Only One Purchase:
SELECT CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;

--4)Products Most Commonly Purchased Together:
SELECT StockCode1, StockCode2, COUNT(*) AS Frequency
FROM (
    SELECT
        A.StockCode AS StockCode1,
        B.StockCode AS StockCode2
    FROM online_retail A
    JOIN online_retail B ON A.InvoiceNo = B.InvoiceNo AND A.StockCode < B.StockCode
    WHERE A.CustomerID = B.CustomerID
) AS ProductPairs
GROUP BY StockCode1, StockCode2
ORDER BY Frequency DESC
LIMIT 10;
