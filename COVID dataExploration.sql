select *
from coviddeaths
order by 3,4;

select location, dated, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2;

-- Looking at Total Cases vs Total Deaths
select location, dated, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
-- where location = 'India'
order by 1,2;

-- Looking at Total Cases Vs Population
select location, population, dated, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from coviddeaths
where location = 'India'
order by 1,2;

-- Looking at Countries with Highest Infection Rate Compared to Population
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from coviddeaths
-- where location = 'India'
group by location, population
order by PercentPopulationInfected desc;

-- Showing countries with Highest Death Count per Population
select location, MAX(total_deaths) as TotalDeathCount
from coviddeaths
-- where location = 'India'
where continent != ''
group by location
order by TotalDeathCount desc;

-- Showing continents with Highest Death Count Per Population
select location, MAX(total_deaths) as TotalDeathCount
from coviddeaths
-- where location = 'India'
where continent = ''
group by location
order by TotalDeathCount desc; 

-- GLOBAL NUMBERS
select dated, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases) * 100 as DeathPercentage
from coviddeaths
where continent != ''
group by dated
order by 1,2;

select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases) * 100 as DeathPercentage
from coviddeaths
where continent != ''
order by 1,2;

-- Introducing Covid Vaccination table for exploration
-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.dated, dea.population, vac.new_vaccinations, sum(new_vaccinations) OVER (partition by dea.location order by dea.location, dea.dated) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
     on dea.location = vac.location
     and dea.dated = vac.dated
where dea.continent != ''
order by 2,3;

-- With CTE
With PopVsVac (continent, location, dated, population, new_vaccinations, RollingPeopleVaccinated) as 
(
select dea.continent, dea.location, dea.dated, dea.population, vac.new_vaccinations, sum(new_vaccinations) OVER (partition by dea.location order by dea.location, dea.dated) as 
RollingPeopleVaccinated
-- RollingPeopleVaccinated/Population * 100
from coviddeaths dea
join covidvaccinations vac
     on dea.location = vac.location
     and dea.dated = vac.dated
where dea.continent != ''
)
select *, (RollingPeopleVaccinated/Population) * 100
from PopVsVac;


-- using TEMP Table
Drop table if exists PercentPopulationVaccinated;
Create temporary table PercentPopulationVaccinated
( continent nvarchar(255),
location nvarchar(255),
dated datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
);
insert into PercentPopulationVaccinated
select dea.continent, dea.location, dea.dated, dea.population, vac.new_vaccinations, sum(new_vaccinations) OVER (partition by dea.location order by dea.location, dea.dated) as 
RollingPeopleVaccinated
-- RollingPeopleVaccinated/Population * 100
from coviddeaths dea
join covidvaccinations vac
     on dea.location = vac.location
     and dea.dated = vac.dated;


select *, (RollingPeopleVaccinated/Population) * 100
from PercentPopulationVaccinated;

-- Creating View for future visualizations
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.dated, dea.population, vac.new_vaccinations, sum(new_vaccinations) OVER (partition by dea.location order by dea.location, dea.dated) as 
RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
     on dea.location = vac.location
     and dea.dated = vac.dated
where dea.continent != '';

select *
from percentpopulationvaccinated;


 