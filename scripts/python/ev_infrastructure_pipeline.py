from pathlib import Path
from csv import reader, writer

raw_dir = Path('/Users/chriswang/Documents/EV Project/Data/Raw/EV Infrastructure')
output_dir = Path('/Users/chriswang/Documents/EV Project/Data')

def run_ev_infrastructure_pipeline():
    try:
        raw_contents = read_csv(raw_dir)
        processed_contents = transform_data(raw_contents)
        write_csv(output_dir, processed_contents)

        print('EV Infrastructure pipeline completed successfully')

    except FileNotFoundError:
        print('File not found')

# Read CSV file
def read_csv(path: Path) -> list[list]:
    read_contents = []
    with open(path / 'raw_ev_charging_ports.csv', 'r', encoding='utf-8-sig') as file:
        csv_file = reader(file)
        for row in csv_file:
            if row[0] == 'Year':
                continue

            read_contents.append(row)

    return read_contents


# Transform from wide format into long format
def transform_data(read_contents: list[list]) -> list:
    write_contents = []

    for row in read_contents:
        year, state, ev_charging_ports, lvl_1, lvl_2, lvl_3 = row
        row = f"({year}, '{state}', {ev_charging_ports}, {lvl_1}, {lvl_2}, {lvl_3}),"
        write_contents.append(row)

    return write_contents


# Write transformed data to CSV file
def write_csv(path: Path, write_contents: list):
    with open(path / 'processed_ev_infrastructure_counts.csv','w',encoding='utf-8-sig') as file:
        csv_file = writer(file)
        for row in write_contents:
            csv_file.writerow([row])