# Global Companies Layoffs

## Introduction
This project focuses on cleaning and analyzing layoffs data. The dataset provides information about layoffs including company names, locations, industries, total layoffs, percentages, dates, stages, countries, and funds raised.

## Dataset
- **Dataset Name**: Layoffs Dataset
- **Source**: [Kaggle - Layoffs](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

## SQL Queries

### Step 1: Data Cleaning
1. **Create Staging Table**: A staging table `layoffs_staging` is created to work with raw data.
2. **Remove Duplicates**: Duplicates are identified based on company, location, industry, total layoffs, percentage layoffs, date, stage, country, and funds raised. Duplicates are deleted from the staging table.
3. **Standardize Data**: Null and empty values in the industry column are filled. Data types are converted appropriately.
4. **Look at Null Values**: Null values in location, company, total layoffs, percentage layoffs, date, stage, and country columns are identified and addressed.
5. **Look for Misspellings**: Unique values in the country, industry, and stage columns are reviewed for misspellings.

### Exploratory Data Analysis
1. **Identify Largest Layoffs**: Maximum total layoffs and percentage layoffs are identified.
2. **Companies with 100% Layoffs**: Companies with 100% layoffs are identified.
3. **Largest Layoffs by Companies**: Companies with the largest layoffs are identified.
4. **Date Range of Data**: The date range of the data is identified.
5. **Largest Layoffs by Industries**: Industries with the largest layoffs are identified.
6. **Largest Layoffs by Countries**: Countries with the largest layoffs are identified.
7. **Largest Layoffs by Years**: Total layoffs are aggregated by year.
8. **Layoffs by Months**: Total layoffs are aggregated by month.
9. **Rolling Total Layoffs by Months**: Rolling total layoffs are calculated by month.
10. **Layoffs by Company/Year**: Total layoffs are aggregated by company and year.
11. **Top 5 Biggest Layoffs by Company/Year**: The top 5 companies with the largest layoffs each year are identified.
