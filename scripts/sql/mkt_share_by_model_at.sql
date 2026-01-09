select
	zs.manufacturer
	, zs.model
	, sum(zs.sales) as zev_sales_all_time
	, rank() over(
		order by sum(zs.sales) desc
	) as zev_market_rank_all_time
	, sum(zs.sales) / sum(sum(zs.sales)) over() as zev_market_share_all_time_pct
	, sum(zs.sales) / 219911700 as zev_share_of_new_psgr_vehicle_sales_all_time_pct
from electric_vehicle_project.zev_sales zs
join electric_vehicle_project.passenger_vehicle_sales pvs
	on zs.year = pvs.year
group by 1, 2
having sum(sales) > 0
order by 4;