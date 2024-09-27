#### Preamble ####
# Purpose: Downloads and saves the data from open.toronto.ca
# Author: Chris Yong Hong Sen
# Date: 24 September 2024
# Contact: luke.yong@mail.utoronto.ca

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####

# get package
package <- show_package("21c83b32-d5a8-4106-a54f-010dbe49f6f2")
package

# get all resources for this package
resources <- list_package_resources("21c83b32-d5a8-4106-a54f-010dbe49f6f2")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
data <- filter(datastore_resources, row_number() == 1) %>% get_resource()
data

# concatenate data from 2021 to 2023 (most updated)
# NOTE: we do not use 2024 since data is incomplete

obtaindata <- function(datastore, file) {
  yearx_data_id <- datastore %>%
    filter(name == file) %>%
    pull(id)
  
  return(datastore |>
           filter(id == yearx_data_id) |> get_resource())
}

year2021_data <- obtaindata(
  datastore_resources,
  'daily-shelter-overnight-service-occupancy-capacity-2021.csv'
)
year2022_data <- obtaindata(
  datastore_resources,
  'daily-shelter-overnight-service-occupancy-capacity-2022.csv'
)
year2023_data <- obtaindata(
  datastore_resources,
  'daily-shelter-overnight-service-occupancy-capacity-2023.csv'
)
# concatenate
combined_raw_data <- rbind(year2021_data, year2022_data, year2023_data)

#### Save data ####
write_csv(combined_raw_data, "../data/raw_data/unedited_data.csv")
