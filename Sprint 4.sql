-- QUery 1.1

SELECT
individual.CustomerID,
contact.FirstName,
contact.LastName,
CONCAT(contact.FirstName,' ', contact.LastName) FULLNAME,
CONCAT('Dear', ' ', contact.LastName) addressing_title,
contact.EmailAddress,
contact.Phone,
customer.AccountNumber,
customer.CustomerType,
address.city,
address.AddressLine1,
stateprovince.name state,
countryregion.name country,
MAX(address.AddressID) AddressID,
COUNT(SalesOrderID) number_orders,
ROUND(SUM(TotalDue), 3) total_amount,
MAX(OrderDate) date_last_order
FROM
`tc-da-1.adwentureworks_db.individual` individual
JOIN
`tc-da-1.adwentureworks_db.contact` contact
ON
contact.ContactID = individual.ContactID
JOIN
`tc-da-1.adwentureworks_db.customer` customer
ON
customer.CustomerID = individual.CustomerID
JOIN
`tc-da-1.adwentureworks_db.customeraddress` customerAddress
ON
customerAddress.CustomerID = customer.CustomerID
JOIN
`tc-da-1.adwentureworks_db.address` address
ON
customerAddress.AddressID = address.AddressID
JOIN
`tc-da-1.adwentureworks_db.stateprovince` stateprovince
ON
address.stateProvinceID = stateprovince.StateProvinceID
JOIN
`tc-da-1.adwentureworks_db.countryregion` countryregion
ON
stateprovince.CountryRegionCode = countryregion.CountryRegionCode
JOIN
`tc-da-1.adwentureworks_db.salesorderheader` salesorderheader
ON
customer.CustomerID = salesorderheader.CustomerID
GROUP BY
1,
2,
3,
4,
5,
6,
7,
8,
9,
10,
11,
12,
13
ORDER BY
total_amount DESC
LIMIT
200

-- QUery 1.2

-- CTE to find the maximum order date, which will act as our current date
WITH MAX_ORDER_DATE AS (
SELECT MAX(OrderDate) AS CurrentDate
FROM `tc-da-1.adwentureworks_db.salesorderheader`
),

-- CTE to get an overview of customers and their order history
OVERVIEW AS (
SELECT
individual.CustomerID,
contact.FirstName,
contact.LastName,
CONCAT(contact.FirstName, ' ', contact.LastName) AS FULLNAME,
CONCAT('Dear', ' ', contact.LastName) AS addressing_title,
contact.EmailAddress,
contact.Phone,
customer.AccountNumber,
customer.CustomerType,
address.city,
address.AddressLine1,
stateprovince.name AS state,
countryregion.name AS country,
COUNT(salesorderheader.SalesOrderID) AS number_orders,
ROUND(SUM(salesorderheader.TotalDue), 3) AS total_amount,
MAX(salesorderheader.OrderDate) AS date_last_order
FROM
`tc-da-1.adwentureworks_db.individual` individual
JOIN
`tc-da-1.adwentureworks_db.contact` contact
ON contact.ContactID = individual.ContactID
JOIN
`tc-da-1.adwentureworks_db.customer` customer
ON customer.CustomerID = individual.CustomerID
JOIN
`tc-da-1.adwentureworks_db.customeraddress` customeraddress
ON customeraddress.CustomerID = customer.CustomerID
JOIN
`tc-da-1.adwentureworks_db.address` address
ON customeraddress.AddressID = address.AddressID
JOIN
`tc-da-1.adwentureworks_db.stateprovince` stateprovince
ON address.stateProvinceID = stateprovince.StateProvinceID
JOIN
`tc-da-1.adwentureworks_db.countryregion` countryregion
ON stateprovince.CountryRegionCode = countryregion.CountryRegionCode
JOIN
`tc-da-1.adwentureworks_db.salesorderheader` salesorderheader
ON customer.CustomerID = salesorderheader.CustomerID
GROUP BY
individual.CustomerID, contact.FirstName, contact.LastName, FULLNAME, addressing_title,
contact.EmailAddress, contact.Phone, customer.AccountNumber, customer.CustomerType, address.city,
address.AddressLine1, state, country
)

