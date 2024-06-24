

/* Cleaning Data in SQL Queries */
SELECT * FROM Housing_data.`nashville housing data for data cleaning`;

-- ------------------------------------------------------------------------------------------------------------------------
-- Standardize SalesDate Format

SET SQL_SAFE_UPDATES = 0;
UPDATE Housing_data.`nashville housing data for data cleaning`
SET SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y')
WHERE UniqueID <> 0;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM Housing_data.`nashville housing data for data cleaning`;



-- ------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Housing_data.`nashville housing data for data cleaning`
-- Where PropertyAddress is null
order by ParcelID; 

SELECT 
    PropertyAddress,
    SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) as AddressPart1,
    SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) as AddressPart2
FROM 
    Housing_data.`nashville housing data for data cleaning`;



ALTER TABLE Housing_data.`nashville housing data for data cleaning`
Add PropertySplitAddress Nvarchar(255);

SET SQL_SAFE_UPDATES = 0;
Update Housing_data.`nashville housing data for data cleaning`
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Housing_data.`nashville housing data for data cleaning`
Add PropertySplitCity Nvarchar(255);

SET SQL_SAFE_UPDATES = 0;
Update Housing_data.`nashville housing data for data cleaning`
SET PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress)+1 );
SET SQL_SAFE_UPDATES = 1;

Select PropertyAddress, PropertySplitAddress, PropertySplitCity
From Housing_data.`nashville housing data for data cleaning`;



SELECT 
    OwnerAddress,
    SUBSTRING(OwnerAddress, 1, LOCATE(',', OwnerAddress) - 1) as AddressPart1,
    SUBSTRING(OwnerAddress, LOCATE(',', OwnerAddress) + 1) as AddressPart2
FROM 
    Housing_data.`nashville housing data for data cleaning`;


SELECT 
    OwnerAddress,
    SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Part1,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS Part2,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1)) AS Part3
FROM 
        Housing_data.`nashville housing data for data cleaning`;



ALTER TABLE Housing_data.`nashville housing data for data cleaning`
Add OwnerSplitAddress Nvarchar(255);

SET SQL_SAFE_UPDATES = 0;
Update Housing_data.`nashville housing data for data cleaning`
SET OwnerSplitAddress =  SUBSTRING_INDEX(OwnerAddress, ',', 1);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Housing_data.`nashville housing data for data cleaning`
Add OwnerSplitState Nvarchar(255);

SET SQL_SAFE_UPDATES = 0;
Update Housing_data.`nashville housing data for data cleaning`
SET OwnerSplitState =  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));
SET SQL_SAFE_UPDATES = 1;


ALTER TABLE Housing_data.`nashville housing data for data cleaning`
Add OwnerSplitCity Nvarchar(255);

SET SQL_SAFE_UPDATES = 0;
Update Housing_data.`nashville housing data for data cleaning`
SET OwnerSplitCity =  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1)) ;
SET SQL_SAFE_UPDATES = 1;

SELECT 
    OwnerAddress,
    OwnerSplitAddress,
    OwnerSplitState,
    OwnerSplitCity
FROM 
        Housing_data.`nashville housing data for data cleaning`;
        
        
-- ------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT * FROM Housing_data.`nashville housing data for data cleaning`;

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Housing_data.`nashville housing data for data cleaning`
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='Y' THEN 'Yes'
	 WHEN SoldAsVacant='N' THEN 'No'
     ELSE SoldAsVacant
     END
FROM Housing_data.`nashville housing data for data cleaning`;


SET SQL_SAFE_UPDATES = 0;
Update Housing_data.`nashville housing data for data cleaning`
SET SoldAsVacant= CASE WHEN SoldAsVacant='Y' THEN 'Yes'
	 WHEN SoldAsVacant='N' THEN 'No'
     ELSE SoldAsVacant
     END; 
     
SET SQL_SAFE_UPDATES = 1;
  
     

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Housing_data.`nashville housing data for data cleaning`
GROUP BY SoldAsVacant
ORDER BY 2;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates
SELECT *
FROM Housing_data.`nashville housing data for data cleaning`;

SELECT 
    ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference,
    COUNT(*) as duplicate_count
FROM Housing_data.`nashville housing data for data cleaning`
GROUP BY 
   ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
HAVING 
    COUNT(*) > 1;


SET SQL_SAFE_UPDATES = 0;
WITH DuplicateCTE AS (
    SELECT 
        ParcelID,
        PropertyAddress,
        SalePrice,
        SaleDate,
        LegalReference,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference 
            ORDER BY ParcelID
        ) as row_num
    FROM Housing_data.`nashville housing data for data cleaning`
)
DELETE FROM Housing_data.`nashville housing data for data cleaning`
WHERE ParcelID IN (
    SELECT ParcelID 
    FROM DuplicateCTE 
    WHERE row_num > 1
);

SET SQL_SAFE_UPDATES = 1;


SELECT *
FROM Housing_data.`nashville housing data for data cleaning`;


SELECT 
    ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference,
    COUNT(*) as duplicate_count
FROM Housing_data.`nashville housing data for data cleaning`
GROUP BY 
   ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
HAVING 
    COUNT(*) > 1;



-- -------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

SELECT *
FROM Housing_data.`nashville housing data for data cleaning`;

ALTER TABLE Housing_data.`nashville housing data for data cleaning`
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;

SELECT *
FROM Housing_data.`nashville housing data for data cleaning`;



















