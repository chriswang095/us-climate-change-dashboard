from ev_infrastructure_pipeline import run_ev_infrastructure_pipeline
from ghg_emissions_pipeline import run_ghg_emissions_pipeline
from vehicle_registrations_pipeline import run_vehicle_registrations_pipeline
from zev_sales_pipeline import run_zev_sales_pipeline


def main():
    run_ev_infrastructure_pipeline() # Code to transform raw EV infrastructure count data into SQL import format
    run_ghg_emissions_pipeline() # Code to transform raw GHG emissions data into SQL import format
    run_vehicle_registrations_pipeline() # Code to transform raw vehicle registrations data into SQL import format
    run_zev_sales_pipeline() # Code to transform raw ZEV sales data into SQL import format


if __name__ == '__main__':
    main()