-- Main query to find top 200 customers who haven't ordered in the last 365 days
SELECT
OVERVIEW.*
FROM
OVERVIEW OVERVIEW
JOIN
MAX_ORDER_DATE m
ON
OVERVIEW.date_last_order <= TIMESTAMP_SUB(m.CurrentDate, INTERVAL 365 DAY)
ORDER BY
OVERVIEW.total_amount DESC
LIMIT 200;
-- Query 1.3

-- CTE to find the maximum order date, which will act as our current date
WITH MAX_ORDER_DATE AS (
SELECT MAX(OrderDate) AS CurrentDate
FROM `tc-da-1.adwentureworks_db.salesorderheader`
),

-- CTE to get an overview of customers and their order history
OVERVIEW AS (
SELECT
individual.CustomerID customerid,
contact.FirstName,
contact.LastName,
CONCAT(contact.FirstName, ' ', contact.LastName) AS FULLNAME,
CONCAT('Dear', ' ', contact.LastName) AS addressing_title,
contact.EmailAddress,
contact.Phone,
customer.AccountNumber,
customer.CustomerType,
address.city,
address.AddressLine1,
stateprovince.name AS state,
countryregion.name AS country,
COUNT(salesorderheader.SalesOrderID) AS number_orders,
ROUND(SUM(salesorderheader.TotalDue), 3) AS total_amount,
MAX(salesorderheader.OrderDate) AS date_last_order
FROM
`tc-da-1.adwentureworks_db.individual` individual
JOIN
`tc-da-1.adwentureworks_db.contact` contact
ON contact.ContactID = individual.ContactID
JOIN
`tc-da-1.adwentureworks_db.customer` customer
ON customer.CustomerID = individual.CustomerID
JOIN
`tc-da-1.adwentureworks_db.customeraddress` customeraddress
ON customeraddress.CustomerID = customer.CustomerID
JOIN
`tc-da-1.adwentureworks_db.address` address
ON customeraddress.AddressID = address.AddressID
JOIN
`tc-da-1.adwentureworks_db.stateprovince` stateprovince
ON address.stateProvinceID = stateprovince.StateProvinceID
JOIN
`tc-da-1.adwentureworks_db.countryregion` countryregion
ON stateprovince.CountryRegionCode = countryregion.CountryRegionCode
JOIN
`tc-da-1.adwentureworks_db.salesorderheader` salesorderheader
ON customer.CustomerID = salesorderheader.CustomerID
GROUP BY
individual.CustomerID, contact.FirstName, contact.LastName, FULLNAME, addressing_title,
contact.EmailAddress, contact.Phone, customer.AccountNumber, customer.CustomerType, address.city,
address.AddressLine1, state, country
)

-- Main query to find top 500 customers and mark them as active or inactive
SELECT
overview.*,
CASE
WHEN overview.date_last_order > TIMESTAMP_SUB((SELECT CurrentDate FROM MAX_ORDER_DATE), INTERVAL 365 DAY) THEN 'ACTIVE'
ELSE 'INACTIVE'
END AS status
FROM
OVERVIEW overview
ORDER BY
overview.customerid DESC
LIMIT 500;

-- Query 1.4

-- CTE to find the maximum order date, which will act as our current date
WITH MAX_ORDER_DATE AS (
SELECT MAX(OrderDate) AS CurrentDate
FROM `tc-da-1.adwentureworks_db.salesorderheader`
),

