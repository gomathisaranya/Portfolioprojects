
-- Cleaning Data in SQL Queries*/

select * from projects.nashvilehousing;

select count(UniqueID) from projects.nashvilehousing;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From projects.nashvilehousing;

select PropertyAddress, substring_index(PropertyAddress, ',' ,1 )as PropertsplitAddress,
substring_index(PropertyAddress, ',' ,-1 )as PropertsplitCity
from projects.nashvilehousing;

ALTER TABLE
projects.nashvilehousing
ADD PropertsplitAddress NVARCHAR(255);

UPDATE projects.nashvilehousing
SET PropertsplitAddress = substring_index(PropertyAddress, ',' ,1 );

ALTER TABLE
projects.nashvilehousing
ADD PropertsplitCity NVARCHAR(255);

UPDATE projects.nashvilehousing
SET PropertsplitCity=substring_index(PropertyAddress, ',' ,-1 );

SELECT OwnerAddress from projects.nashvilehousing;

select OwnerAddress, substring_index(OwnerAddress, ',' ,1 )as OwnersplitAddress,
substring_index(substring_index(OwnerAddress, ',' ,-2),',',1) as OwnertsplitCity,
substring_index(OwnerAddress, ',' ,-1)as OwnertsplitState
from projects.nashvilehousing;

ALTER TABLE
projects.nashvilehousing
ADD OwnersplitAddress NVARCHAR(255);

UPDATE projects.nashvilehousing
SET OwnersplitAddress=substring_index(OwnerAddress, ',' ,1 );

ALTER TABLE
projects.nashvilehousing
ADD OwnertsplitCity NVARCHAR(255);

UPDATE projects.nashvilehousing
SET OwnertsplitCity=substring_index(substring_index(OwnerAddress, ',' ,-2),',',1);

ALTER TABLE
projects.nashvilehousing
ADD OwnertsplitState NVARCHAR(255);

UPDATE projects.nashvilehousing
SET OwnertsplitState=substring_index(OwnerAddress, ',' ,-1);

-------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

select * from projects.nashvilehousing;

select distinct(SoldAsVacant), count(SoldAsVacant) from projects.nashvilehousing 
group by SoldAsVacant
ORDER BY 2;

SELECT  SoldAsVacant,
CASE WHEN Soldasvacant='Y' THEN 'YES'
	 WHEN Soldasvacant ='N' THEN 'NO'
	 ELSE Soldasvacant
END
from projects.nashvilehousing
ORDER BY 1;

UPDATE projects.nashvilehousing 
SET Soldasvacant=
CASE WHEN Soldasvacant='Y' THEN 'YES'
	 WHEN Soldasvacant ='N' THEN 'NO'
	 ELSE Soldasvacant
END;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
-- A) IDENTIFYING NO OF DUPLICATES 44 ROWS IN TEMP TABLE

WITH RowNumCTE AS
( Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 
					) row_num
From projects.nashvilehousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

-- B)DELETING THOSE DUPLICATE 44 ROWS IN TEMP TABLE


WITH RowNumCTE AS
( Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				
					) row_num
From projects.nashvilehousing
)
DELETE 
From RowNumCTE
Where row_num > 1
 ;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From projects.nashvilehousing;


ALTER TABLE projects.nashvilehousing
DROP COLUMN PropertyAddress;






