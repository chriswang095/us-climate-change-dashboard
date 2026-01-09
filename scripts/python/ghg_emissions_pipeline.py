from pathlib import Path
from csv import reader, writer

repo_root = Path(__file__).resolve().parents[2]
raw_dir = repo_root / 'data' / 'raw' / 'ghg-emissions'
output_dir = repo_root / 'data' / 'processed-for-sql-ingetion' / 'ghg-emissions'

def run_ghg_emissions_pipeline():
    try:
        transposed_data = read_csvs(raw_dir)
        processed_contents = convert_to_string(transposed_data)
        write_csv(output_dir, processed_contents)

        print('GHG Emissions pipeline completed successfully')

    except FileNotFoundError:
        print('File not found')


# Read each CSV file in the folder
def read_csvs(read_path: Path) -> list[list]:
    agg_transposed_contents = []
    for csv_f in sorted(raw_dir.glob('*.csv')):
        raw_contents = []
        with open(csv_f, 'r', encoding='utf-8-sig') as file:
            csv_file = reader(file)
            for row in csv_file:
                raw_contents.append(row)

        transposed_contents = transpose_data(raw_contents)

        # Append the sorted rows to the aggregated list
        for row in transposed_contents:
            agg_transposed_contents.append(row)

    return agg_transposed_contents


# Sort economic sector categories and transpose data
def transpose_data(read_contents: list[list]):
        # Identify the state in the CSV
        index = read_contents[0][0].find(' ')
        state = read_contents[0][0][:index]

        # Sort category rows alphabetically
        first_row = read_contents[:1]
        remaining_rows = read_contents[1:]
        remaining_rows.sort()

        state_row = [state for i in range(len(read_contents[0]))]
        read_contents = first_row + [state_row] + remaining_rows

        # Transpose rows and columns
        rows = len(read_contents)
        cols = len(read_contents[0])

        transposed_contents = []
        for j in range(cols):
            new_row = []
            for i in range(rows):
                new_row.append(read_contents[i][j])
            transposed_contents.append(new_row)

        # Remove the header generated from each CSV, append before write
        transposed_contents.pop(0)

        return transposed_contents


# Turn list of lists into list of strings
def convert_to_string(transposed_list: list[list]):
    processed_contents = []

    for row in transposed_list:
        year, state, agriculture, commercial, electric, gross, industry, residential, transportation = row
        processed_contents.append(f"({year},'{state}',{agriculture},{commercial},{electric},{gross},{industry},{residential},{transportation})")

    return processed_contents


# Write transformed data to CSV file
def write_csv(write_path: Path, write_contents: list):
    with open(write_path / 'processed_ghg_emissions_aggregated.csv', 'w', encoding='utf-8-sig') as file:
        csv_file = writer(file)
        for row in write_contents:
            csv_file.writerow([row])

if __name__ == '__main__':
    run_ghg_emissions_pipeline()
