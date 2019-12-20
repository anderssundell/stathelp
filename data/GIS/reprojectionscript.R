help(rm(list=ls(all=TRUE)))

library(sp)
library(rgdal)
library(raster)
library(rgeos)
library(maptools)
library(gdistance)
library(fields)
library(tidyr)
library(FastKNN)
library(ggplot2)
library(rasterVis)
library(dplyr)
library(data.table)
library(purrr)
library(SDMTools)
library(deming)
library(maps)
library(sf)
require(tmaptools)
library(rmapshaper)

setwd("/Users/xsunde/Dropbox/Jupyter/Stathelp/data/GIS")

# Define clipping function
gClip <- function(shp, bb){
  if(class(bb) == "matrix") b_poly <- as(extent(as.vector(t(bb))), "SpatialPolygons")
  else b_poly <- as(extent(bb), "SpatialPolygons")
  gIntersection(shp, b_poly, byid = T)
}


# Load worldmap and set CRS
worldmap <- readOGR(dsn = "ne_50m_admin_0_countries", layer = "ne_50m_admin_0_countries")
worldmap <- worldmap[worldmap$SOVEREIGNT != "Antarctica", ]
worldmap_condensed <- worldmap[, c("SOVEREIGNT", "ADMIN")]
bbox(worldmap)

glimpse(worldmap)

# EUROPE
b_europe <- matrix(c(-25, 35, 45,72), nrow=2, ncol=2)
clip_europe <- gClip(worldmap, b_europe)
mercator_europe <- spTransform(clip_europe, CRS('+init=EPSG:3395'))
lambert_europe <- spTransform(clip_europe, CRS('+init=ESRI:102014'))
cliplist_europe <- over(worldmap, clip_europe)

# SOUTH AMERICA
b_sa <- matrix(c(-86.5,-58.2,-29.0,15.4), nrow=2, ncol=2)
clip_sa <- gClip(worldmap, b_sa)
mercator_sa <- spTransform(clip_sa, CRS('+init=EPSG:3395'))
cliplist_sa <- over(worldmap, clip_sa)

## NORTH AMERICA
b_na <- matrix(c(-168.7,6.1,-49.4,72.3), nrow=2, ncol=2)
clip_na <- gClip(worldmap, b_na)
mercator_na <- spTransform(clip_na, CRS('+init=EPSG:3395'))
lambert_na <- spTransform(clip_na, CRS('+init=EPSG:3347'))
cliplist_na <- over(worldmap, clip_na)

## AFRICA
b_afr <- matrix(c(-19.6,-36.4,63.8,40.5), nrow=2, ncol=2)
clip_afr <- gClip(worldmap, b_afr)
mercator_afr <- spTransform(clip_afr, CRS('+init=EPSG:3395'))
plot(mercator_afr)
cliplist_afr <- over(worldmap, clip_afr)

## ASIA
b_asia <- matrix(c(52.3,-11.3,154.9,57.1), nrow=2, ncol=2)
clip_asia <- gClip(worldmap, b_asia)
mercator_asia <- spTransform(clip_asia, CRS('+init=EPSG:3395'))
plot(mercator_asia)
cliplist_asia <- over(worldmap, clip_asia)

# EXPORTING

# WORLD MERCATOR
writeOGR(world_mercator, "projections", "mercator_world", driver="ESRI Shapefile")

# EUROPE
data_europe <- as.data.frame(worldmap[is.na(cliplist_europe)==FALSE,c("SOVEREIGNT", "ADMIN")])
pid <- sapply(slot(mercator_europe, "polygons"), function(x) slot(x, "ID"))
p.df <- data.frame( ID=1:length(mercator_europe), row.names = pid)

spdf_europe <- SpatialPolygonsDataFrame(mercator_europe, p.df, match.ID=TRUE)
spdf_europe$SOVEREIGNT <- data_europe$SOVEREIGNT
spdf_europe$ADMIN <- data_europe$ADMIN

writeOGR(spdf_europe, "projections", "mercator_europe", driver="ESRI Shapefile")

