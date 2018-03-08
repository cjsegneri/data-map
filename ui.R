
header <- dashboardHeader(
  title = "NCMEC Data Map"
)

body <- dashboardBody(
  fluidRow(tags$head(tags$style(".rightAlign{float:right;}")),
    column(width = 8,
           tabBox(width = NULL, title = "Data Visualization",
                  tabPanel(title = "Data Map",
                    leafletOutput("map", height = 600),
                    downloadLink("download_link", label = "Download Filtered Data")
                  ),
                  tabPanel(title = "Plots/Charts",
                           tabBox(width = NULL,
                             tabPanel(title = "Kidnapping Methodologies",
                                      h5("This pie chart shows the percentages of methods used by offenders in kidnapping attempts in the attempted kidnapping data set."),
                                      HTML("</br>"),
                                      plotlyOutput("pie_chart")
                             )
                           )
                  )
           )
    ),
    column(4,
      tabBox(width = NULL, title = "Map Filters",
             tabPanel("Missing Persons",
                      tabBox(width = NULL,
                             tabPanel("Location",
                                      selectInput("m_state_inp", "State", multiple = TRUE,
                                                  choices = sort(unique(missing$state))),
                                      selectInput("m_city_inp", "City", multiple = TRUE,
                                                  choices = sort(unique(missing$city))),
                                      selectInput("m_zip_inp", "Zipcode", multiple = TRUE,
                                                  choices = sort(unique(missing$zip)))
                                      ),
                             tabPanel("Child",
                                      selectInput("m_case_num_inp", "Case Number", multiple = TRUE,
                                                  choices = sort(unique(missing$Case.Number))),
                                      selectInput("m_child_race_inp", "Child Race", multiple = TRUE,
                                                  choices = sort(unique(missing$Race))),
                                      selectInput("m_child_gender_inp", "Child Gender", multiple = TRUE,
                                                  choices = sort(unique(missing$Gender))),
                                      selectInput("m_child_age_inp", "Child Age", multiple = TRUE,
                                                  choices = sort(unique(missing$Age.Missing)))
                                      ),
                             tabPanel("Vehicle",
                                      selectInput("m_veh_style_inp", "Vehicle Style", multiple = TRUE,
                                                  choices = sort(unique(missing$Vehicle.Style))),
                                      selectInput("m_veh_color_inp", "Vehicle Color", multiple = TRUE,
                                                  choices = sort(unique(missing$Vehicle.Color)))
                                      ),
                             tabPanel("Date",
                                      dateRangeInput("m_date_range", "Show Incidents Between",
                                                     start = NULL, end = NULL),
                                      h5("(the dates are automatically set to the earliest and latest dates found in the data set)")
                             )
                             ),
                      materialSwitch("missing_switch", status = "primary", right = TRUE,
                                     value = TRUE, label = "Include Missing Persons Data Set")
                      ),
             tabPanel("Attempted Kidnapping",
                      tabBox(width = NULL,
                             tabPanel("Location",
                                      selectInput("k_state_inp", "State", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$state))),
                                      selectInput("k_city_inp", "City", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$city))),
                                      selectInput("k_zip_inp", "Zipcode", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$zip)))
                             ),
                             tabPanel("Case",
                                      selectInput("k_case_type_inp", "Case Type", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Case.Type))),
                                      selectInput("k_case_num_inp", "Case Number", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Case.Number))),
                                      selectInput("k_status_inp", "Status", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Status))),
                                      selectInput("k_source_inp", "Source", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Source)))
                             ),
                             tabPanel("Child",
                                      selectInput("k_child_id_inp", "Child ID", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Child.ID.1))),
                                      selectInput("k_child_race_inp", "Child Race", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Child.Race.1))),
                                      selectInput("k_child_gender_inp", "Child Gender", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Child.Gender.1))),
                                      selectInput("k_child_perc_age_inp", "Child Perceived Age", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Child.Perceived.Age.1)))
                             ),
                             tabPanel("Offender",
                                      selectInput("k_off_race_inp", "Offender Race", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Offender.Race.1))),
                                      selectInput("k_off_gender_inp", "Offender Gender", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Offender.Gender.1))),
                                      selectInput("k_off_age_inp", "Offender Age", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Offender.Age.1))),
                                      selectInput("k_off_perc_age_inp", "Offender Perceived Age", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Offender.Perceived.Age.1)))
                             ),
                             tabPanel("Vehicle",
                                      selectInput("k_vehicle_style", "Vehicle Style", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Vehicle.Style.1))),
                                      selectInput("k_vehicle_color", "Vehicle Color", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$Vehicle.Color.1)))
                                      ),
                             tabPanel("Date",
                                      dateRangeInput("k_date_range", "Show Incidents Between",
                                                     start = NULL, end = NULL),
                                      h5("(the dates are automatically set to the earliest and latest dates found in the data set)")
                                      )
                      ),
                      materialSwitch("kidnapping_switch", status = "primary", right = TRUE,
                                     value = TRUE, label = "Include Attempted Kidnapping Data Set")
             )
      )
    )
  )
)

ui = dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
