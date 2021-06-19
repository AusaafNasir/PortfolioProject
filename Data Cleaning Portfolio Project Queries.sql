/*
Cleaning Data in SQL Queries
*/

select *
from NashvilleHousing


-- Standardize Date Format

/* method working temporarily but not storing the results (reason?) on my laptop

Select SaleDate, CONVERT(Date,SaleDate)
From NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

SELECT SaleDate 
From NashvilleHousing

*/

-- Using a different method

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Checking if this works properly

SELECT SaleDateConverted
FROM NashvilleHousing



-- Populate Property Address 


select *
from dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID
 
select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from nashvillehousing a
join nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
set propertyaddress = isnull(a.PropertyAddress, b.PropertyAddress)
from nashvillehousing a
join nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking Out Adrees into individual columns( Adress, City, State)

select PropertyAddress 
from nashvillehousing

select 
substring(propertyaddress, 1 , charindex(',', propertyaddress) - 1) as Address, substring(PropertyAddress, charindex(',', propertyaddress) + 1, len(propertyaddress)) as Address
from nashvillehousing

Alter table nashvillehousing
Add PropertySplitAddress Nvarchar(255)

Update nashvillehousing
set PropertySplitAddress = substring(propertyaddress, 1 , charindex(',', propertyaddress) - 1)

Alter table nashvillehousing
Add PropertySplitCity Nvarchar(255)

Update nashvillehousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', propertyaddress) + 1, len(propertyaddress))

select * 
from nashvillehousing

-- Now split the OwnerAddress

select OwnerAddress
from NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress,',','.') , 3),
PARSENAME(Replace(OwnerAddress,',','.') , 2),
PARSENAME(Replace(OwnerAddress,',','.') , 1)
from NashvilleHousing


Alter table nashvillehousing
Add OwnerSplitAddress Nvarchar(255)

Update nashvillehousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.') , 3)


Alter table nashvillehousing
Add OwnerSplitCity Nvarchar(255)

Update nashvillehousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.') , 2)

Alter table nashvillehousing
Add OwnerSplitState Nvarchar(255)

Update nashvillehousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.') , 1)

select *
from NashvilleHousing


-- Change Y and N to Yes and No respectively in "SoldasVacant" field

select DISTINCT(SoldasVacant), COUNT(SoldAsVacant)
from NashvilleHousing
Group By SoldAsVacant
Order by 2

SELECT Soldasvacant,
CASE When Soldasvacant = 'Y' Then 'Yes'
     When Soldasvacant = 'N' Then 'No'
     ELSE Soldasvacant
     END

from NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When Soldasvacant = 'Y' Then 'Yes'
     When Soldasvacant = 'N' Then 'No'
     ELSE Soldasvacant
     END



-- Remove Duplicates using CTE

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
			) as row_num

From NashvilleHousing
--order by ParcelID
)
/* Checking the number of duplicates
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
*/

Delete 
From RowNumCTE
Where row_num > 1


-- Delete Unused Columns



Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate










