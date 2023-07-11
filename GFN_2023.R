# Aim: make CSV with country name, ISO2, biocap, efccap, pop
# Method: process JSON
library(jsonlite)
library(tidyverse)

biocapacity_lists <- read_json("GFN_biocapacitypc_2019_all.json")
footprint <- read_json("GFN_footprintconspc_2019_all.json")

biocapacity_df <- fromJSON("GFN_biocapacitypc_2019_all.json")
footprint_df <- fromJSON("GFN_footprintconspc_2019_all.json")

biocapacity <- biocapacity_df %>%
  rename(biocapacity = value) %>%
  select(countryCode, isoa2, shortName, biocapacity)

footprint <- footprint_df %>%
  rename(footprintConsumption = value) %>%
  select(footprintConsumption)

combine_df <- bind_cols(biocapacity, footprint)

# df <- fromJSON(json_data) %>%
#    select(shortName, isoa2, biocapacity = value[record == 'BiocapPerCap'], footprint = value[record == 'EFConsPerCap'])


json_1 <- '[{"year": 2019, "shortName": "Armenia", "countryCode": 1, "countryName": "Armenia", "isoa2": "AM", "score": "3A", "record": "EFConsPerCap", "cropLand": 0.599779043533126, "grazingLand": 0.242834133918476, "forestLand": 0.280242107718304, "fishingGround": 0.00126937394398479, "builtupLand": 0.0466074265894613, "carbon": 0.931397981544185, "value": 2.10213006724754}, {"year": 2019, "shortName": "Armenia", "countryCode": 1, "countryName": "Armenia", "isoa2": "AM", "score": "3A", "record": "BiocapPerCap", "cropLand": 0.345274171709162, "grazingLand": 0.278954644418481, "forestLand": 0.0968027565779619, "fishingGround": 0.0166128528804626, "builtupLand": 0.0466074265894613, "carbon": 0.0, "value": 0.784251852175529}]'

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
