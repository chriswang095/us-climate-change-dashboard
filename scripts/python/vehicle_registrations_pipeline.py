from pathlib import Path
from csv import reader, writer

repo_root = Path(__file__).resolve().parents[2]
raw_dir = repo_root / 'data' / 'raw' / 'vehicle_registrations'
output_dir = repo_root / 'data' / 'processed-for-sql-ingetion' / 'vehicle_registrations'

def run_vehicle_registrations_pipeline():
    try:
        raw_contents = read_csvs(raw_dir)
        processed_contents = transform_data(raw_contents)
        write_csv(output_dir, processed_contents)

        print('Vehicle Registrations pipeline completed successfully')

    except FileNotFoundError:
        print('File not found')


# Read each CSV file in the folder
def read_csvs(read_path: Path) -> list[list]:
    raw_contents = []
    for csv_f in sorted(raw_dir.glob('*.csv')):
        with open(csv_f, 'r', encoding='utf-8-sig') as file:
            csv_file = reader(file)
            for row in csv_file:
                if row[0] == 'State':
                    continue
                raw_contents.append(row)

    return raw_contents


# Transform from wide format into long format
def transform_data(read_contents: list[list]) -> list:
    categories = [
        'EV', 'PHEV', 'HEV', 'Biodiesel', 'E85',
        'CNG', 'Propane', 'Hydrogen', 'Methanol',
        'Gasoline', 'Diesel', 'Unknown Fuel'
    ]

    processed_contents = []
    year = 2016

    for row in read_contents:
        col_num = 1
        for category in categories:
            new_row = [row[0], category, row[col_num]]
            processed_contents.append(new_row)
            col_num += 1

    # Add year and convert to string format
    row_counter = 0
    for i, row in enumerate(processed_contents):
        if row_counter > 0 and row_counter % 612 == 0:
            year += 1

        state, fuel_type, registrations = row
        processed_contents[i] = f"({year},'{state}','{fuel_type}',{registrations})"
        row_counter += 1

    return processed_contents


# Write transformed data to CSV file
def write_csv(write_path: Path, write_contents: list) :
    with open(write_path / 'processed_registration_aggregated.csv', 'w', encoding='utf-8-sig') as file:
        csv_file = writer(file)
        for row in write_contents:
            csv_file.writerow([row])
