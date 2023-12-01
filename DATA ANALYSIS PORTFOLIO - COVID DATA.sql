SELECT *
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]

SELECT *
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
WHERE
	continent is null

SELECT *
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
WHERE
	continent is not null

select location, date, total_cases, new_cases, total_deaths, population
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
ORDER BY 1,2

SELECT date, CONVERT(date,date) DateConverted
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]

ALTER TABLE [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
ADD DateConverted DATE;

UPDATE [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
SET DateConverted = CONVERT(date,date)


--WHAT IS THE DEATH PERCENTAGE?

select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) DeathPercentage
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
ORDER BY 1,2

--WHAT ARE THE CHANCES OF DIEING IN NIGERIA WITH COVID?

select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) DeathPercentage
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
where location like '%Nigeria%'
ORDER BY 1,2

--WHAT IS THE PERCENTAGE OF POPULATION AFFECTED BY COVID?

select location, date, total_cases, population, ((total_cases/population)*100) CasesAffectedPercentage
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
ORDER BY 1,2

-- WHAT COUNTRY HAS THE HIGHEST INFECTION RATE?

select location, population, max(total_cases) as HigestInfectionCount, max((total_cases/population)*100) as PercentOfPopulationInfected
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
GROUP by location, population
order by PercentOfPopulationInfected desc

--WHAT COUNTRY HAS THE HIGHEST DEATH COUNT?
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
WHERE Continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--WHICH CONTINENT HAS THE HIGHEST DEATH COUNT
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
WHERE Continent is null
GROUP BY location
ORDER BY TotalDeathCount desc

--LOOKING AT THE NEW INFECTIONS WITH RESPECT TO DEATHS

select date,  sum(new_cases) as SumNewCases, max(cast(new_deaths as int)) as MaxDeathCounts, ((sum(cast(new_deaths as int))/(sum(new_cases))*100)) AS NewDeathsPercentage
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]
where continent is not null
GROUP by date
order by 1,2 

--INTRODUCING THE SECOND TABLE; COVID VACCINATION TABLE

SELECT *
FROM [PORTFOLIO PROJECT].dbo.[CovidVaccinations$]

-- JOINING THE TWO TABLES TOGETHER
SELECT *
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$] DEA
JOIN [PORTFOLIO PROJECT].dbo.[CovidVaccinations$] VAC
		on DEA.location = VAC.location
		AND DEA.date = VAC.date

--WHAT IS THE TOTAL NEW VACCINATIONS GIVEN TO EACH COUNTRY?

select DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CONVERT(INT,VAC.new_vaccinations)) OVER (PARTITION BY DEA.location) AS Partition
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$] DEA
JOIN [PORTFOLIO PROJECT].dbo.[CovidVaccinations$] VAC
		on DEA.location = VAC.location
		AND DEA.date = VAC.date
WHERE DEA.CONTINENT IS NOT NULL
ORDER BY 2,3

select DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CONVERT(INT,VAC.new_vaccinations)) OVER (PARTITION BY DEA.location ORDER BY DEA.location,dea.date) AS CummulativeSumOfNewVaccinations
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$] DEA
JOIN [PORTFOLIO PROJECT].dbo.[CovidVaccinations$] VAC
		on DEA.location = VAC.location
		AND DEA.date = VAC.date
WHERE DEA.CONTINENT IS NOT NULL
ORDER BY 2,3


-- CREATING A TABLE SHOWING THE CUMMULATIVE SUM OF PEOPLE VACCINATED
WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, CummulativeSumOfNewVaccinations)
AS
	(select DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CONVERT(INT,VAC.new_vaccinations)) OVER (PARTITION BY DEA.location ORDER BY DEA.location,dea.date) AS CummulativeSumOfNewVaccinations
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$] DEA
JOIN [PORTFOLIO PROJECT].dbo.[CovidVaccinations$] VAC
		on DEA.location = VAC.location
		AND DEA.date = VAC.date
WHERE DEA.CONTINENT IS NOT NULL)
SELECT *, (CummulativeSumOfNewVaccinations/Population)*100 as PercentPopulationVaccinated
FROM PopVsVac

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(Continent nvarchar(255), Location nvarchar(255), Date datetime, Population numeric,
New_Vaccination numeric, CummulativeSumOfNewVaccinations numeric)
	
	INSERT INTO #PercentPopulationVaccinated
		select DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
		, SUM(CONVERT(INT,VAC.new_vaccinations)) OVER (PARTITION BY DEA.location ORDER BY DEA.location,dea.date) AS CummulativeSumOfNewVaccinations
		FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$] DEA
		JOIN [PORTFOLIO PROJECT].dbo.[CovidVaccinations$] VAC
			on DEA.location = VAC.location
			AND DEA.date = VAC.date
		WHERE DEA.CONTINENT IS NOT NULL

SELECT *, (CummulativeSumOfNewVaccinations/Population)*100 as PercentPopulationVaccinated
FROM #PercentPopulationVaccinated




SELECT *
FROM [PORTFOLIO PROJECT].dbo.[CovidDeathsResearch$]