-- CTE to get an overview of customers and their order history
OVERVIEW AS (
SELECT
individual.CustomerID AS customerid,
contact.FirstName,
contact.LastName,
CONCAT(contact.FirstName, ' ', contact.LastName) AS FULLNAME,
CONCAT('Dear', ' ', contact.LastName) AS addressing_title,
contact.EmailAddress,
contact.Phone,
customer.AccountNumber,
customer.CustomerType,
address.city,
address.AddressLine1,
stateprovince.name AS state,
countryregion.name AS country,
salesterritory.group AS territory,
COUNT(salesorderheader.SalesOrderID) AS number_orders,
ROUND(SUM(salesorderheader.TotalDue), 3) AS total_amount,
MAX(salesorderheader.OrderDate) AS date_last_order
FROM
`tc-da-1.adwentureworks_db.individual` individual
JOIN
`tc-da-1.adwentureworks_db.contact` contact
ON contact.ContactID = individual.ContactID
JOIN
`tc-da-1.adwentureworks_db.customer` customer
ON customer.CustomerID = individual.CustomerID
JOIN
`tc-da-1.adwentureworks_db.customeraddress` customeraddress
ON customeraddress.CustomerID = customer.CustomerID
JOIN
`tc-da-1.adwentureworks_db.address` address
ON customeraddress.AddressID = address.AddressID
JOIN
`tc-da-1.adwentureworks_db.stateprovince` stateprovince
ON address.stateProvinceID = stateprovince.StateProvinceID
JOIN
`tc-da-1.adwentureworks_db.countryregion` countryregion
ON stateprovince.CountryRegionCode = countryregion.CountryRegionCode
JOIN
`tc-da-1.adwentureworks_db.salesorderheader` salesorderheader
ON customer.CustomerID = salesorderheader.CustomerID
JOIN
`tc-da-1.adwentureworks_db.salesterritory` salesterritory
ON salesterritory.TerritoryID = customer.TerritoryID
GROUP BY
individual.CustomerID, contact.FirstName, contact.LastName, FULLNAME, addressing_title,
contact.EmailAddress, contact.Phone, customer.AccountNumber, customer.CustomerType, address.city,
address.AddressLine1, state, country, territory
)

-- Main query to find top 500 active customers from North America
SELECT
overview.customerid,
overview.FirstName,
overview.LastName,
overview.FULLNAME,
overview.addressing_title,
overview.country,
overview.state,
overview.city,
overview.EmailAddress,
overview.Phone,
overview.AccountNumber,
overview.CustomerType,
overview.total_amount,
overview.number_orders,
overview.date_last_order,
LEFT(overview.AddressLine1, STRPOS(overview.AddressLine1, ' ') - 1) AS address_no,
SUBSTR(overview.AddressLine1, STRPOS(overview.AddressLine1, ' ') + 1) AS Address_st,
CASE
WHEN overview.date_last_order > TIMESTAMP_SUB((SELECT CurrentDate FROM MAX_ORDER_DATE), INTERVAL 365 DAY) THEN 'ACTIVE'
ELSE 'INACTIVE'
END AS status
FROM
OVERVIEW overview
WHERE
overview.territory = 'North America' AND (CASE
WHEN overview.date_last_order >TIMESTAMP_SUB((SELECT CurrentDate FROM MAX_ORDER_DATE), INTERVAL 365 DAY) THEN 'ACTIVE'
ELSE 'INACTIVE'
END) = 'ACTIVE'
AND (overview.total_amount >= 2500 OR overview.number_orders > 5)
ORDER BY
overview.country, overview.state, overview.date_last_order DESC
LIMIT 500;

-- Query 2.1

SELECT
  FORMAT_DATE('%Y-%m', DATE_TRUNC(CAST(salesorderheader.OrderDate AS DATE), MONTH)) AS order_month,
  salesterritory.CountryRegionCode AS country_region_code,
  salesterritory.Name AS country,
  COUNT(salesorderheader.SalesOrderID) AS number_orders,
  COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
  COUNT(DISTINCT salesorderheader.SalesPersonID) AS number_salespersons,
  CAST(SUM(salesorderheader.TotalDue) AS INT64) AS total_with_tax
FROM
  `tc-da-1.adwentureworks_db.salesorderheader` salesorderheader
JOIN
  `tc-da-1.adwentureworks_db.salesterritory` salesterritory
ON
  salesterritory.TerritoryID = salesorderheader.TerritoryID
GROUP BY
  order_month,
  country_region_code,
  country

-- Query 2.2

SELECT
  FORMAT_DATE('%Y-%m', DATE_TRUNC(CAST(salesorderheader.OrderDate AS DATE), MONTH)) AS order_month,
  salesterritory.CountryRegionCode AS country_region_code,
  salesterritory.Name AS country,
  COUNT(salesorderheader.SalesOrderID) AS number_orders,
  COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
  COUNT(DISTINCT salesorderheader.SalesPersonID) AS number_salespersons,
  CAST(SUM(salesorderheader.TotalDue) AS INT64) AS total_with_tax
FROM
  `tc-da-1.adwentureworks_db.salesorderheader` salesorderheader
JOIN
  `tc-da-1.adwentureworks_db.salesterritory` salesterritory
ON
  salesterritory.TerritoryID = salesorderheader.TerritoryID
GROUP BY
  order_month,
  country_region_code,
  country


