--Show all data from the table

SELECT * 
FROM PortfolioProject..['Covid-19 Death']
ORDER BY 3,4 ;

--Selecting the data that will be use

SELECT continent, location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..['Covid-19 Death']
WHERE continent LIKE '%asia%'
ORDER BY 1,2;

--Total Cases vs Total Death

SELECT location, date, total_cases, total_deaths,  (CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 AS Death_Percentage
FROM PortfolioProject..['Covid-19 Death']
WHERE continent LIKE '%asia%'
ORDER BY 1,2;

--Total Cases vs Population

SELECT location, date, population, total_cases, (total_cases/population)*100 AS Percentage_Infection_per_population
FROM PortfolioProject..['Covid-19 Death']
WHERE continent LIKE '%asia%'
ORDER BY 1,2;

--Countries with the Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS Highest_Infection, (MAX(total_cases)/(population))*100 AS Percentage_population_infected
FROM PortfolioProject..['Covid-19 Death']
WHERE continent LIKE '%asia%'
GROUP BY location, population
ORDER BY Percentage_population_infected DESC;

--Countries with the Highest Death Count per Population

SELECT location, population, MAX(cast (total_deaths AS FLOAT)) AS Total_Death_Count
FROM PortfolioProject..['Covid-19 Death']
WHERE continent LIKE '%asia%'
GROUP BY location, population
ORDER BY Total_Death_Count DESC;

--Worldwide Death due to Covid

Select SUM(new_cases) as Total_cases, SUM(CAST(new_deaths AS FLOAT)) AS Total_deaths, SUM(CAST(new_deaths AS FLOAT))/SUM(new_cases)*100 AS Death_percentage
FROM PortfolioProject..['Covid-19 Death']
WHERE continent IS NOT NULL
ORDER BY 1,2;

--Total population vs Vaccination

SELECT Dth.continent, Dth.location, Dth.date, Dth.population, Vac.new_vaccinations 
FROM PortfolioProject..['Covid-19 Death'] AS Dth
JOIN PortfolioProject..['Covid-19 Vaccine'] AS Vac
ON Dth.location = Vac.location
and Dth.date = Vac.date
WHERE Dth.continent LIKE '%asia%'
ORDER BY 2,3;

--Rolling Number of people vaccinated in the continent

SELECT Dth.continent, Dth.location, Dth.date, Dth.population, Vac.new_vaccinations, SUM(CAST(Vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY Dth.location ORDER BY Dth.location, Dth.date) AS Rolling_No_people_vaccinated
FROM PortfolioProject..['Covid-19 Death'] AS Dth
JOIN PortfolioProject..['Covid-19 Vaccine'] AS Vac
ON Dth.location = Vac.location
and Dth.date = Vac.date
WHERE Dth.continent LIKE '%asia%'
ORDER BY 2,3;

--Percentage of Rolling number of people vaccinated

SELECT continent, location, population, new_vaccinations, Rolling_No_people_vaccinated, ((Rolling_No_people_vaccinated)/(population))*100 AS Percentage_population_vaccinated
FROM
(
SELECT Dth.continent, Dth.location, Dth.date, Dth.population, Vac.new_vaccinations, SUM(CAST(Vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY Dth.location ORDER BY Dth.location, Dth.date) AS Rolling_No_people_vaccinated
FROM PortfolioProject..['Covid-19 Death'] AS Dth
JOIN PortfolioProject..['Covid-19 Vaccine'] AS Vac
ON Dth.location = Vac.location
and Dth.date = Vac.date
WHERE Dth.continent LIKE '%asia%'
) AS temp
ORDER BY 2 DESC;

