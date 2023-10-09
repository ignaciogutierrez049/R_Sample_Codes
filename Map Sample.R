### Data Visualization Sample Code ###

# set working directory
  setwd("/Users/ignaciogutierrez/Desktop/Sample Codes")

# download library packages
  knitr::opts_chunk$set(echo = TRUE, warning=FALSE)
  
  library(tidyverse)    # Modern data science workflow 
  
  library(sf)           # Simple features for R
  library(tmap)         # Thematic Maps
  library(tmaptools)    # Thematic Maps Tools
  library(RColorBrewer) # ColorBrewer Palettes
  library(leaflet)      # Interactive web maps
  library(rgdal)        # Bindings for the Geospatial Data Abstraction Library   
  library(rgeos)        # Interface to Geometry Engine - Open Source

# change the presentation of decimal numbers to 4 and avoid scientific notation
  options(prompt="R> ", digits=4, scipen=999)
  
  
## read data
  
  # read precipitation data for Congo 
    dat <- read_csv("/Users/ignaciogutierrez/Desktop/Sample Codes/congo_wet.csv")

  # read Congo map shapefile
    mapData <- read_sf("/Users/ignaciogutierrez/Desktop/Sample Codes/cog_adm_gaul_20190617_shp/cog_admbnda_adm1_gaul_20190617.shp")

  # check coordinate reference system
    st_crs(mapData)

  
## wrangle data

  # merge data
    dat_map <- inner_join(
    dat,
    mapData,
    by = "ADM1_FR")

  # keep the data as sf object
    dat_map <- st_as_sf(dat_map)
    st_crs(mapData)

    
## create maps
  
  # static map
    tmap_options(check.and.fix = TRUE)
    tm_shape(dat_map) + 
      tm_fill("Max Consecutive Wet Days",
              style = "quantile",
              n = 7,
              palette = "Reds") +
      tm_layout(
        legend.outside = TRUE,
        frame = FALSE)

  # set map to interactive viewing
    tmap_options(check.and.fix = TRUE)
    tmap_mode("view")

  # interactive map identified by province, with Max Consecutive Wet Days as pop-up value
    tm_shape(dat_map) + 
      tm_fill("Max Consecutive Wet Days",
              palette = "Reds",
              id="ADM1_FR",
              popup.vars=c("Max Consecutive Wet Days")
      ) + 
      tm_legend(outside=TRUE) +
      tm_layout(frame = FALSE) 
