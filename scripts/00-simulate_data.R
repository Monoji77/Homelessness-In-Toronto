#### Preamble ####
# Purpose: Simulates Daily Shelter & Overnight Service Occupancy & Capacity dataset
# Author: Chris Yong Hong Sen
# Date: 24 September 2024
# Contact: luke.yong@mail.utoronto.ca

#### Workspace setup ####
library(tidyverse)
library(lubridate)
set.seed(517)

#### Simulate data ####
simulated_data <- tibble(
  occupancy_date = sample(seq(as.Date('2024-01-01'), Sys.Date(), by = 'days'), 15, replace =
                            TRUE),
  location_city = sample(
    c('Etobicoke', 'Toronto', 'Scarborough', 'North York', 'Vaughan'),
    15,
    replace = TRUE
  ),
  demographic = sample(
    c('Men', 'Women', 'Mixed Adult', 'Youth', 'Families'),
    15,
    replace = TRUE
  ),
  program_area = sample(
    c(
      'BSOSS',
      'Refugee (Base)',
      'Refugee (Temporary)',
      'COVID19',
      'Winter'
    ),
    15,
    replace = TRUE
  ),
  homeless_people_served = sample(1:1500, 15, replace = TRUE),
  capacity_actual_bed = sample(1:20, 15, replace = TRUE),
  capacity_actual_room = sample(1:20, 15, replace = TRUE),
)

#### Tests ####

# test whether date is within the year 2024
simulated_data |>
  filter(!(occupancy_date %in% seq(
    as.Date('2024-01-01'), as.Date('2024-12-31'), by = 'days'
  ))) |>
  
  nrow() == 0

# test whether number of homeless people served is at least 0
sum(simulated_data$homeless_people_served < 0) == 0

# test whether homeless shelters are all within Canadian cities
sum(!(
  simulated_data$location_city %in%
    c('Etobicoke', 'Toronto', 'Scarborough', 'North York', 'Vaughan')
)) == 0
