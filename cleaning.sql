-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022


SELECT * 
FROM layoffs;



-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens
CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging 
SELECT * FROM layoffs;


-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what can be filled
-- 4. Lool for mosspelling and fix them



-- 1. Remove Duplicates

# First let's check for duplicates



SELECT *
FROM layoffs_staging;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		layoffs_staging;


SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`, country,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`, country
			) AS row_num
	FROM 
		layoffs_staging
) duplicates
WHERE 
	row_num > 1;
    
-- let's just look at oda to confirm
SELECT *
FROM layoffs_staging
WHERE company = 'Oda';
-- it looks like these are all legitimate entries and shouldn't be deleted. We need to really look at every single row to be accurate

-- these are our real duplicates 
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
			) AS row_num
	FROM 
		layoffs_staging
) duplicates
WHERE 
	row_num > 1;

-- these are the ones we want to delete where the row number is > 1 or 2or greater essentially

-- now you may want to write it like this:
WITH DELETE_CTE AS 
(
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
			) AS row_num
	FROM 
		layoffs_staging
) duplicates
WHERE 
	row_num > 1
)
DELETE
FROM DELETE_CTE;

ALTER TABLE layoffs_staging ADD row_num INT;


SELECT *
FROM layoffs_staging;

CREATE TABLE `world_layoffs`.`layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised` int,
row_num INT
);

INSERT INTO `world_layoffs`.`layoffs_staging2`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised
			) AS row_num
	FROM 
		layoffs_staging;

-- now that we have this we can delete rows were row_num is greater than 2

DELETE FROM layoffs_staging2
WHERE row_num >= 2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * FROM layoffs_staging2;



-- 2. Standardize Data

SELECT * 
FROM layoffs_staging2;

-- if we look at industry it looks like we have some null and empty rows, let's take a look at these
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- let's take a look at these
SELECT *
FROM layoffs_staging2
WHERE company = 'Appsmith';

-- it looks like airbnb is a product, so lets fill missing industry type for th

UPDATE layoffs_staging2
SET industry = 'Product'
WHERE company = 'Appsmith';

-- let's check our changes
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- now we can convert the data type properly
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM layoffs_staging2;





-- 3. Look at Null Values

SELECT * FROM layoffs_staging2
WHERE location IS NULL OR location = '';

SELECT * FROM layoffs_staging2
WHERE company IS NULL OR company = '';

SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL OR total_laid_off = '';

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off IS NULL OR percentage_laid_off = '';

SELECT * FROM layoffs_staging2
WHERE `date` IS NULL;

SELECT * FROM layoffs_staging2
WHERE stage IS NULL OR stage = '';

-- looks like Verily has no stage. Let's fix this

UPDATE layoffs_staging2
SET stage = 'Private Equity'
WHERE company = 'Verily';

-- let's check results

SELECT * FROM layoffs_staging2
WHERE stage IS NULL OR stage = '';


SELECT * FROM layoffs_staging2
WHERE country IS NULL OR country = '';


-- Look for misspelling

SELECT DISTINCT country FROM layoffs_staging2 ORDER BY 1;

SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1;

SELECT DISTINCT stage FROM layoffs_staging2 ORDER BY 1;

-- Results

SELECT * FROM layoffs_staging2;