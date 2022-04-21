library(tidyverse)
library(readxl)
library(googledrive)
library(googlesheets4)
library(countrycode)
library(stringi)

# eo_id <- '1MND7qbKQZ3Q-pLS2182un7z6ZkUtY3LzvUf626SLuEw'
# sheet_names(ss = eo_id)
# eoData <- read_sheet(ss = eo_id, sheet ='Main')

original_xls <- "data/Country Data .xlsx"

column_names <- read_excel(original_xls, 
                           sheet = "Main", 
                           .name_repair = "minimal") %>% names()

eo_data_import <- read_excel(original_xls, 
                             sheet = "Main", skip = 0)

eo_data_import[ eo_data_import == "No Data" ] <- NA
eo_data_import[ eo_data_import == "#VALUE!" ] <- NA

# ,   col_names = column_names)

# remove last 3 rows
eoData <- head(eo_data_import, -3)
# eoData <- eo_data_import %>% 
#   filter(!is.na(Country)) %>% 
#   filter(Country != 'World')

# column names make shorter
# finding by old name rather than colnum
names(eoData)[grepl('GDP per capita', names(eoData))] <- 'GDP_pp_2020'

names(eoData)[grepl('2017 biocapacity per person in Hectares', names(eoData))] <- 'Biocapacity_2017'
names(eoData)[grepl('2017 EF per person Hectares)', names(eoData))] <- 'Footprint_2017'
names(eoData)[grepl('2017 Population (GFN)', names(eoData))] <- 'Population_2017'
names(eoData)[grepl('2017 Maximum Population', names(eoData))] <- 'SustainPop_2017'

names(eoData)[grepl('2018 biocapacity Hectares per person (GFN)', names(eoData))] <- 'Biocapacity_2018'
names(eoData)[grepl('2018 ecological footprint Hectares per person (GFN)', 
                    names(eoData))] <- 'Footprint_2018'
names(eoData)[grepl('2018 Population (GFN)', names(eoData))] <- 'Population_2018'
names(eoData)[grepl('2018 Maximum Population', names(eoData))] <- 'SustainPop_2018'

names(eoData)[grepl('2020 Rank', names(eoData))] <- 'Rank_sustain_2020'
names(eoData)[grepl('Table 5, accessed Sept 2021', names(eoData))] <- 'Species_threat_2021_2'
names(eoData)[grepl('SP.POP.GROW', names(eoData))] <- 'Growth_rate_pop_2020'
names(eoData)[grepl('SP.DYN.CONM.ZS', names(eoData))] <- 'Modern_contraception_2020'
names(eoData)[grepl('Actual Comment', names(eoData))] <- 'Comments'

names(eoData)[3] <- 'Ratio_Biocapacity'
names(eoData)[4] <- 'Ratio_Footprint'
names(eoData)[5] <- 'Ratio_Population'
names(eoData)[6] <- 'Ratio_SustainPop'

names(eoData)[7] <- 'Biocapacity_2018'
names(eoData)[8] <- 'Footprint_2018'
names(eoData)[9] <- 'Population_2018'
names(eoData)[12] <- 'Footprint_2017'
names(eoData)[13] <- 'Population_2017'

eo <- eoData %>% 
  select(iso2c, Country,
         Ratio_Biocapacity, Ratio_Footprint, Ratio_Population, Ratio_SustainPop,
         Biocapacity_2017, Footprint_2017, Population_2017, SustainPop_2017, 
         Biocapacity_2018, Footprint_2018, Population_2018, SustainPop_2018,
         Growth_rate_pop_2020, Modern_contraception_2020, 
         Species_threat_2021_2, GDP_pp_2020, Rank_sustain_2020)

# convert character columns to numeric
charToNumeric <- c(FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, 
                 TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE)
eo[, charToNumeric] <- as.data.frame(apply(eo[ , charToNumeric], 2, as.numeric))
# check appropriate columns numeric
sapply(eo, class)

eo$Ratio_Biocapacity <- round(eo$Ratio_Biocapacity, digits=2)
eo$Ratio_Footprint <- round(eo$Ratio_Footprint, digits=2)
eo$Ratio_Population <- round(eo$Ratio_Population, digits=2)
eo$Ratio_SustainPop <- round(eo$Ratio_SustainPop, digits=2)

eo %>% 
  select(Country, Ratio_Population) %>%
  drop_na() %>% 
  filter(Ratio_Population > 1.04)
eo %>% 
  select(Country, Ratio_Population) %>%
  drop_na() %>% 
  filter(Ratio_Population < 0.95)

eo %>% 
  select(Country, Growth_rate_pop_2020) %>%
  drop_na() %>% 
  filter(Growth_rate_pop_2020 > 3)
eo %>% 
  select(Country, Growth_rate_pop_2020) %>%
  drop_na() %>% 
  filter(Growth_rate_pop_2020 < -1)


# check country names
eo_before_alphabetic_sort_Country <- eo
eo <- eo[order(eo$Country),] 
all.equal(eo, eo_before_alphabetic_sort_Country)
eo <- eo_before_alphabetic_sort_Country

# detect missing values, how many and which countries?
eo %>% 
  select(Country, Biocapacity_2018) %>% 
  filter(is.na(Biocapacity_2018))
eo %>% 
  select(Country, Footprint_2018) %>% 
  filter(is.na(Footprint_2018))
eo %>% 
  select(Country, Biocapacity_2017) %>% 
  filter(is.na(Biocapacity_2017))
eo %>% 
  select(Country, Footprint_2017) %>% 
  filter(is.na(Footprint_2017))
eo %>% 
  select(Country, Population_2018) %>% 
  filter(is.na(Population_2018))
eo %>% 
  select(Country, SustainPop_2018) %>% 
  filter(is.na(SustainPop_2018))
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



