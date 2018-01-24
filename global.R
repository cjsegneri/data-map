# get dataset that contains zipcodes tied to lat/long values
library(zipcode)
data(zipcode)

# get ncmec data
attempts = read.csv("ncmecData/Attempts_Hackathon_5_Years_of_Data.csv")
missing = read.csv("ncmecData/Hackathon_Missing_Child_5_Years_of_Data.csv")

# change the zipcode column to "zip" to match zipcode data
colnames(attempts)[which(names(attempts) == "Incident.Zip")] <- "zip"
colnames(missing)[which(names(missing) == "Missing.Zip")] <- "zip"

# merge lat/lon values into datasets by zip code
attempts = merge(attempts, zipcode, by = "zip")
missing = merge(missing, zipcode, by = "zip")

# fix the dates
attempts$Incident.Date = as.Date(attempts$Incident.Date, format = "%d/%m/%Y")
missing$Missing.Date = as.Date(missing$Missing.Date, format = "%d/%m/%Y")

# fix the -1 values in the method columns
attempts$Offender.Method.Animal[attempts$Offender.Method.Animal==-1] = 1
attempts$Offender.Method.Candy[attempts$Offender.Method.Candy==-1] = 1
attempts$Offender.Method.Money[attempts$Offender.Method.Money==-1] = 1
attempts$Offender.Method.Other[attempts$Offender.Method.Other==-1] = 1
attempts$Offender.Method.Ride[attempts$Offender.Method.Ride==-1] = 1
