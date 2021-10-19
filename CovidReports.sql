SELECT * FROM Covid.coviddeaths where continent is not null order by 3,4;

SELECT count(*) FROM Covid.coviddeaths;

SELECT * FROM Covid.coviddeaths order by date desc
 
 -- Death Percentage // Total Case Vs Total Death
 
 SELECT location,date,total_cases,total_deaths,(total_cases/total_deaths) as DeathPercent
 FROM Covid.coviddeaths  order by 1,2;
 
 -- Infection Percentage // Total Case Vs Population
 
 SELECT location,date,total_cases,population,(total_cases/population)*100 as InfectionPercent
 FROM Covid.coviddeaths order by 1,2;
 
 -- Infection Percentage // Total Case Vs Population - India
 
 SELECT location,date,total_cases,population,(total_cases/population)*100 as InfectionPercent
 FROM Covid.coviddeaths 
 Where location like '%india%' order by 5 desc;
 
 -- Country with high Infection Rate WRT Population
 
 SELECT location,population, Max(total_cases),(Max(total_cases/population))*100 as InfectionPercent
 FROM Covid.coviddeaths 
 Group by location,population order by 4 desc;
 
 -- Countries with the highest Death count per Population
 
 SELECT location, Max(cast(total_deaths as signed)) as TotalDeathCount
 FROM Covid.coviddeaths where continent is not  null
 Group by location order by TotalDeathCount desc;
 
 -- Breaking things down by continent
  -- Continents with highest death count per population
 
 SELECT continent, Max(cast(total_deaths as signed)) as TotalDeathCount
 FROM Covid.coviddeaths where continent is not  null
 Group by continent order by TotalDeathCount desc;
 
 
 -- Global numbers
 
 SELECT location,date,total_cases,total_deaths,(total_cases/total_deaths) as DeathPercent
 FROM Covid.coviddeaths  where location like '%India%'  order by 1,2;
 
 -- Global numbers
 
SELECT date,sum(new_cases)as total_cases ,sum(cast(new_deaths as signed) ) as total_deaths
, sum(cast(new_deaths as signed) )/sum(new_cases)*100 as GlobalDeathPercent
 FROM Covid.coviddeaths  
 Group by date
 -- where location like '%India%' 
 order by 1,2;


 
 SELECT sum(new_cases)as total_cases ,sum(cast(new_deaths as signed) ) as total_deaths
, sum(cast(new_deaths as signed) )/sum(new_cases)*100 as GlobalDeathPercent
 FROM Covid.coviddeaths  
 -- where location like '%India%' 
 order by 1,2;
 
 -- Looking at total population Vs Vaccination 
 
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
 sum(cast(vac.new_vaccinations as signed)) 
 OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) as Rolling_people_Vaccinated 
 FROM Covid.coviddeaths dea
 Join Covid.covidvaccinations vac
 on dea.location=vac.location  and
 dea.date=vac.date
 ORDER BY 1,2,3 ;
 
 -- select vacc tab
 
 SELECT *
 FROM Covid.covidvaccinations;
 
 -- USE CTE
 
 WITH PopVsVac (continent,location,population,new_vaccinations,Rolling_people_Vaccinated )
 as
 (
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
 sum(cast(vac.new_vaccinations as signed)) 
 OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) as Rolling_people_Vaccinated 
 FROM Covid.coviddeaths dea
 Join Covid.covidvaccinations vac
 on dea.location=vac.location  and
 dea.date=vac.date
 -- ORDER BY 1,2,3 
 )
 SELECT * ,(Rolling_people_Vaccinated/population)*100 from PopVsVac;
 
 -- create temp table
 
 CREATE Table #PercentpeolpeVaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 vaccinations numeric,
 Rolling_people_Vaccinated  numeric
 )
 INSERT INTO
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
 sum(cast(vac.new_vaccinations as signed)) 
 OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) as Rolling_people_Vaccinated 
 FROM Covid.coviddeaths dea
 Join Covid.covidvaccinations vac
 on dea.location=vac.location  and
 dea.date=vac.date
 -- ORDER BY 1,2,3 
 SELECT * ,(Rolling_people_Vaccinated/population)*100 from PercentpeolpeVaccinated
 
 
 -- creating view to store data for later vizualisations
 
 CREATE VIEW PercentPeopleVaccinated AS
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
 sum(cast(vac.new_vaccinations as signed)) 
 OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) as Rolling_people_Vaccinated 
 FROM Covid.coviddeaths dea
 Join Covid.covidvaccinations vac
 on dea.location=vac.location  and
 dea.date=vac.date;
--  where dea.continent is not null
 -- ORDER BY 1,2,3
 
 select * from PercentPeopleVaccinated;
 