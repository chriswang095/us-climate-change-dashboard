with base as (
	select
		ecp.year
		, state
		, ev_charging_port_count
		, rank() over(
			partition by year
			order by  ev_charging_port_count desc
		) as rank_by_ev_charging_port_count
		, level_1_port_count
		, level_2_port_count
		, dc_fast_port_count 
		, level_1_port_count / ecp.ev_charging_port_count as level_1_charging_port_percentage
		, level_2_port_count / ecp.ev_charging_port_count as level_2_charging_port_percentage
		, dc_fast_port_count / ecp.ev_charging_port_count as level_3_charging_port_percentage
		, sum(ev_charging_port_count)
			over(partition by year) as us_ev_charging_port_count_per_year
	from electric_vehicle_project.ev_charging_ports ecp
	order by year
)
select
	year
	, state
	, ev_charging_port_count
	, rank_by_ev_charging_port_count
	, ev_charging_port_count / us_ev_charging_port_count_per_year as share_of_us_ev_charging_port_count_pct
	, level_1_port_count as level_1_charging_port_count
	, level_2_port_count as level_2_charging_port_count
	, dc_fast_port_count  as dc_fast_charging_port_count
	, level_1_charging_port_percentage
	, level_2_charging_port_percentage
	, level_3_charging_port_percentage
	, us_ev_charging_port_count_per_year
from base;