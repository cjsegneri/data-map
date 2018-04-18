## libraries ##
library(shiny)
library(shinydashboard)
library(DT)
library(leaflet)
library(plotly)


## reading in the two datasets ##
missing = read.csv("missing_children_clean.csv")
abductions = read.csv("attempted_abductions_clean.csv")


## set the dates ##
missing$missing_date = as.Date(missing$missing_date, "%m/%d/%Y")
abductions$incident_date = as.Date(abductions$incident_date)
abductions = abductions[!is.na(abductions$incident_date),]


## functions for the server ##
# filtering the missing children data set
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

# filtering the attempted abduction data set
filter_abduction_set = function(data, filters) {
  ca = filters[1][[1]]
  l = filters[2][[1]]
  ch = filters[3][[1]]
  o = filters[4][[1]]
  v = filters[5][[1]]

  # handle the case tab
  if(!is.null(ca[1][[1]])) { data = data[data$case_number %in% ca[1][[1]],]}
  if(!is.null(ca[2][[1]])) { data = data[data$case_type %in% ca[2][[1]],]}
  if(!is.null(ca[3][[1]])) { data = data[data$status %in% ca[3][[1]],]}
  if(!is.null(ca[4][[1]])) { data = data[data$incident_type %in% ca[4][[1]],]}
  data = data[data$incident_date > ca[5][[1]][1] & data$incident_date < ca[5][[1]][2],]

  # handle the location tab
  if(!is.null(l[1][[1]])) { data = data[data$incident_state %in% l[1][[1]],]}
  if(!is.null(l[2][[1]])) { data = data[data$incident_city %in% l[2][[1]],]}
  if(!is.null(l[3][[1]])) { data = data[data$incident_county %in% l[3][[1]],]}
  if(!is.null(l[4][[1]])) { data = data[data$incident_zip %in% l[4][[1]],]}
  if(!is.null(l[5][[1]])) { data = data[data$incident_location %in% l[5][[1]],]}
  if(!is.null(l[6][[1]])) { data = data[data$incident_location_type %in% l[6][[1]],]}
  if(!is.null(l[7][[1]])) { data = data[apply(sapply(l[7][[1]], grepl, data$LEA, fixed = T), 1, any),]}

  # handle the child tab
  if(!is.null(ch[1][[1]])) { data = data[apply(sapply(ch[1][[1]], grepl, data$child_id, fixed = T), 1, any),]}
  if(!is.null(ch[2][[1]])) { data = data[apply(sapply(ch[2][[1]], grepl, data$child_gender, fixed = T), 1, any),]}
  if(!is.null(ch[3][[1]])) { data = data[apply(sapply(ch[3][[1]], grepl, data$child_race, fixed = T), 1, any),]}
  if(!is.null(ch[4][[1]])) { data = data[apply(sapply(ch[4][[1]], grepl, data$child_perceived_age, fixed = T), 1, any),]}
  if(!is.null(ch[5][[1]])) { data = data[data$how_got_away %in% ch[5][[1]],]}
  if(!is.null(ch[6][[1]])) { data = data[data$child_amount %in% ch[6][[1]],]}

  # handle the offender tab
  if(!is.null(o[1][[1]])) { data = data[apply(sapply(o[1][[1]], grepl, data$offender_method, fixed = T), 1, any),]}
  if(!is.null(o[2][[1]])) { data = data[apply(sapply(o[2][[1]], grepl, data$offender_gender, fixed = T), 1, any),]}
  if(!is.null(o[3][[1]])) { data = data[apply(sapply(o[3][[1]], grepl, data$offender_race, fixed = T), 1, any),]}
  if(!is.null(o[4][[1]])) { data = data[apply(sapply(o[4][[1]], grepl, data$offender_age, fixed = T), 1, any),]}
  if(!is.null(o[5][[1]])) { data = data[apply(sapply(o[5][[1]], grepl, data$offender_perceived_age, fixed = T), 1, any),]}
  if(!is.null(o[6][[1]])) { data = data[data$offender_amount %in% o[6][[1]],]}

  # handle the vehicle tab
  if(!is.null(v[1][[1]])) { data = data[apply(sapply(v[1][[1]], grepl, data$vehicle_color, fixed = T), 1, any),]}
  if(!is.null(v[2][[1]])) { data = data[apply(sapply(v[2][[1]], grepl, data$vehicle_style, fixed = T), 1, any),]}

  return (data)
}

