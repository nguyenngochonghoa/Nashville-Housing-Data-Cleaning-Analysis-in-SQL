-- Analyze sales trends by month and year
SELECT
    YEAR(SaleDate) AS Year,
    MONTH(SaleDate) AS Month,
    DATENAME(MONTH, SaleDate) AS MonthName,
    COUNT(*) AS TotalTransactions,
    SUM(SalePrice) AS TotalRevenue,
    AVG(SalePrice) AS AveragePrice,
    MIN(SalePrice) AS MinPrice,
    MAX(SalePrice) AS MaxPrice
FROM PortfolioProject.dbo.[Nashville Housing]
WHERE SaleDate IS NOT NULL AND SalePrice > 0
GROUP BY YEAR(SaleDate), MONTH(SaleDate), DATENAME(MONTH, SaleDate)
ORDER BY Year, Month;

-- Compare property values across different land use types
SELECT
    LandUse,
    COUNT(*) AS PropertyCount,
    AVG(CONVERT(BIGINT, SalePrice)) AS AverageSalePrice,
    AVG(CONVERT(BIGINT, TotalValue)) AS AverageTotalValue,
    AVG(CONVERT(BIGINT, LandValue)) AS AverageLandValue,
    AVG(CONVERT(BIGINT, BuildingValue)) AS AverageBuildingValue,
    AVG(CONVERT(BIGINT, SalePrice)) - AVG(CONVERT(BIGINT, TotalValue)) AS ValueDifference
FROM PortfolioProject.dbo.[Nashville Housing]
WHERE LandUse IS NOT NULL AND SalePrice > 0
GROUP BY LandUse
HAVING COUNT(*) >= 10
ORDER BY AverageSalePrice DESC;

-- Analyze property values by tax district
SELECT
    TaxDistrict,
    COUNT(*) AS PropertyCount,
    AVG(SalePrice) AS AveragePrice,
    AVG(Acreage) AS AverageAcreage,
    AVG(SalePrice/NULLIF(Acreage, 0)) AS PricePerAcre,
    AVG(YearBuilt) AS AverageYearBuilt
FROM PortfolioProject.dbo.[Nashville Housing]
WHERE TaxDistrict IS NOT NULL AND Acreage > 0
GROUP BY TaxDistrict
HAVING COUNT(*) >= 5
ORDER BY AveragePrice DESC;

-- Analyze how property age affects value
SELECT
    CASE
        WHEN (YEAR(GETDATE()) - YearBuilt) <= 10 THEN '0-10 Years'
        WHEN (YEAR(GETDATE()) - YearBuilt) <= 20 THEN '11-20 Years'
        WHEN (YEAR(GETDATE()) - YearBuilt) <= 30 THEN '21-30 Years'
        WHEN (YEAR(GETDATE()) - YearBuilt) <= 40 THEN '31-40 Years'
        ELSE '40+ Years'
    END AS AgeGroup,
    COUNT(*) AS PropertyCount,
    AVG(CONVERT(BIGINT, SalePrice)) AS AveragePrice,
    AVG(CONVERT(BIGINT, TotalValue)) AS AverageValue,
    AVG(CONVERT(BIGINT, SalePrice)) - AVG(CONVERT(BIGINT, TotalValue)) AS AvgPriceValueDiff
FROM PortfolioProject.dbo.[Nashville Housing]
WHERE YearBuilt IS NOT NULL AND YearBuilt >= 1900
    AND SalePrice > 0 AND TotalValue > 0
GROUP BY CASE
    WHEN (YEAR(GETDATE()) - YearBuilt) <= 10 THEN '0-10 Years'
    WHEN (YEAR(GETDATE()) - YearBuilt) <= 20 THEN '11-20 Years'
    WHEN (YEAR(GETDATE()) - YearBuilt) <= 30 THEN '21-30 Years'
    WHEN (YEAR(GETDATE()) - YearBuilt) <= 40 THEN '31-40 Years'
    ELSE '40+ Years'
END
ORDER BY MIN(YearBuilt);

-- How number of rooms affects property value
SELECT
    Bedrooms,
    FullBath,
    HalfBath,
    COUNT(*) AS PropertyCount,
    AVG(CONVERT(BIGINT, SalePrice)) AS AveragePrice,
    AVG(SalePrice/NULLIF(Bedrooms, 0)) AS PricePerBedroom,
    AVG(SalePrice/NULLIF((FullBath + HalfBath*0.5), 0)) AS PricePerBathroom,
    AVG(TotalValue) AS AverageTotalValue
FROM PortfolioProject.dbo.[Nashville Housing]
WHERE Bedrooms > 0 AND FullBath > 0 AND SalePrice > 0
GROUP BY Bedrooms, FullBath, HalfBath
HAVING COUNT(*) >= 5
ORDER BY AveragePrice DESC;

-- Identify potential investment opportunities
SELECT 
    LandUse,
    COUNT(*) AS DealCount,
    AVG(ReturnPercentage) AS AvgDiscountPercent
FROM (
    SELECT
        LandUse,
        ROUND(((SalePrice - TotalValue)/NULLIF(TotalValue, 0)) * 100, 2) AS ReturnPercentage
    FROM PortfolioProject.dbo.[Nashville Housing]
    WHERE SalePrice > 0 AND TotalValue > 0 AND (SalePrice - TotalValue) < 0
) t
GROUP BY LandUse
ORDER BY AvgDiscountPercent ASC;

-- Analyze seasonal patterns in real estate
SELECT
    DATEPART(QUARTER, SaleDate) AS Quarter,
    CASE DATEPART(QUARTER, SaleDate)
        WHEN 1 THEN 'Spring'
        WHEN 2 THEN 'Summer'
        WHEN 3 THEN 'Fall'
        WHEN 4 THEN 'Winter'
    END AS Season,
    COUNT(*) AS TotalSales,
    SUM(SalePrice) AS TotalRevenue,
    AVG(SalePrice) AS AveragePrice,
    MIN(SaleDate) AS FirstSaleDate,
    MAX(SaleDate) AS LastSaleDate
FROM PortfolioProject.dbo.[Nashville Housing]
WHERE SaleDate IS NOT NULL AND SalePrice > 0
GROUP BY DATEPART(QUARTER, SaleDate)
ORDER BY Quarter;