-- Query 2.3

WITH
  sales_number AS(
  SELECT
    FORMAT_DATE('%Y-%m', DATE_TRUNC(CAST(salesorderheader.OrderDate AS DATE), MONTH)) AS order_month,
    salesterritory.CountryRegionCode AS country_region_code,
    salesterritory.Name AS country,
    COUNT(salesorderheader.SalesOrderID) AS number_orders,
    COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
    COUNT(DISTINCT salesorderheader.SalesPersonID) AS no_salesPersons,
    CAST(SUM(salesorderheader.TotalDue) AS INT64) AS total_with_tax
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` salesorderheader
  JOIN
    `tc-da-1.adwentureworks_db.salesterritory` salesterritory
  ON
    salesterritory.TerritoryID = salesorderheader.TerritoryID
  GROUP BY
    order_month,
    country_region_code,
    country )
SELECT
  sales_number.*,
  SUM(total_with_tax) OVER(ORDER BY sales_number.order_month, country) AS cummulative_sum,
  RANK() OVER(PARTITION BY country ORDER BY total_with_tax DESC) AS country_sales_rank
FROM
  sales_number sales_number
WHERE
  sales_number.country = 'France'

-- Query 2.4

WITH
  sales_number AS (
  SELECT
    FORMAT_DATE('%Y-%m', DATE_TRUNC(CAST(salesorderheader.OrderDate AS DATE), MONTH)) AS order_month,
    salesterritory.CountryRegionCode AS country_region_code,
    salesterritory.Name AS country,
    salesterritory.TerritoryID AS TerritoryID,
    COUNT(salesorderheader.SalesOrderID) AS number_orders,
    COUNT(DISTINCT salesorderheader.CustomerID) AS number_customers,
    COUNT(DISTINCT salesorderheader.SalesPersonID) AS no_salesPersons,
    CAST(SUM(salesorderheader.TotalDue) AS INT64) AS total_with_tax
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` salesorderheader
  JOIN
    `tc-da-1.adwentureworks_db.salesterritory` salesterritory
  ON
    salesterritory.TerritoryID = salesorderheader.TerritoryID
  GROUP BY
    order_month,
    country_region_code,
    country,
    TerritoryID ),
  tax_info AS (
  SELECT
    stateprovince.StateProvinceID,
    stateprovince.CountryRegionCode,
    MAX(salestaxrate.TaxRate) AS max_tax_rate
  FROM
    `tc-da-1.adwentureworks_db.salestaxrate` salestaxrate
  JOIN
    `tc-da-1.adwentureworks_db.stateprovince` stateprovince
  ON
    stateprovince.StateProvinceID = salestaxrate.StateProvinceID
  GROUP BY
    stateprovince.CountryRegionCode,
    stateprovince.StateProvinceID ),
  total_provinces AS (
  SELECT
    stateprovince.CountryRegionCode,
    COUNT(DISTINCT stateprovince.StateProvinceID) AS total_provinces
  FROM
    `tc-da-1.adwentureworks_db.stateprovince` stateprovince
  GROUP BY
    stateprovince.CountryRegionCode ),
  country_tax_info AS (
  SELECT
    tax_info.CountryRegionCode,
    AVG(tax_info.max_tax_rate) AS mean_tax_rate,
    COUNT(tax_info.StateProvinceID) AS provinces_with_tax,
    total_province.total_provinces
  FROM
    tax_info tax_info
  JOIN
    total_provinces total_province
  ON
    tax_info.CountryRegionCode = total_province.CountryRegionCode
  GROUP BY
    tax_info.CountryRegionCode,
    total_province.total_provinces )
SELECT
  sales_number.*,
  SUM(total_with_tax) OVER (ORDER BY total_with_tax DESC) AS cumulative_sum,
  RANK() OVER(PARTITION BY country ORDER BY total_with_tax DESC) AS country_sales_rank,
  ROUND(country_tax_info.mean_tax_rate, 1) mean_tax_rate,
  ROUND(country_tax_info.provinces_with_tax / NULLIF(country_tax_info.total_provinces, 0), 2) AS perc_provinces_w_tax
FROM
  sales_number sales_number
JOIN
  country_tax_info country_tax_info
ON
  sales_number.country_region_code = country_tax_info.CountryRegionCode
WHERE
  sales_number.country_region_code = 'US