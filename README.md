# us-climate-change-dashboard

## Overview

This repository contains an end-to-end Python data pipeline that ingests, cleans, and preprocesses multiple public datasets pertaining to US greenhouse gas emission, zero-emission vehicle sales, vehicle registrations, and EV charging infrastructure development. The pipeline outputs CSV files containing rows ready for downstream SQL ingestion.

## Repository Structure

```text
us-climate-change-dashboard/
├─ data/
│  ├─ processed-for-sql-ingestion/
│  ├─ processed-for-tableau-ingestion/
│  ├─ raw/
│  │  ├─ ev-infrastructure/
│  │  ├─ ghg-emissions/
│  │  ├─ vehicle-registrations/
│  │  ├─ zev-sales/
├─ scripts/
│  ├─ python
│  │  ├─ run_pipeline.py
│  │  ├─ ev-infrastructure_pipeline.py
│  │  ├─ ghg_emissions_pipeline.py
│  │  ├─ vehicle_registrations_pipeline.py
│  │  ├─ zev_sales_pipeline.py
│  ├─ r/
│  ├─ sql/
├─ tableau/
│  ├─ U.S. Climate Change Dashboard.twbx
├─ README.md
├─ business_requirements.pdf
```

## Pipeline Architecture

This pipeline is composed of four sub-pipelines, each handling a particular category of data:
  1. EV Infrastructure (ev_infrastructure_pipeline.py)
  2. GHG Emissions (ghg_emissions_pipeline.py)
  3. Vehicle Registrations (vehicle_registrations_pipeline.py)
  4. ZEV Sales (zev_sales_pipeline.py)

Execution of the four sub-pipelines is orchestrated by a single entry-point script (run_pipeline.py).

## Running the Pipeline
To execute the end-to-end, download all required files into their respective folders and execute the run_pipeline.py script. The pipeline will process all raw CSV files and output transformed datasets to their respective folders in /data/processed-for-sql-ingestion

The pipeline produces clean, standardized CSV files ready for SQL database ingestion.

## Reproducing SQL Queries
To reproduce the datasets used in the Tableau dashboard visualization, ingest the pipeline-transformed datasets into SQL using the 'create_' queries and run the transformation queries, both located in the /scripts/sql folder.
