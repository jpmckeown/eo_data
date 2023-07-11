library(tidyverse)
library(WDI)
library(countrycode)

library(googledrive)
library(googlesheets4)
library(gargle)

# recent year and see if complete
pop_2021 <- WDI(
  country = 'all',
  indicator = 'SP.POP.TOTL',
  start = 2021,
  end = 2021,
  extra = FALSE,
  cache = NULL,
  latest = NULL,
  language = 'en'
)
# count missing rows = 2
sum(is.na(pop_2021$SP.POP.TOTL))

# recent year and see if complete
popgrow_2021 <- WDI(
  country = 'all',
  indicator = 'SP.POP.GROW',
  start = 2021,
  end = 2021,
  extra = FALSE,
  cache = NULL,
  latest = NULL,
  language = 'en'
)
# count missing rows = 2
sum(is.na(pop_2021$SP.POP.GROW))

eo <- readRDS('../eo_data/data/eo_April_2022.rds')

join_WBpop2021 <- eo %>% 
  left_join(pop_2021, by=c('iso2c','iso3c'))

gsheet_WBpop2021 <- join_WBpop2021 %>%
  select(Country, iso2c, iso3c, SP.POP.TOTL) 

write_csv(gsheet_WBpop2021, "data/WBpop_2021.csv")
  

join_WBpopgrow2021 <- eo %>% 
  left_join(popgrow_2021, by=c('iso2c','iso3c'))

gsheet_WBpopgrow2021 <- join_WBpopgrow2021 %>%
  select(Country, iso2c, iso3c, SP.POP.GROW) 

write_csv(gsheet_WBpopgrow2021, "data/WBpopgrow_2021.csv")


WBpop2018_test_id <- '1Iq6MK-W28ReCYvtGORvKA65fwhk2HuhhkKXtz4z2CWk'

drive_auth(email = "jpm4258@gmail.com")
gs4_auth(token = drive_token())

sheet_write(gsheet_WBpop2018, WBpop2018_test_id, sheet = "Main")

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

