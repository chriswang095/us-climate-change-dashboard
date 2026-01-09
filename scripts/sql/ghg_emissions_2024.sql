with base_2024 as (
	select
		row_number() over(order by year, state, economic_sector) as index_num
		, year
		, state
		, economic_sector
		, emissions_mmt_co2e
	from electric_vehicle_project.ghg_emissions ge
	where year = 2024
),
base_2023 as (
	select
		row_number() over(order by year, state, economic_sector) as index_num
		, year
		, state
		, economic_sector
		, emissions_mmt_co2e
	from electric_vehicle_project.ghg_emissions ge
	where year = 2023
	order by year, state, economic_sector
)
select
	a.year
	, a.state
	, a.economic_sector
	, a.emissions_mmt_co2e as ghg_emissions_2024_mmt_co2e
	, b.emissions_mmt_co2e as ghg_emissions_2023_mmt_co2e	
 	, sum(a.emissions_mmt_co2e) over () / 7422.474466969 as ghg_emissions_relative_to_2005_pct
	, a.emissions_mmt_co2e - b.emissions_mmt_co2e as yoy_ghg_emissions_change_mmt_co2e
	, case
		when b.emissions_mmt_co2e = 0 then 0
		else (a.emissions_mmt_co2e - b.emissions_mmt_co2e) / b.emissions_mmt_co2e
	end as yoy_ghg_emissions_change_pct
	, rank() over(
		order by a.emissions_mmt_co2e - b.emissions_mmt_co2e
	) as rank_by_yoy_ghg_emissions_reduction_abs_volume
	, rank() over(
		order by (a.emissions_mmt_co2e - b.emissions_mmt_co2e) / b.emissions_mmt_co2e
	) as rank_by_yoy_ghg_emissions_reduction_percentage
from base_2024 a
join base_2023 b
	on a.index_num = b.index_num
group by 1, 2, 3, 4, 5, 7, 8
order by 2, 3;