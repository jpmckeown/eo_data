# IUCN Red List
library(rredlist)

rl_comp_groups(group = NULL, key = "40f69dbaa7d7e97ac104610deb82bbfb0db9c18f09ce0d2eaf9a839ec8f6a6a8")

rl_countries(key = "40f69dbaa7d7e97ac104610deb82bbfb0db9c18f09ce0d2eaf9a839ec8f6a6a8")

rl_sp_country('NZ', key = "40f69dbaa7d7e97ac104610deb82bbfb0db9c18f09ce0d2eaf9a839ec8f6a6a8")

rl_regions(key = "40f69dbaa7d7e97ac104610deb82bbfb0db9c18f09ce0d2eaf9a839ec8f6a6a8")

rl_threats('Fratercula arctica', region="europe", key = "40f69dbaa7d7e97ac104610deb82bbfb0db9c18f09ce0d2eaf9a839ec8f6a6a8")
rl_threats(region="europe", key = "40f69dbaa7d7e97ac104610deb82bbfb0db9c18f09ce0d2eaf9a839ec8f6a6a8")
