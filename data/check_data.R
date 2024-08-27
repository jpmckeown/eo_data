library(tidyverse)
# if data is not already loaded
# eo23 <- readRDS('data/eo_2023_oldGrade_Turkiye.rds')
# eo24 <- readRDS("data/eo_2024_Turkiye.rds")

# print(names(eo23))
# print(names(eo24))

columns_to_compare <- c("Maximum_Pop", "Grow_Rate_Pop", "Population", "Contraception", "Species", "GDP_pp")

joined_df <- eo24 %>%
  select(iso3c, Country, all_of(columns_to_compare)) %>%
  inner_join(
    eo23 %>% select(iso3c, Country, all_of(columns_to_compare)),
    by = c("iso3c", "Country"),
    suffix = c("_24", "_23")
  )

# Step 3: Check column names
print("Column names in joined_df:")
print(names(joined_df))

# Step 4: Calculate percentage differences
result_df <- joined_df %>%
  mutate(
    Maximum_Pop_pct_diff = (Maximum_Pop_24 - Maximum_Pop_23) / Maximum_Pop_23 * 100,
    Grow_Rate_Pop_pct_diff = (Grow_Rate_Pop_24 - Grow_Rate_Pop_23) / Grow_Rate_Pop_23 * 100,
    Population_pct_diff = (Population_24 - Population_23) / Population_23 * 100,
    Contraception_pct_diff = (Contraception_24 - Contraception_23) / Contraception_23 * 100,
    Species_pct_diff = (Species_24 - Species_23) / Species_23 * 100,
    GDP_pp_pct_diff = (GDP_pp_24 - GDP_pp_23) / GDP_pp_23 * 100
  ) %>%
  select(iso3c, Country, ends_with("_pct_diff"))

# Step 5: Round percentage differences to two decimal places
result_df <- result_df %>%
  mutate(across(ends_with("_pct_diff"), ~round(.x, 2)))

# Step 6: View the results
print("First few rows of result_df:")
print(head(result_df))

saveRDS(result_df, file="data/eo_2024_check.rds")
write_csv(result_df, "data/eo_2024_check.csv")
