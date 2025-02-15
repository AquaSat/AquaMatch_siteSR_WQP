#' @title Load location information
#' 
#' @description
#' Load in and format location file using config settings
#' 
#' @param yaml contents of the yaml .csv file
#' 
#' @returns dataframe of the reformatted location data or the message
#' 'Not configured to use site locations'. Silently saves 
#' the .csv in the `5_siteSR_stack/run` directory path if configured for site
#' acquisition.
#' 
#' 
grab_locs <- function(yaml) {
  if (grepl("site", yaml$extent)) {
    locs <- read_csv(file.path(yaml$data_dir, yaml$location_file))
    if (yaml$site_filter) {
      locs <- locs %>% 
        filter(grepl("river|stream|lake|reservoir", 
                     MonitoringLocationTypeName, 
                     ignore.case = T))
    }
    # store yaml info as objects
    lat <- yaml$latitude
    lon <- yaml$longitude
    id <- yaml$unique_id
    # apply objects to tibble
    locs <- locs %>% 
      rename_with(~c("Latitude", "Longitude", "id"), any_of(c(lat, lon, id)))
    write_csv(locs, "5_siteSR_stack/run/locs.csv")
    locs
  } else {
    message("Not configured to use site locations.")
  }
}

