select
	state
	, economic_sector
	, sum(emissions_mmt_co2e) as ghg_emissions_all_time
	, rank() over(
		order by sum(emissions_mmt_co2e) desc
	) as rank_by_ghg_emissions_all_time
from electric_vehicle_project.ghg_emissions ge
group by state, economic_sector;