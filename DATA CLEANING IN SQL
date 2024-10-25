SELECT *
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']

--SEPERATION OF TIME FROM THE 'SaleDate' COLUMN AND ADDING THE DATE DATA TO THE TABLE

SELECT SaleDate, CONVERT(date,SaleDate) SaleDateConverted
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']


ALTER TABLE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
ADD SaleDateConverted Date;

UPDATE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
SET SaleDateConverted = CONVERT(date,saledate)


--POPULATING THE ROWS IN PropertyAddress COLUMN THAT HAS NULL DATA

SELECT [UniqueID ], ParcelID, PropertyAddress
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
--WHERE ParcelID LIKE '%026 05 0 017.00%'
WHERE PropertyAddress is Null
ORDER BY ParcelID

select A.ParcelID, A.PROPERTYADDRESS, B.ParcelID, B.PROPERTYADDRESS, ISNULL(A.PROPERTYADDRESS,B.PROPERTYADDRESS)
from [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$'] A
join [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$'] B
	on A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
where A.propertyaddress is null

UPDATE A
SET PropertyAddress = ISNULL(A.PROPERTYADDRESS,B.PROPERTYADDRESS)
from [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$'] A
join [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$'] B
	on A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
where A.propertyaddress is null

--REMOVING THE STATES AND CITIES FROM THE 'PROPERTY ADRESS' COLUMN

SELECT PropertyAddress
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']

SELECT
SUBSTRING (PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1) 
, SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , len(PropertyAddress)) 
from [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']

ALTER TABLE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
ADD PropertySplitAddress nvarchar(255)

UPDATE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
Set PropertySplitAddress = SUBSTRING (PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
ADD PropertySplitCity nvarchar(255)

UPDATE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , len(PropertyAddress)) 


--REMOVING THE STATES AND CITIES FROM THE 'OWNER ADRESS' COLUMN

SELECT OwnerAddress
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']

select
parsename(replace(OwnerAddress, ',','.'),3),
parsename(replace(OwnerAddress, ',','.'),2),
parsename(replace(OwnerAddress, ',','.'),1)
from [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']

ALTER TABLE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
ADD OwnerSplitState nvarchar(255)

UPDATE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
Set OwnerSplitState = parsename(replace(OwnerAddress, ',','.'),1)

--POPULATING THE ROWS IN OwnerSplitState COLUMN THAT HAS NULL DATA

SELECT [UniqueID ], ParcelID, OwnerSplitState
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
--WHERE ParcelID LIKE '%007 14 0A 027.00%'
WHERE OwnerSplitState is Null
ORDER BY ParcelID

SELECT ParcelID,
CASE when OwnerSplitState IS NULL THEN 'TN'
	ELSE OwnerSplitState
	END
	AS OwnerSplitState
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']

UPDATE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
SET OwnerSplitState = CASE when OwnerSplitState IS NULL THEN 'TN'
	ELSE OwnerSplitState
	END

SELECT SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'NO'
	ELSE SoldAsVacant
	END
from [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']	

Update [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
Set SoldAsVacant =case 
					when SoldAsVacant = 'Y' then 'Yes'
					when SoldAsVacant = 'N' then 'NO'
					ELSE SoldAsVacant
					END

-- DELETING DUPLICATE DATA.

WITH TEMP_TABLE AS(
SELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY PARCELID,
				PROPERTYADDRESS,
				SALEDATE,
				LEGALREFERENCE
				ORDER BY
					UNIQUEID
					) TEMPTABLE
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
)

SELECT *
	FROM TEMP_TABLE
WHERE TEMPTABLE >1
ORDER BY PropertyAddress

WITH TEMP_TABLE AS(
SELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY PARCELID,
				PROPERTYADDRESS,
				SALEDATE,
				LEGALREFERENCE
				ORDER BY
					UNIQUEID
					) TEMPTABLE
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
)

DELETE
	FROM TEMP_TABLE
WHERE TEMPTABLE >1

--DELETING UNUSED COLUMNS
ALTER TABLE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,SaleDate


-- EDITING SPACES OUT
SELECT OwnerSplitState, Trim(OwnerSplitState) OwnerState
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']


ALTER TABLE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
ADD OwnerState nvarchar(255)

UPDATE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
Set OwnerState = Trim(OwnerSplitState)

--DELETING UNUSED COLUMNS
ALTER TABLE [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']
DROP COLUMN OwnerSplitState

SELECT *
FROM [PORTFOLIO PROJECT].dbo.['Nashville Housing Data research$']

