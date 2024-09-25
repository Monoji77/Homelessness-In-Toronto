#### Preamble ####
# Purpose: Cleans the unclean data recorded by Toronto Shelter & Support Services 
# Author: Chris Yong Hong Sen
# Date: 24 September 2024
# Contact: luke.yong@mail.utoronto.ca

#### Workspace setup ####
library(tidyverse)
library(janitor)

#### Clean data ####

#1 drop unnessesary columns and convert all column names to lower
raw_data <- read_csv("../data/raw_data/unedited_data.csv")

intermediate_data <- raw_data |>
  janitor::clean_names() |>
  select(occupancy_date, organization_id, 
         organization_name, location_id, 
         location_name, location_city,
         sector, overnight_service_type,
         program_area, service_user_count,
         capacity_actual_bed, capacity_funding_bed, 
         unoccupied_beds, occupancy_rate_beds) %>%
  
  # carefully handle dates since structure across years are different
  mutate(occupancy_date = case_when(
    
    substring(occupancy_date,1, 4) == '2023' ~ substring(occupancy_date, 1, 10),
      .default = paste0('20', substring(occupancy_date, 1, 8))),
    
    occupancy_date = as.Date(occupancy_date))


#2 check for missing values
columns_na <- names(intermediate_data)[colSums(is.na(intermediate_data)) > 0]
missing_values_count <- function(data) {
  
  #obtain columns with NA
  columns_na <- names(data)[colSums(is.na(data)) > 0]
  
  #obtain counts for each column with missing values
  for (column_with_missing_values in columns_na) {
    missing_count_for_column <- sum(is.na(data[column_with_missing_values]))
    print(paste(column_with_missing_values, missing_count_for_column, sep=': '))
  }
}

missing_values_count(intermediate_data)

#3 drop missing values: missing values have to be dropped. It does not make sense to interpolate 
#                       values nor to use the mean/median to substitute as we don't know what
#                       other factors could affect the capacity of the area.
# 
# NOTE: by dropping values, we lost approximately 35% of information.

cleaned_data <- intermediate_data |> drop_na()

#### Save data ####
write_csv(cleaned_data, "../data/analysis_data/analysis_data.csv")

