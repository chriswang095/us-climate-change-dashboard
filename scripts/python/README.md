This pipeline is composed of four sub-pipelines, each handling a particular category of data:
  1. EV Infrastructure (ev_infrastructure_pipeline.py)
  2. GHG Emissions (ghg_emissions_pipeline.py)
  3. Vehicle Registrations (vehicle_registrations_pipeline.py)
  4. ZEV Sales (zev_sales_pipeline.py)

Execution of the four sub-pipelines is orchestrated by a single entry-point script (run_pipeline.py).
