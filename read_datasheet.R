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
names(eoData)[grepl('GDP per capita', names(eoData))] <- 'GDP_pp_2020'
names(eoData)[grepl('2017 Population', names(eoData))] <- 'Population_2017'
names(eoData)[grepl('2017 Maximum Population', names(eoData))] <- 'SustainPop_2017'
names(eoData)[grepl('2020 Rank', names(eoData))] <- 'Rank_sustain_2020'
names(eoData)[grepl('Table 5, accessed Sept 2021', names(eoData))] <- 'Species_threat_2021_2'
names(eoData)[grepl('SP.POP.GROW', names(eoData))] <- 'Growth_rate_pop_2020'
names(eoData)[grepl('SP.DYN.CONM.ZS', names(eoData))] <- 'Modern_contraception_2020'
names(eoData)[grepl('Actual Comment', names(eoData))] <- 'Comments'

names(eoData)[grepl('2018 Population GFN', names(eoData))] <- 'Population_2018'
names(eoData)[grepl('2018 Maximum Population', names(eoData))] <- 'SustainPop_2018'

# check country names
eoData <- eoData[order(eoData$Country),]

eo <- eoData %>% 
  select(iso2c, Country, Population_2017, SustainPop_2017, 
         Growth_rate_pop_2020, Modern_contraception_2020, 
         Species_threat_2021_2, GDP_pp_2020, Rank_sustain_2020)

# detect missing values, how many and which countries?
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
  select(Country, GDP_pp_2020) %>% 
  filter(is.na(GDP_pp_2020))
eo %>% 
  select(Country, Rank_sustain_2020) %>% 
  filter(is.na(Rank_sustain_2020))
eo %>% 
  select(Country, Rank_sustain_2020) %>% 
  filter(Rank_sustain_2020 == 'NA')

# iso3c add
eo$iso3c <- countrycode(sourcevar = eo$iso2c, 
                        origin = "iso2c",
                        destination = "iso3c")
# Continent add
eo$Continent <- countrycode(sourcevar = eo$iso2c, 
                            origin = "iso2c",
                            destination = "continent")

# collect ID from df
# df9 in eo_html newer than eo_data
photos <- readRDS('../eo_html/data/df9.rds')
table(photos$ID)

# num photos for each country, but only 176
imgPerCountry <- as.data.frame(table(photos$iso3c))
names(imgPerCountry) <- c('iso3c', 'Freq')

eop <- merge(eo, imgPerCountry, all.x=TRUE)
which(is.na(eop$Freq))
eop$Freq[is.na(eop$Freq)] <- 0

eop$GDP_pp_2020 <- round(eop$GDP_pp_2020, 0)
eop <- eop[order(eop$Country),]

saveRDS(eop, 'data/eo_April_2022.rds')

# i <- sapply(imgPerCountry, is.factor)
# imgPerCountry[i] <- lapply(imgPerCountry[i], as.character)
# names(imgPerCountry)[1] <- 'iso3c'
# 
# imgPerCountry$IDs <- 'NA'
# for (cy in 1:nrow(imgPerCountry)) {
#   imgPerCountry$IDs[cy] <- photos[photos$iso3c == imgPerCountry$iso2c[cy],]$ID
#   print(photos[photos$iso3c == imgPerCountry$iso2c[cy],]$ID)
# }
# 
# eo$IDs <- NA
# prev_iso3c <- 'none'
# IDs <- 
# 
# for (p in 1:nrow(photos)) {
#   iso3c <- photos$iso3c[p]
#   id <- photos$ID[p]
#   
#   print(paste(p, iso3c, id))
# }

# Frequency add

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



