with base as (
	select year
		, state
		, sum(case
			when fuel_type in ('EV', 'PHEV', 'Hydrogen')
			then registrations else 0
		end) as zev_registrations
		, sum(registrations) as total_registrations
		, sum(case when fuel_type not in ('EV', 'PHEV', 'Hydrogen') then registrations else 0 end) as non_zev_registrations
	from electric_vehicle_project.vehicle_registrations vr 
	group by year, state
)
select year
	, state
	, zev_registrations
	, total_registrations
	, zev_registrations / (zev_registrations + non_zev_registrations) as zev_share_of_registrations_pct
from base;