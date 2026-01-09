select
	year
	, state
	, economic_sector
	, emissions_mmt_co2e as ghg_emissions_per_year_mmt_co2e
from electric_vehicle_project.ghg_emissions ge;