with base as (
    select
        zs.year
        , zs.manufacturer
        , sum(zs.sales) as zev_sales_per_year
        , pvs.total_sales as total_PV_sales_year
    from electric_vehicle_project.zev_sales zs
    join electric_vehicle_project.passenger_vehicle_sales pvs
        on zs.year = pvs.year
    group by 1, 2, 4
    having sum(zs.sales) > 0
)
select
    year
    , manufacturer
    , zev_sales_per_year
    , rank() over (
        partition by year
        order by zev_sales_per_year desc
    ) as zev_market_rank_per_year
    , zev_sales_per_year / sum(zev_sales_per_year) over(
    	partition by year
    ) as zev_market_share_per_year_pct
    , zev_sales_per_year / total_PV_sales_year as zev_share_of_new_psgr_vehicle_sales_per_year_pct
from base
order by 1, 4;