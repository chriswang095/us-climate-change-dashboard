with base_2024 as (
	select
		zs.year
		, zs.manufacturer
		, zs.model
		, sum(zs.sales) as zev_sales_2024
		, sum(zs.sales) / pvs.total_sales as zev_share_of_new_psgr_vehicle_sales_2024_pct
		, pvs.total_sales as total_PV_sales_year_2024
    from electric_vehicle_project.zev_sales zs
    join electric_vehicle_project.passenger_vehicle_sales pvs
        on zs.year = pvs.year
    where zs.year = 2024
    group by 1, 2, 3, 6
)
, base_2023 as (
	select
		zs.year
		, zs.manufacturer
		, zs.model
		, sum(zs.sales) as zev_sales_2023
		, sum(zs.sales) / pvs.total_sales as zev_share_of_new_psgr_vehicle_sales_2023_pct
		, pvs.total_sales as total_PV_sales_year_2023
    from electric_vehicle_project.zev_sales zs
    join electric_vehicle_project.passenger_vehicle_sales pvs
        on zs.year = pvs.year
    where zs.year = 2023
    group by 1, 2, 3, 6
)
 select
	a.year
	, a.manufacturer
	, a.model
	, a.zev_sales_2024
	, b.zev_sales_2023
	, rank() over(
		partition by year
		order by a.zev_sales_2024 desc
	) as zev_market_rank_2024
	, a.zev_share_of_new_psgr_vehicle_sales_2024_pct
	, case
		when b.zev_sales_2023 = 0 then 'First year of ZEV sales'
		else (a.zev_sales_2024 - b.zev_sales_2023)/ b.zev_sales_2023
	end as yoy_zev_sales_change_pct
	, zev_share_of_new_psgr_vehicle_sales_2024_pct - zev_share_of_new_psgr_vehicle_sales_2023_pct as yoy_zev_share_of_new_psgr_vehicle_sales_change_pct_dfif
from base_2024 a
join base_2023 b
	on a.manufacturer = b.manufacturer
	and a.model = b.model
order by 1 desc;