# EUROPE LAMBERT
data_europe <- as.data.frame(worldmap[is.na(cliplist_europe)==FALSE,c("SOVEREIGNT", "ADMIN")])
pid <- sapply(slot(lambert_europe, "polygons"), function(x) slot(x, "ID"))
p.df <- data.frame( ID=1:length(lambert_europe), row.names = pid)

spdf_europe <- SpatialPolygonsDataFrame(lambert_europe, p.df, match.ID=TRUE)
spdf_europe$SOVEREIGNT <- data_europe$SOVEREIGNT
spdf_europe$ADMIN <- data_europe$ADMIN

writeOGR(spdf_europe, "projections", "lambert_europe", driver="ESRI Shapefile")

# NORTH AMERICA MERCATOR
data_na <- as.data.frame(worldmap[is.na(cliplist_na)==FALSE,c("SOVEREIGNT", "ADMIN")])
pid <- sapply(slot(mercator_na, "polygons"), function(x) slot(x, "ID"))
p.df <- data.frame( ID=1:length(mercator_na), row.names = pid)

spdf_na <- SpatialPolygonsDataFrame(mercator_na, p.df, match.ID=TRUE)
spdf_na$SOVEREIGNT <- data_na$SOVEREIGNT
spdf_na$ADMIN <- data_na$ADMIN

writeOGR(spdf_na, "projections", "mercator_na", driver="ESRI Shapefile")

# NORTH AMERICA LAMBERT
data_na <- as.data.frame(worldmap[is.na(cliplist_na)==FALSE,c("SOVEREIGNT", "ADMIN")])
pid <- sapply(slot(lambert_na, "polygons"), function(x) slot(x, "ID"))
p.df <- data.frame( ID=1:length(lambert_na), row.names = pid)

spdf_na <- SpatialPolygonsDataFrame(lambert_na, p.df, match.ID=TRUE)
spdf_na$SOVEREIGNT <- data_na$SOVEREIGNT
spdf_na$ADMIN <- data_na$ADMIN

writeOGR(spdf_na, "projections", "lambert_na", driver="ESRI Shapefile")

# SOUTH AMERICA MERCATOR
data_sa <- as.data.frame(worldmap[is.na(cliplist_sa)==FALSE,c("SOVEREIGNT", "ADMIN")])
pid <- sapply(slot(mercator_sa, "polygons"), function(x) slot(x, "ID"))
p.df <- data.frame( ID=1:length(mercator_sa), row.names = pid)

spdf_sa <- SpatialPolygonsDataFrame(mercator_sa, p.df, match.ID=TRUE)
spdf_sa$SOVEREIGNT <- data_sa$SOVEREIGNT
spdf_sa$ADMIN <- data_sa$ADMIN

writeOGR(spdf_sa, "projections", "mercator_sa", driver="ESRI Shapefile")

# ASIA MERCATOR
data_asia <- as.data.frame(worldmap[is.na(cliplist_asia)==FALSE,c("SOVEREIGNT", "ADMIN")])
pid <- sapply(slot(mercator_asia, "polygons"), function(x) slot(x, "ID"))
p.df <- data.frame( ID=1:length(mercator_asia), row.names = pid)

spdf_asia <- SpatialPolygonsDataFrame(mercator_asia, p.df, match.ID=TRUE)
spdf_asia$SOVEREIGNT <- data_asia$SOVEREIGNT
spdf_asia$ADMIN <- data_asia$ADMIN

writeOGR(spdf_asia, "projections", "mercator_asia", driver="ESRI Shapefile")


# AFRICA MERCATOR
data_afr <- as.data.frame(worldmap[is.na(cliplist_afr)==FALSE,c("SOVEREIGNT", "ADMIN")])
pid <- sapply(slot(mercator_afr, "polygons"), function(x) slot(x, "ID"))
p.df <- data.frame( ID=1:length(mercator_afr), row.names = pid)

spdf_afr <- SpatialPolygonsDataFrame(mercator_afr, p.df, match.ID=TRUE)
spdf_afr$SOVEREIGNT <- data_afr$SOVEREIGNT
spdf_afr$ADMIN <- data_afr$ADMIN

writeOGR(spdf_afr, "projections", "mercator_afr", driver="ESRI Shapefile")

