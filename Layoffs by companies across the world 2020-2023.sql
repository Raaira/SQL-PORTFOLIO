select *
from world_layoffs.layoffs_sql;

-- 1. Creating a work table

CREATE TABLE layoffs_working
LIKE layoffs_sql;


insert layoffs_working
select *
from world_layoffs.layoffs_sql;

select *
from world_layoffs.layoffs_working;


-- 2. REMOVING DUPLICATES

select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)as row_num
from world_layoffs.layoffs_working;

with duplicate_cte as
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions)as row_num
from world_layoffs.layoffs_working
)

select *
from duplicate_cte
where row_num > 1;


select *
from layoffs_working
where company = 'Yahoo';

CREATE TABLE `layoffs_working2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert layoffs_working2
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)as row_num
from world_layoffs.layoffs_working;

select *
from layoffs_working2
where row_num > 1;

delete
from layoffs_working2
where row_num = 2;

select *
from layoffs_working2;

-- 3. Standardizing data

select company, Trim(company)
from layoffs_working2;

update layoffs_working2
set company = Trim(company);

select distinct (industry)
from layoffs_working2
order by 1;

select *
from layoffs_working2
where industry like 'crypto%';

update layoffs_working2
set industry = 'crypto'
where industry like 'crypto%';

select distinct (location)
from layoffs_working2
order by 1;

select distinct (country)
from layoffs_working2
order by 1;

update layoffs_working2
set country = 'United States'
where country like 'United States.%';

select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_working2;

update layoffs_working2
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_working2
modify column `date` date;

-- 4. Populating data

select *
from layoffs_working2
where industry is null
or industry = '';

select *
from layoffs_working2
where company like 'AirBnB%';

select *
from layoffs_working2 t1
join layoffs_working2 t2
	on t1.company = t2.company
	 and  t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

select t1.industry , t2.industry
from layoffs_working2 t1
join layoffs_working2 t2
	on t1.company = t2.company
	 and  t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_working2
set industry = NULL
where industry ='';


update layoffs_working2 t1
join layoffs_working2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null)
and t2.industry is not null;

select *
from layoffs_working2
where company like 'Bally%';

select *
from layoffs_working2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_working2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_working2
drop column row_num;

select *
from layoffs_working2;

-- 5. Exploratory Data Analysis

select max(total_laid_off),max(percentage_laid_off)
from layoffs_working2;

select company, sum(percentage_laid_off) as Sum_Percentage_LaidOff
from layoffs_working2
-- where sum(percentage_laid_off) is not null
group by company
order by 2 asc;

with Rolling_Percentage_LaidOff as
(select company, sum(percentage_laid_off) as Sum_Percentage_LaidOff
from layoffs_working2
group by company
order by 2 asc
)
select company, Sum_Percentage_LaidOff, sum(Sum_Percentage_LaidOff) over (order by company) as Rolling_Percentage_Total
from Rolling_Percentage_LaidOff
where Sum_Percentage_LaidOff is not null;

select *
from layoffs_working2
where percentage_laid_off =1;

select count(percentage_laid_off)
from layoffs_working2
where percentage_laid_off =1;

select *
from layoffs_working2
where total_laid_off =12000;

select company, sum(total_laid_off)
from layoffs_working2
group by company
order by 2 asc;

select min(date),max(date)
from layoffs_working2;

select industry, sum(total_laid_off)
from layoffs_working2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_working2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_working2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_working2
group by stage
order by 1 desc;

select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_working2
where substring(`date`,1,7) is not null
Group by `Month`
order by 1 asc;

with Rolling_Total as
(
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_working2
where substring(`date`,1,7) is not null
Group by `Month`
order by 1 asc
)
select `Month`,total_off, sum(total_off) over(order by `Month`) as rolling_total
from Rolling_Total;

select company, year(`date`), sum(total_laid_off)
from layoffs_working2
group by company , year(`date`)
order by 3 desc;

-- Looking at the year by year ranking of company laid offs

with Company_Year (company, years, total_laid_off) AS
(select company, year(`date`), sum(total_laid_off)
from layoffs_working2
group by company , year(`date`)
), Company_Year_Rank AS
(select *,
dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from  Company_Year
where years is not null
)
SELECT *
FROM Company_Year_Rank
WHERE RANKING <= 5;



select *
from layoffs_working2;




