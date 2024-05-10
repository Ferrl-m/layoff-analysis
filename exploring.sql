-- Exploratory Data Analysis

-- largest amount and percentage of laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- companies with 100% laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 -- 100%
ORDER BY total_laid_off DESC;

-- sort largest laid off by companies
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- date range of data
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- sort largest laid off by industries
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- sort largest laid off by countries
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- sort largest laid off by years
SELECT YEAR(`date`), SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- laid off by months
SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY `Month`
ORDER BY 1 ASC;

-- rolling total laid off by months
WITH Rolling_Total AS (
SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, total_off,
SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

-- laid off by company/year
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company;

-- 5 biggest laid off by company/year
WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5;
