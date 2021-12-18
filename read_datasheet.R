library(tidyverse)
library(googledrive)
library(googlesheets4)
library(countrycode)
library(stringi)

eo_id <- '1MND7qbKQZ3Q-pLS2182un7z6ZkUtY3LzvUf626SLuEw'
sheet_names(ss = eo_id)

eoData <- read_sheet(ss = eo_id, sheet ='Main')

eoData <- eoData %>% 
  filter(!is.na(Country)) %>% 
  filter(Country != 'World')

# column names make shorter
# finding by old name rather than colnum
names(eoData)[grepl('2017 Population', names(eoData))] <- 'Population_2017'
names(eoData)[grepl('2017 Maximum Population', names(eoData))] <- 'SustainPop_2017'
names(eoData)[grepl('2020 Rank', names(eoData))] <- 'Rank_sustain_2020'
names(eoData)[grepl('Table 5, accessed Sept 2021', names(eoData))] <- 'Species_threat_2021.2'
names(eoData)[grepl('SP.POP.GROW', names(eoData))] <- 'Growth_rate_pop_2020'
names(eoData)[grepl('SP.DYN.CONM.ZS', names(eoData))] <- 'Modern_contraception_2020'
names(eoData)[grepl('Actual Comment', names(eoData))] <- 'Comments'

# check country names
eoData <- eoData[order(eoData$Country),]

eo <- eoData %>% 
  select(iso2c, Country, Population_2017, SustainPop_2017, Growth_rate_pop_2020, 
         Modern_contraception_2020, Species_threat_2021.2, Rank_sustain_2020)

# missing values, how many and which countries?
eo %>% 
  select(Country, Population_2017) %>% 
  filter(is.na(Population_2017))
eo %>% 
  select(Country, SustainPop_2017) %>% 
  filter(is.na(SustainPop_2017))
eo %>% 
  select(Country, Growth_rate_pop_2020) %>% 
  filter(is.na(Growth_rate_pop_2020))
eo %>% 
  select(Country, Modern_contraception_2020) %>% 
  filter(is.na(Modern_contraception_2020))
eo %>% 
  select(Country, Species_threat_2021_2) %>% 
  filter(is.na(Species_threat_2021_2))
eo %>% 
  select(Country, Rank_sustain_2020) %>% 
  filter(is.na(Rank_sustain_2020))
eo %>% 
  select(Country, Rank_sustain_2020) %>% 
  filter(Rank_sustain_2020 == 'NA')
# eo_comment <- eoData %>% 
#   select(iso2c, Comments)
# Encoding(eo_comment$Comments) # reveals some unknown, some UTF-8
# 
# for (k in 1:187) { 
#   print(paste(Encoding(eo_comment$Comments[k]), eo_comment$iso2c[k]))
# } # , eo_comment$Comments[k]
# 
# # testing Madagascar, its UTF-8
# comment <- eo_comment %>% 
#   filter(iso2c == 'MG') %>% 
#   select(Comments)
# 
# Encoding(as.character(comment))
# 
# eoComment <- stri_encode(eoData$Comments, '', 'UTF-8')
# Encoding(eoComment)



