# Aim: make CSV with country name, ISO2, biocap, efccap, pop
# Method: process JSON
library(jsonlite)
library(tidyverse)

population_df <- fromJSON("GFN_population_usedin2019_all.json")
  
biocapacity_df <- fromJSON("GFN_biocapacitypc_2019_all.json")
footprint_df <- fromJSON("GFN_footprintconspc_2019_all.json")

biocapacity_total_df <- fromJSON("GFN_BCtot_2019_all.json")
footprint_total_df <- fromJSON("GFN_EFCtot_2019_all.json")

biocapacity <- biocapacity_df %>%
  rename(biocapacity = value) %>%
  select(countryCode, isoa2, shortName, biocapacity)

footprint <- footprint_df %>%
  rename(footprintConsumption = value) %>%
  select(footprintConsumption)

BC_total <- biocapacity_total_df %>%
  rename(BC_total = value) %>%
  select(BC_total)

EFC_total <- footprint_total_df %>%
  rename(EFC_total = value) %>%
  select(EFC_total)

combine_df <- bind_cols(biocapacity, footprint, BC_total, EFC_total)

write_csv(combine_df, 'gfn_bcpc_efpc_bc_ef.csv')

# merge GFN population
#
GFN_population <- population_df %>%
  rename(population  = value) %>%
  select(isoa2, population)

GFN_2019 <- merge(combine_df, GFN_population, by = 'isoa2')

# test GFN population
Brazil_population <- population_df[['value']][[20]]
Brazil_total_bio <- biocapacity_total_df[['value']][[20]]
Brazil_total_efc <- footprint_total_df[['value']][[20]]
Brazil_calculate_biopc <- Brazil_total_bio / Brazil_population
Brazil_bio_pc <- biocapacity_df[['value']][[20]]
Brazil_efc_pc <- footprint_df[['value']][[20]]
print(paste("Calculate bio per person", Brazil_calculate_biopc))
print(paste("GFN data bio per person", Brazil_bio_pc))
if(Brazil_calculate_biopc > Brazil_bio_pc * 1.001 || Brazil_calculate_biopc < Brazil_bio_pc / 1.001) {
  print("Problem mismatch?")
} else {
  print("Close enough")
}

# library("httr")
# url <- modify_url("http://api.footprintnetwork.org", path = "v1/countries")
# user_name <- "username"
# api_key <- "1Bv9rtTR2b57O9PtaoH2CHimi6KDq9gk53SM552O12qNSBN6a7IK"
# # headers = {"HTTP_ACCEPT":"application/json"}
# print(url)
# 
# # response <- GET(url, add_headers("Authorization" = "Bearer 1Bv9rtTR2b57O9PtaoH2CHimi6KDq9gk53SM552O12qNSBN6a7IK"))
# raw = GET(url, add_headers("user_name" = user_name, "api_key" = api_key))
# print(status_code(raw))
