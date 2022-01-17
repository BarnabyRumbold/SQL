-- checking data after input - removing continent and country column confusion
Select * from PortfolioProject..CovidDeaths
where continent is not null 
order by 3, 4

-- Select * from PortfolioProject..CovidVaccinations
-- order by 3, 4

-- Select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1, 2

-- Looking at Total Cases vs Total Deaths in Germany, estimation of liklihood of death based on cases

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
From PortfolioProject..CovidDeaths
Where location like '%Germany%'
Order by 1, 2

-- Looking at Total Cases vs Total Deaths in Afghanistan

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
From PortfolioProject..CovidDeaths
Where location like '%Afghanistan%'
Order by 1, 2

-- Looking at Total Cases vs Total Deaths in England
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
From PortfolioProject..CovidDeaths
Where location like '%united kingdom%'
Order by 1, 2

-- Total cases vs population
-- Show what percentage of population contracted Covid-19

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- where location like '%united kingdom%'
order by 1, 2

-- looking at countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- where location like '%united kingdom%'
group by Location, Population
order by PercentPopulationInfected desc

-- showing countries with highest death count per population
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- where location like '%united kingdom%'
where continent is not null
group by Location
order by TotalDeathCount desc

-- looking at the same but by continent

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- where location like '%united kingdom%'
where continent is null 
group by location
order by TotalDeathCount desc

-- cleaning data to show only continents

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- where location like '%united kingdom%'
Where location in ('Europe', 'Asia', 'North America', 'South America', 'European Union', 'Africa', 'Oceania')
and continent is null 
group by location
order by TotalDeathCount desc


-- showing only Europe

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- where location like '%united kingdom%'
where continent = 'Europe' -- 'Asia', 'North America', 'European Union', 'Africa', 'Oceania')
group by location
order by TotalDeathCount desc

-- Global Numbers for death percentage

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
--Group by date
order by 1, 2

-- Save this as a variable

Declare @globaldeathpercentage as float;
Set @globaldeathpercentage=1.68369


-- Compare global death percentage to UK death percentage

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location = ('United Kingdom')
--Group by date
order by 1, 2

-- save as a variable 

Declare @ukdeathpercentage as float;
Set @ukdeathpercentage=0.99722

-- look at covid vaccinations table using joins

Select* 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

-- Look at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
	order by 2,3

-- Using a CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

