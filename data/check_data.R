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