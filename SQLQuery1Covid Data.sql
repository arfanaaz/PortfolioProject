Select * 
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select * 
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using 

Select location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total cases vs Total deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

-- Looking at Total cases vs Population
-- Shows what percentage of population got covid

Select location, date, total_cases, population,(total_cases/population)*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
--where location like '%states%'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, max(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
--where location like '%states%'
GROUP BY location,population
order by PercentagePopulationInfected desc

-- Showing countries with highest death count per population

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
GROUP BY location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT


-- Showing the continents with highest death count

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
GROUP BY continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not NULL
Group By date
order by 1,2

-- Looking at Total Population vs Vaccinations

Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.Date)
as RollingPeopleVaccinated, --(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 -- USE CTE

 With PopvsVac (Continent,Location,Date,Population,new_vaccinations,RollingPeopleVaccinated)
 as
(
 Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.Date)
as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null


 --order by 2,3
 )
  Select *,(RollingPeopleVaccinated/Population)*100 from PopvsVac

  --TEMP TABLE
  DROP TABLE if exists #PercentPopulationVaccinated

  Create Table #PercentPopulationVaccinated
  (
  Continent nvarchar(255),
  location varchar(255),
  date datetime,
  population numeric,
  New_vaccinations numeric,
  RollingPeopleVaccinated numeric
  )

  Insert into #PercentPopulationVaccinated
   Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.Date)
as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

  Select *, (RollingPeopleVaccinated/Population)*100 
  from #PercentPopulationVaccinated

  --Creating View to store data for later visulaistaion

  Create view PercentPopulationVaccinated as
  Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.Date)
as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select * 
from PercentPopulationVaccinated










