setwd("/Users/chriswang/Downloads")
registration_data <- read_csv("cubic.csv")

# Fit linear models for each state and sector
models <- registration_data %>%
  group_by(state, fuel_type) %>%
  nest() %>%
  mutate(
    model = map(data, ~ lm(registrations ~ year, data = .x))
  )

future_years <- tibble(year = c(2024))

# Expand for all states and sectors
future_data <- expand_grid(
  state = unique(registration_data$state),
  fuel_type = unique(registration_data$fuel_type),
  year = c(2024)
)

# Define a function to predict using the stored models
predict_registrations <- function(state_name, fuel_name, year_values) {
  model <- models %>%
    filter(state == state_name, fuel_type == fuel_name) %>%
    pull(model) %>%
    .[[1]]
  
  predict(model, newdata = tibble(year = year_values))
}

# Apply predictions
# Join future_data with models
future_data <- future_data %>%
  left_join(models %>% select(state, fuel_type, model),
            by = c("state", "fuel_type")) %>%
  mutate(
    registrations = map2_dbl(
      model, year,
      ~ predict(.x, newdata = tibble(year = .y))
    )
  ) %>%
  select(year, state, fuel_type, registrations)

registrations_full <- bind_rows(registration_data, future_data)

# Export future_data to CSV
write_csv(future_data, "model_results.csv")
