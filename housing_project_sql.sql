/*
Cleaning Data in SQL Queries
*/


Select *
From NasvilleHousingProject

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From NasvilleHousingProject


Update NasvilleHousingProject
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NasvilleHousingProject
Add SaleDateConverted Date;

Update NasvilleHousingProject
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From NasvilleHousingProject
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NasvilleHousingProject a
JOIN NasvilleHousingProject b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NasvilleHousingProject a
JOIN NasvilleHousingProject b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NasvilleHousingProject
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From NasvilleHousingProject


ALTER TABLE NasvilleHousingProject
Add PropertySplitAddress Nvarchar(255);

Update NasvilleHousingProject
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NasvilleHousingProject
Add PropertySplitCity Nvarchar(255);

Update NasvilleHousingProject
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From NasvilleHousingProject




Select OwnerAddress
From NasvilleHousingProject


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NasvilleHousingProject



ALTER TABLE NasvilleHousingProject
Add OwnerSplitAddress Nvarchar(255);

Update NasvilleHousingProject
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NasvilleHousingProject
Add OwnerSplitCity Nvarchar(255);

Update NasvilleHousingProject
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NasvilleHousingProject
Add OwnerSplitState Nvarchar(255);

Update NasvilleHousingProject
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From NasvilleHousingProject




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NasvilleHousingProject
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NasvilleHousingProject


Update NasvilleHousingProject
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NasvilleHousingProject
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From NasvilleHousingProject




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From NasvilleHousingProject


ALTER TABLE NasvilleHousingProject
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From NasvilleHousingProject
