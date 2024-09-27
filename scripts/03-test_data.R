#### Preamble ####
# Purpose: Tests simulated Daily Shelter & Overnight Service Occupancy & Capacity dataset
# Author: Chris Yong Hong Sen
# Date: 24 September 2024
# Contact: luke.yong@mail.utoronto.ca


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