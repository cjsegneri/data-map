
header <- dashboardHeader(
  title = "NCMEC Data Map"
)

body <- dashboardBody(
  fluidRow(tags$head(tags$style(".rightAlign{float:right;}")),
    column(width = 8,
           box(width = NULL, title = "Map View", solidHeader = TRUE,
               status = "warning",
               leafletOutput("map", height = 600)
           )
    ),
    column(4,
      tabBox(width = NULL, title = "Data Filters",
             tabPanel("Missing Persons Set",
                      materialSwitch("missing_switch", status = "primary", right = TRUE,
                                     value = TRUE, label = "Include Missing Persons Data Set"),
                      tabBox(width = NULL,
                             tabPanel("Location",
                                      selectInput("m_state_inp", "State", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$state))),
                                      selectInput("m_city_inp", "City", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$city))),
                                      selectInput("m_zip_inp", "Zipcode", multiple = TRUE,
                                                  choices = sort(unique(kidnapping$zip)))
                                      ),
                             tabPanel("Child",
                                      selectInput("m_case_num_inp", "Case Number", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("m_child_race_inp", "Child Race", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("m_child_gender_inp", "Child Gender", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("m_child_age_inp", "Child Age", multiple = TRUE,
                                                  choices = c())
                                      ),
                             tabPanel("Vehicle",
                                      selectInput("m_veh_style_inp", "Vehicle Style", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("m_veh_color_inp", "Vehicle Color", multiple = TRUE,
                                                  choices = c())
                                      )
                             )
                      ),
             tabPanel("Attempted Kidnapping Set",
                      materialSwitch("kidnapping_switch", status = "primary", right = TRUE,
                                     value = TRUE, label = "Include Attempted Kidnapping Data Set"),
                      tabBox(width = NULL,
                             tabPanel("Location",
                                      selectInput("k_state_inp", "State", multiple = TRUE,
                                                  choices = sort(unique(missing$state))),
                                      selectInput("k_city_inp", "City", multiple = TRUE,
                                                  choices = sort(unique(missing$city))),
                                      selectInput("k_zip_inp", "Zipcode", multiple = TRUE,
                                                  choices = sort(unique(missing$zip)))
                             ),
                             tabPanel("Case",
                                      selectInput("k_case_type_inp", "Case Type", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_case_num_inp", "Case Number", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_status_inp", "Status", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_source_inp", "Source", multiple = TRUE,
                                                  choices = c())
                             ),
                             tabPanel("Child",
                                      selectInput("k_child_id_inp", "Child ID", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_child_race_inp", "Child Race", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_child_gender_inp", "Child Gender", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_child_perc_age_inp", "Child Perceived Age", multiple = TRUE,
                                                  choices = c())
                             ),
                             tabPanel("Offender",
                                      selectInput("k_off_race_inp", "Offender Race", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_off_gender_inp", "Offender Gender", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_off_age_inp", "Offender Age", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_off_perc_age_inp", "Offender Perceived Age", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_vehicle_inp", "Vehicle Style", multiple = TRUE,
                                                  choices = c()),
                                      selectInput("k_method_inp", "Offender Method", multiple = TRUE,
                                                  choices = c())
                             )
                      )
             ),
             downloadButton("download_btn", "Download Filtered Data")
      )
    )
  )
)

ui = dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
