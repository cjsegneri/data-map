# libraries
library(shinydashboard)
library(shinyWidgets)
library(shinythemes)
library(leaflet)
library(timevis)
library(zipcode)
library(plotly)
library(tmap)
library(tmaptools)
library(sf)

# get dataset that contains zipcodes tied to lat/long values
data(zipcode)

# get ncmec data
kidnapping = read.csv("ncmecData/Attempts_Hackathon_5_Years_of_Data.csv")
missing = read.csv("ncmecData/Hackathon_Missing_Child_5_Years_of_Data.csv")

# change the zipcode column to "zip" to match zipcode data
colnames(kidnapping)[which(names(kidnapping) == "Incident.Zip")] = "zip"
colnames(missing)[which(names(missing) == "Missing.Zip")] = "zip"

# merge lat/lon values into datasets by zip code
kidnapping = merge(kidnapping, zipcode, by = "zip")
missing = merge(missing, zipcode, by = "zip")

# fix the dates
kidnapping$Incident.Date = as.Date(kidnapping$Incident.Date, format = "%d/%m/%Y")
missing$Missing.Date = as.Date(missing$Missing.Date, format = "%d/%m/%Y")

# fix the -1 values in the method columns
kidnapping$Offender.Method.Animal[kidnapping$Offender.Method.Animal==-1] = 1
kidnapping$Offender.Method.Candy[kidnapping$Offender.Method.Candy==-1] = 1
kidnapping$Offender.Method.Money[kidnapping$Offender.Method.Money==-1] = 1
kidnapping$Offender.Method.Other[kidnapping$Offender.Method.Other==-1] = 1
kidnapping$Offender.Method.Ride[kidnapping$Offender.Method.Ride==-1] = 1

# fix the kidnapping races
kidnapping$Offender.Race.1[kidnapping$Offender.Race.1 == "Pacific Islander"] = "Unknown"
kidnapping$Offender.Race.1[kidnapping$Offender.Race.1 == "white"] = "White"

# set the data sets to be downloaded as global variables
missing.download <<- missing
kidnapping.download <<- kidnapping

# get the start and end dates from the data sets
missing.date.first <<- min(missing$Missing.Date[!is.na(missing$Missing.Date)])
missing.date.last <<- max(missing$Missing.Date[!is.na(missing$Missing.Date)])
kidnapping.date.first <<- min(kidnapping$Incident.Date[!is.na(kidnapping$Incident.Date)])
kidnapping.date.last <<- max(kidnapping$Incident.Date[!is.na(kidnapping$Incident.Date)])
