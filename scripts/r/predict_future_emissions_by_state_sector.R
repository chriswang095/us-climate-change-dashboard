setwd("/Users/chriswang/Downloads")
emissions <- read_csv("ghg_emissions.csv")

models <- emissions %>%
  group_by(state, economic_sector) %>%
  nest() %>%
  mutate(
    model = map(data, ~ lm(emissions_mmt_co2e ~ year + I(year^2), data = .x))
  )

future_years <- tibble(year = c(2023, 2024))

# Expand for all states and sectors
future_data <- expand_grid(
  state = unique(emissions$state),
  economic_sector = unique(emissions$economic_sector),
  year = c(2023, 2024)
)

# Define a function to predict using the stored models
predict_emissions <- function(state_name, sector_name, year_values) {
  model <- models %>%
    filter(state == state_name, economic_sector == sector_name) %>%
    pull(model) %>%
    .[[1]]
  
  predict(model, newdata = tibble(year = year_values))
}

# Apply predictions
# Join future_data with models
future_data <- future_data %>%
  left_join(models %>% select(state, economic_sector, model), by = c("state", "economic_sector")) %>%
  mutate(
    emissions_mmt_co2e = map2_dbl(
      model, year,
      ~ predict(.x, newdata = tibble(year = .y))
    )
  ) %>%
  select(state, economic_sector, year, emissions_mmt_co2e)

emissions_full <- bind_rows(emissions, future_data)

ggplot(emissions_full, aes(x = year, y = emissions_mmt_co2e, color = economic_sector)) +
  geom_line() +
  facet_wrap(~state) +
  theme_minimal() +
  ggtitle("GHG Emissions by State and Sector with Extrapolation") +
  theme(legend.position = "bottom")

