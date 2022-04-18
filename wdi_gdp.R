library(tidyverse)
library(WDI)
library('googledrive')
library(googlesheets4)

eo <- readRDS('../eo_data/data/eo_Jan2022.rds')

# GDP per capita
# "latest" gives n most recent data available!
gdp_latest <- WDI(
  country = 'all',
  indicator = 'NY.GDP.PCAP.CD',
  latest = 1
)

join_gdp <- eo %>% 
  left_join(gdp_latest, by='iso2c') %>%
  arrange(Country)

# visual inspect Country vs country
gsheet_gdp <- join_gdp %>%
  select(iso2c, NY.GDP.PCAP.CD, year, Country, country) 

gsheet_gdp <- join_gdp %>%
  select(iso2c, NY.GDP.PCAP.CD, year, Country) %>% 
  replace_na(list(NY.GDP.PCAP.CD = 'N/A', year = 'N/A'))

#gsheet_gdp$NY.GDP.PCAP.CD %>% replace_na('N/A')

test_id <- '1JB3m0Kiy8LPTHagYm_6pvegvWOGMETem16z2nKWOKLA'

sheet_write(gsheet_gdp, test_id, sheet = "Main")

# latest year info
table(gsheet_gdp$year)

