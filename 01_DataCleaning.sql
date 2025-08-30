-- Cleaning Data in SQL Queries for Nashville Housing Data

-- View all data from the Nashville Housing table
SELECT * 
FROM PortfolioProject.dbo.[Nashville Housing];
GO


-- 1. STANDARDIZE DATE FORMAT

-- Convert SaleDate to standard date format (remove time component)
SELECT SaleDate, CONVERT(DATE, SaleDate) AS ConvertedSaleDate
FROM PortfolioProject.dbo.[Nashville Housing];

-- Update the table with standardized date format
UPDATE PortfolioProject.dbo.[Nashville Housing]
SET SaleDate = CONVERT(DATE, SaleDate);


-- 2. POPULATE MISSING PROPERTY ADDRESS DATA

-- Identify records with missing PropertyAddress
SELECT *
FROM PortfolioProject.dbo.[Nashville Housing]
WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

-- Use self-join to populate missing addresses from records with same ParcelID
SELECT 
    a.ParcelID, 
    a.PropertyAddress, 
    b.ParcelID, 
    b.PropertyAddress, 
    ISNULL(a.PropertyAddress, b.PropertyAddress) AS PopulatedAddress
FROM PortfolioProject.dbo.[Nashville Housing] a
JOIN PortfolioProject.dbo.[Nashville Housing] b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

-- Update missing PropertyAddress values
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.[Nashville Housing] a
JOIN PortfolioProject.dbo.[Nashville Housing] b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;


-- 3. BREAK OUT PROPERTY ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY)

-- Extract address components from PropertyAddress
SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS StreetAddress,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM PortfolioProject.dbo.[Nashville Housing];

-- Add new column for split street address
ALTER TABLE PortfolioProject.dbo.[Nashville Housing]
ADD PropertySplitAddress NVARCHAR(255);

-- Populate the new street address column
UPDATE PortfolioProject.dbo.[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

-- Add new column for split city
ALTER TABLE PortfolioProject.dbo.[Nashville Housing]
ADD PropertySplitCity NVARCHAR(255);

-- Populate the new city column
UPDATE PortfolioProject.dbo.[Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));


-- 4. BREAK OUT OWNER ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

-- Use PARSENAME to split OwnerAddress into components
SELECT
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerStreetAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerCity,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerState
FROM PortfolioProject.dbo.[Nashville Housing];

-- Add and populate OwnerSplitAddress column
ALTER TABLE PortfolioProject.dbo.[Nashville Housing]
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

-- Add and populate OwnerSplitCity column
ALTER TABLE PortfolioProject.dbo.[Nashville Housing]
ADD OwnerSplitCity NVARCHAR(255);

UPDATE PortfolioProject.dbo.[Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

-- Add and populate OwnerSplitState column
ALTER TABLE PortfolioProject.dbo.[Nashville Housing]
ADD OwnerSplitState NVARCHAR(255);

UPDATE PortfolioProject.dbo.[Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


-- 5. STANDARDIZE "SOLD AS VACANT" FIELD (CHANGE Y/N TO YES/NO)

-- Check current values and their counts
SELECT 
    SoldAsVacant, 
    COUNT(SoldAsVacant) AS Count
FROM PortfolioProject.dbo.[Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY Count;

-- Update Y/N values to Yes/No using CASE statement
UPDATE PortfolioProject.dbo.[Nashville Housing]
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;


-- 6. REMOVE DUPLICATE RECORDS

-- First, create backup table before removing duplicates
SELECT * 
INTO PortfolioProject.dbo.[Nashville Housing_Backup]
FROM PortfolioProject.dbo.[Nashville Housing];

-- Check how many duplicate records will be removed
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM PortfolioProject.dbo.[Nashville Housing]
)
SELECT COUNT(*) AS RecordsToDelete
FROM RowNumCTE
WHERE row_num > 1;

-- Remove duplicate records
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM PortfolioProject.dbo.[Nashville Housing]
)
DELETE FROM RowNumCTE
WHERE row_num > 1;


-- 7. REMOVE UNUSED COLUMNS

-- Drop original address columns since we have split them into separate columns
ALTER TABLE PortfolioProject.dbo.[Nashville Housing]
DROP COLUMN OwnerAddress, PropertyAddress;

-- View the final cleaned dataset
SELECT *
FROM PortfolioProject.dbo.[Nashville Housing];

------------------------------------------------------------------------------------------
-- SUMMARY OF DATA CLEANING STEPS COMPLETED:
-- 1. Standardized date format for SaleDate
-- 2. Populated missing PropertyAddress values
-- 3. Split PropertyAddress into separate columns (Street Address and City)
-- 4. Split OwnerAddress into separate columns (Street Address, City, and State)
-- 5. Standardized SoldAsVacant field values (Y/N to Yes/No)
-- 6. Removed duplicate records while keeping original data in backup
-- 7. Removed redundant columns that were replaced with split columns
------------------------------------------------------------------------------------------