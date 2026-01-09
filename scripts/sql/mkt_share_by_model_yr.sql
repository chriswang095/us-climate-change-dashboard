select
	zs.year
	, zs.manufacturer
	, zs.model
	, zs.sales as zev_sales_per_year
	, rank() over(
		partition by year
		order by sum(zs.sales) desc
	) as zev_market_rank_per_year
	, zs.sales / sum(zs.sales) over(
		partition by year
	) as zev_market_share_per_year_pct
	, zs.sales / pvs.total_sales as zev_share_of_new_psgr_vehicle_sales_per_year_pct
	, zs.fuel_type
from electric_vehicle_project.zev_sales zs
join electric_vehicle_project.passenger_vehicle_sales pvs
	on zs.year = pvs.year
group by 1, 2, 3, 4, 7, 8
having sum(sales) > 0
order by 1, 5;