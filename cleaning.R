
## read in the files ##
library(gdata)

nfa = read.xls("Media_Ready_LIMs_NFAs_5779s_2007-2017.xlsx")

rfi = read.xls("RFI_Attempts_3.30.18_SwungOnCaseID_FINAL.xlsx")


## clean the nfa data set ##

# replace all empty strings with NA values
nfa[nfa==""] = NA
# rename columns
colnames(nfa) = c(
  "case_number",
  "case_type",
  "missing_date",
  "age_missing",
  "gender",
  "race",
  "missing_city",
  "missing_state",
  "missing_zip",
  "vehicle_style",
  "vehicle_color"
)
# write clean data to a csv file
write.csv(nfa, file = "missing_children_clean.csv", row.names = F)


## clean the rfi data set ##

# replace all empty strings with NA values
for (i in 1:dim(rfi)[1]) {
  for (j in 1:dim(rfi)[2]) {
    if (grepl("^\\s*$", rfi[i,j])) {
      rfi[i,j] = NA
    }
  }
}

# replace all NAs in the methods with zeroes
rfi$Offender.Method.Animal[is.na(rfi$Offender.Method.Animal)] = 0
rfi$Offender.Method.Candy[is.na(rfi$Offender.Method.Candy)] = 0
rfi$Offender.Method.Money[is.na(rfi$Offender.Method.Money)] = 0
rfi$Offender.Method.Ride[is.na(rfi$Offender.Method.Ride)] = 0
rfi$Offender.Method.Other[is.na(rfi$Offender.Method.Other)] = 0

# combine all the multi-columns
child_id = c()
child_race = c()
child_gender = c()
child_perceived_age = c()
offender_gender = c()
offender_race = c()
offender_age = c()
offender_perceived_age = c()
vehicle_style = c()
vehicle_color = c()
LEA = c()
offender_method = c()
for(i in 1:dim(rfi)[1]) {
  r = lapply(rfi[i,], as.character)

  ci= c(r$Child.ID.1, r$Child.ID.2, r$Child.ID.3, r$Child.ID.4, r$Child.ID.5, r$Child.ID.6)
  ci = ci[!is.na(ci)]
  child_id = c(child_id, paste(ci, collapse = "/"))

  cr = c(r$Child.Race.1, r$Child.Race.2, r$Child.Race.3, r$Child.Race.4, r$Child.Race.5, r$Child.Race.6)
  cr = cr[!is.na(cr)]
  child_race = c(child_race, paste(cr, collapse = "/"))

  cg = c(r$Child.Gender.1, r$Child.Gender.2, r$Child.Gender.3, r$Child.Gender.4, r$Child.Gender.5, r$Child.Gender.6)
  cg = cg[!is.na(cg)]
  child_gender = c(child_gender, paste(cg, collapse = "/"))

  cpa = c(r$Child.Perceived.Age.1, r$Child.Perceived.Age.2, r$Child.Perceived.Age.3, r$Child.Perceived.Age.4, r$Child.Perceived.Age.5, r$Child.Perceived.Age.6)
  cpa = cpa[!is.na(cpa)]
  child_perceived_age = c(child_perceived_age, paste(cpa, collapse = "/"))

  og = c(r$Offender.Gender.1, r$Offender.Gender.2, r$Offender.Gender.3, r$Offender.Gender.4)
  og = og[!is.na(og)]
  offender_gender = c(offender_gender, paste(og, collapse = "/"))

  or = c(r$Offender.Race.1, r$Offender.Race.2, r$Offender.Race.3, r$Offender.Race.4)
  or = or[!is.na(or)]
  offender_race = c(offender_race, paste(or, collapse = "/"))

  oa = c(r$Offender.Age.1, r$Offender.Age.2, r$Offender.Age.3, r$Offender.Age.4)
  oa = oa[!is.na(oa)]
  offender_age = c(offender_age, paste(oa, collapse = "/"))

  opa = c(r$Offender.Perceived.Age.1, r$Offender.Perceived.Age.2, r$Offender.Perceived.Age.3, r$Offender.Perceived.Age.4)
  opa = opa[!is.na(opa)]
  offender_perceived_age = c(offender_perceived_age, paste(opa, collapse = "/"))

  vs = c(r$Vehicle.Style.1, r$Vehicle.Style.2)
  vs = vs[!is.na(vs)]
  vehicle_style = c(vehicle_style, paste(vs, collapse = "/"))

  vc = c(r$Vehicle.Color.1, r$Vehicle.Color.2)
  vc = vc[!is.na(vc)]
  vehicle_color = c(vehicle_color, paste(vc, collapse = "/"))

  lea = c(r$LEA.1, r$LEA.2, r$LEA.3)
  lea = lea[!is.na(lea)]
  LEA = c(LEA, paste(lea, collapse = "/"))

  om = c(r$Offender.Method.Animal, r$Offender.Method.Candy, r$Offender.Method.Money, r$Offender.Method.Ride, r$Offender.Method.Other)
  oml = c()
  if (om[1] == 1) { oml = c(oml, "animal") }
  if (om[2] == 1) { oml = c(oml, "candy") }
  if (om[3] == 1) { oml = c(oml, "money") }
  if (om[4] == 1) { oml = c(oml, "ride") }
  if (om[5] == 1) { oml = c(oml, "other") }
  offender_method = c(offender_method, paste(oml, collapse = "/"))
}

# create the new data frame with new column names
rfi_clean = data.frame(
  case_type = rfi$X.Case.Type,
  case_number = rfi$Case.Number,
  status = rfi$Status,
  incident_date = rfi$Incident.Date,
  incident_time = rfi$Incident.Time,
  incident_type = rfi$Incident.Type,
  incident_location_type = rfi$Incident.Location.Type,
  incident_location = rfi$Incident.Location,
  incident_city = rfi$Incident.City,
  incident_state = rfi$Incident.State,
  incident_zip = rfi$Incident.Zip,
  incident_county = rfi$Incident.County,
  LEA = LEA,
  child_id = child_id,
  child_race = child_race,
  child_gender = child_gender,
  child_perceived_age = child_perceived_age,
  offender_gender = offender_gender,
  offender_race = offender_race,
  offender_age = offender_age,
  offender_perceived_age = offender_perceived_age,
  vehicle_style = vehicle_style,
  vehicle_color = vehicle_color,
  offender_method = offender_method,
  offender_method_detail = rfi$Offender.Method.Other.Detail,
  offender_statement = rfi$Offender.Statements,
  how_got_away = rfi$How.Got.Away,
  how_got_away_detail = rfi$How.Got.Away.Detail
)

# replace the empty strings with NA values again
for (i in 1:dim(rfi_clean)[1]) {
  for (j in 1:dim(rfi_clean)[2]) {
    if (grepl("^\\s*$", rfi_clean[i,j])) {
      rfi_clean[i,j] = NA
    }
  }
}

# write to a csv file
write.csv(rfi_clean, "attempted_abductions_clean.csv", row.names = F)
