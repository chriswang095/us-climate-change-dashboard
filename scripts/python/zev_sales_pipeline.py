# Code to transform ZEV sales data from CSV into SQL import format

# Read data from CSV into Python
from pathlib import Path
from csv import reader, writer

repo_root = Path(__file__).resolve().parents[2]
raw_dir = repo_root / 'data' / 'raw' / 'zev_sales'
output_dir = repo_root / 'data' / 'processed-for-sql-ingetion' / 'zev_sales'

def run_zev_sales_pipeline():
    try:
        raw_contents = read_csv(raw_dir)
        processed_contents = transform_data(raw_contents)
        write_csv(output_dir, processed_contents)

        print('ZEV Sales pipeline completed successfully')


    except FileNotFoundError:
        print('File not found')


# Read CSV file
def read_csv(read_path: Path) -> list[list]:
    raw_contents = []

    with open(read_path / 'raw_zev_sales.csv', 'r', encoding='utf-8-sig') as file:
        csv_file = reader(file)
        for row in csv_file:
            if row[0] == 'Manufacturer':
                continue
            raw_contents.append(row)

    return raw_contents


# Transform from wide format into long format
def transform_data(read_contents: list[list]) -> list:
    processed_contents = []

    for item in read_contents:
        year = 2011
        for sale in item[3:]:
            row = f"({year},'{item[0]}','{item[1]}','{item[2]}',{sale}),"
            processed_contents.append(row)
            year += 1

    return processed_contents

# Write transformed data to CSV file
def write_csv(write_path: Path, write_contents: list):
    with open(write_path / 'processed_zev_sales.csv', 'w', encoding='utf-8-sig') as file:
        csv_file = writer(file, delimiter=',')
        for row in write_contents:
            csv_file.writerow([row])
