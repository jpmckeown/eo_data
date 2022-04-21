library(tidyverse)
library(WDI)
library(googledrive)
library(googlesheets4)
library(gargle)

token <- token_fetch()
eo <- readRDS('../eo_data/data/eo_Jan2022.rds')

# recent year and see if complete
pop_2018 <- WDI(
  country = 'all',
  indicator = 'SP.POP.TOTL',
  start = 2018,
  end = 2018,
  extra = FALSE,
  cache = NULL,
  latest = NULL,
  language = 'en'
)
# count missing rows = 2
sum(is.na(pop_2018$SP.POP.TOTL))

join_WBpop2018 <- eo %>% 
  left_join(pop_2018, by='iso2c')

gsheet_WBpop2018 <- join_WBpop2018 %>%
  select(iso2c, SP.POP.TOTL, Country, country) 

library(xlsx)
write.xlsx(df, 'WBpop2018.xlsx', sheetName = "WBpop2018")
           
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

