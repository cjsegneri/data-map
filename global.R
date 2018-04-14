## libraries ##
library(shiny)
library(shinydashboard)


## reading in the two datasets ##
missing = read.csv("missing_children_clean.csv")
abductions = read.csv("attempted_abductions_clean.csv")


## set the dates ##
missing$missing_date = as.Date(missing$missing_date, "%m/%d/%Y")


## split each multi-column into a list for each element ##
abductions$LEA = as.character(abductions$LEA)
abductions$LEA = strsplit(abductions$LEA, "/")

abductions$child_id = as.character(abductions$child_id)
abductions$child_id = strsplit(abductions$child_id, "/")

abductions$child_race = as.character(abductions$child_race)
abductions$child_race = strsplit(abductions$child_race, "/")

abductions$child_gender = as.character(abductions$child_gender)
abductions$child_gender = strsplit(abductions$child_gender, "/")

abductions$child_perceived_age = as.character(abductions$child_perceived_age)
abductions$child_perceived_age = strsplit(abductions$child_perceived_age, "/")

abductions$offender_gender = as.character(abductions$offender_gender)
abductions$offender_gender = strsplit(abductions$offender_gender, "/")

abductions$offender_race = as.character(abductions$offender_race)
abductions$offender_race = strsplit(abductions$offender_race, "/")

abductions$offender_age = as.character(abductions$offender_age)
abductions$offender_age = strsplit(abductions$offender_age, "/")

abductions$offender_perceived_age = as.character(abductions$offender_perceived_age)
abductions$offender_perceived_age = strsplit(abductions$offender_perceived_age, "/")

abductions$vehicle_style = as.character(abductions$vehicle_style)
abductions$vehicle_style = strsplit(abductions$vehicle_style, "/")

abductions$vehicle_color = as.character(abductions$vehicle_color)
abductions$vehicle_color = strsplit(abductions$vehicle_color, "/")

abductions$offender_method = as.character(abductions$offender_method)
abductions$offender_method = strsplit(abductions$offender_method, "/")


## functions for the server ##

# filtering the missing children data sets
filter_missing_set = function(data, f) {

  # handle the case tab
  if (!is.null(f[1][[1]])) { data = data[data$case_number %in% f[1][[1]],] }
  if (!is.null(f[2][[1]])) { data = data[data$case_type %in% f[2][[1]],] }

  # handle the location tab
  if (!is.null(f[3][[1]])) { data = data[data$missing_state %in% f[3][[1]],] }
  if (!is.null(f[4][[1]])) { data = data[data$missing_city %in% f[4][[1]],] }
  if (!is.null(f[5][[1]])) { data = data[data$missing_zip %in% f[5][[1]],] }

  # handle the child tab
  data = data[data$missing_date > f[6][[1]][1] & data$missing_date < f[6][[1]][2],]
  if (!is.null(f[7][[1]])) { data = data[data$age_missing %in% f[7][[1]],] }
  if (!is.null(f[8][[1]])) { data = data[data$gender %in% f[8][[1]],] }
  if (!is.null(f[9][[1]])) { data = data[data$race %in% f[9][[1]],] }

  # handle the vehicle tab
  if (!is.null(f[10][[1]])) { data = data[data$vehicle_color %in% f[10][[1]],] }
  if (!is.null(f[11][[1]])) { data = data[data$vehicle_style %in% f[11][[1]],] }

  return (data)
}