# create the child pie chart
create_child_pie = function(m, a, type, loc) {
  if(!is.null(loc[1][[1]])) { m = m[m$missing_state %in% loc[1][[1]],]}
  if(!is.null(loc[2][[1]])) { m = m[m$missing_city %in% loc[2][[1]],]}
  if(!is.null(loc[3][[1]])) { m = m[m$missing_zip %in% loc[3][[1]],]}
  if(!is.null(loc[1][[1]])) { a = a[a$incident_state %in% loc[1][[1]],]}
  if(!is.null(loc[2][[1]])) { a = a[a$incident_city %in% loc[2][[1]],]}
  if(!is.null(loc[3][[1]])) { a = a[a$incident_zip %in% loc[3][[1]],]}
  if (type == "gender") {
    labels = c("Male", "Female", "Unknown")
    values = c(
      table(m$gender)[[2]] + table(unlist(strsplit(as.character(a$child_gender), "/")))[[2]],
      table(m$gender)[[1]] + table(unlist(strsplit(as.character(a$child_gender), "/")))[[1]],
      table(unlist(strsplit(as.character(a$child_gender), "/")))[[3]]
    )
  } else if (type == "race") {
    labels = c("Am. Ind.", "Asian", "Biracial", "Black", "Hispanic", "Pacific Islander", "Unknown", "White")
    values = c(
      table(m$race)[[1]] + table(unlist(strsplit(as.character(a$child_race), "/")))[[1]],
      table(m$race)[[2]] + table(unlist(strsplit(as.character(a$child_race), "/")))[[2]],
      table(m$race)[[3]] + table(unlist(strsplit(as.character(a$child_race), "/")))[[3]],
      table(m$race)[[4]] + table(unlist(strsplit(as.character(a$child_race), "/")))[[4]],
      table(m$race)[[5]] + table(unlist(strsplit(as.character(a$child_race), "/")))[[5]],
      table(m$race)[[6]] + table(unlist(strsplit(as.character(a$child_race), "/")))[[6]],
      table(m$race)[[7]] + table(unlist(strsplit(as.character(a$child_race), "/")))[[7]],
      table(m$race)[[8]] + table(unlist(strsplit(as.character(a$child_race), "/")))[[8]]
    )
  }
  p = plot_ly(labels = labels, values = values, type = 'pie')
  return (p)
}

# create the offender pie chart
create_offender_pie = function(m, a, type, loc) {
  if(!is.null(loc[1][[1]])) { m = m[m$missing_state %in% loc[1][[1]],]}
  if(!is.null(loc[2][[1]])) { m = m[m$missing_city %in% loc[2][[1]],]}
  if(!is.null(loc[3][[1]])) { m = m[m$missing_zip %in% loc[3][[1]],]}
  if(!is.null(loc[1][[1]])) { a = a[a$incident_state %in% loc[1][[1]],]}
  if(!is.null(loc[2][[1]])) { a = a[a$incident_city %in% loc[2][[1]],]}
  if(!is.null(loc[3][[1]])) { a = a[a$incident_zip %in% loc[3][[1]],]}
  if (type == "gender") {
    labels = c("Male", "Female", "Unknown")
    values = c(
      table(unlist(strsplit(as.character(a$offender_gender), "/")))[[2]],
      table(unlist(strsplit(as.character(a$offender_gender), "/")))[[1]],
      table(unlist(strsplit(as.character(a$offender_gender), "/")))[[3]]
    )
  } else if (type == "race") {
    labels = c("Am. Ind.", "Asian", "Biracial", "Black", "Hispanic", "Pacific Islander", "Unknown", "White")
    values = c(
      table(unlist(strsplit(as.character(a$offender_race), "/")))[[1]],
      table(unlist(strsplit(as.character(a$offender_race), "/")))[[2]],
      table(unlist(strsplit(as.character(a$offender_race), "/")))[[3]],
      table(unlist(strsplit(as.character(a$offender_race), "/")))[[4]],
      table(unlist(strsplit(as.character(a$offender_race), "/")))[[6]],
      table(unlist(strsplit(as.character(a$offender_race), "/")))[[7]],
      table(unlist(strsplit(as.character(a$offender_race), "/")))[[8]],
      table(unlist(strsplit(as.character(a$offender_race), "/")))[[10]]
    )
  } else {
    labels = c("animal", "candy", "money", "other", "ride")
    values = c(
      table(unlist(strsplit(as.character(a$offender_method), "/")))[[1]],
      table(unlist(strsplit(as.character(a$offender_method), "/")))[[2]],
      table(unlist(strsplit(as.character(a$offender_method), "/")))[[3]],
      table(unlist(strsplit(as.character(a$offender_method), "/")))[[4]],
      table(unlist(strsplit(as.character(a$offender_method), "/")))[[5]]
    )
  }

  p = plot_ly(labels = labels, values = values, type = 'pie')
  return (p)
}
