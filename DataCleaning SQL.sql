/*
Cleaning Data in SQL Queries
*/


Select * 
From [Portfolio Project]..Sheet1$


-- Standardize Date Format


Select SaleDateConverted, Convert(Date,saleDate)
From [Portfolio Project]..Sheet1$

Update Sheet1$
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER Table Sheet1$
Add SaleDateConverted Date;

Update Sheet1$
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

-- Looking for Blank or Null entries on the Property Addess entires 
Select PropertyAddress
From [Portfolio Project]..Sheet1$
where PropertyAddress is null

-- 1
-- Locate all data where Property Address is Null
Select *
From [Portfolio Project]..Sheet1$
where PropertyAddress is null

--2
-- Locate the parcelID which often is similar to other entries 
Select *
From [Portfolio Project]..Sheet1$
Order by ParcelID

--3 
-- As we have found there are the same ParcelIDs within the data, with populated Property Address fields.
-- But some colunms seems to be Null.
-- Using a Join statement we can populate theses fields with the correct data.

-- I start by finding the same ParcelID.
-- Where NullFields is the colunms with NULL data and PopulatedFields is colunms with populated data 
Select NullFields.ParcelID, NullFields.PropertyAddress, PopulatedFields.ParcelID, PopulatedFields.PropertyAddress
From [Portfolio Project]..Sheet1$ NullFields
JOIN [Portfolio Project]..Sheet1$ PopulatedFields
	on NullFields.ParcelID = PopulatedFields.ParcelID
	AND NullFields.[UniqueID ] <> PopulatedFields.[UniqueID ]
Where NullFields.PropertyAddress is null


--Next I add 'ISNULL' data attribute ready for updating the respective columns 
Select NullFields.ParcelID, NullFields.PropertyAddress, PopulatedFields.ParcelID, PopulatedFields.PropertyAddress, ISNULL(NullFields.PropertyAddress, PopulatedFields.PropertyAddress)
From [Portfolio Project]..Sheet1$ NullFields
JOIN [Portfolio Project]..Sheet1$ PopulatedFields
	on NullFields.ParcelID = PopulatedFields.ParcelID
	AND NullFields.[UniqueID ] <> PopulatedFields.[UniqueID ]
Where NullFields.PropertyAddress is null


-- Update the NULL Property Address columns with the new populated Property Address data
Update NullFields
SET PropertyAddress = ISNULL(NullFields.PropertyAddress, PopulatedFields.PropertyAddress)
From [Portfolio Project]..Sheet1$ NullFields
JOIN [Portfolio Project]..Sheet1$ PopulatedFields
	on NullFields.ParcelID = PopulatedFields.ParcelID
	AND NullFields.[UniqueID ] <> PopulatedFields.[UniqueID ]
Where NullFields.PropertyAddress is null

-- Then I rerun the above code to see if the update has worked. The table has been updated with the new data. 