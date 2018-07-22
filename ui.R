
## filter options UI ##
missingFilters <<- tabBox(width = NULL, title = "Missing Child Filters",
                         tabPanel("Case",
                                  selectInput("m_case_number", "Case Number", multiple = T,
                                              sort(unique(missing$case_number))),
                                  selectInput("m_case_type", "Case Type", multiple = T,
                                              sort(unique(missing$case_type)))
                         ),
                         tabPanel("Location",
                                  selectInput("m_state", "Missing State",multiple = T,
                                              sort(unique(missing$missing_state))),
                                  selectInput("m_city", "Missing City",multiple = T,
                                              sort(unique(missing$missing_city))),
                                  selectInput("m_zip", "Missing Zipcode",multiple = T,
                                              sort(unique(missing$missing_zip)))
                         ),
                         tabPanel("Child",
                                  dateRangeInput("m_date", "Date Missing",
                                                 start = min(missing$missing_date), end = max(missing$missing_date)),
                                  selectInput("m_age", "Age Missing",multiple = T,
                                              sort(unique(missing$age_missing))),
                                  selectInput("m_gender", "Child Gender",multiple = T,
                                              sort(unique(missing$gender))),
                                  selectInput("m_race", "Child Race",multiple = T,
                                              sort(unique(missing$race)))
                         ),
                         tabPanel("Vehicle",
                                  selectInput("m_veh_color", "Vehicle Color",multiple = T,
                                              sort(unique(missing$vehicle_color))),
                                  selectInput("m_veh_style", "Vehicle Style",multiple = T,
                                              sort(unique(missing$vehicle_style)))
                         )
 )

abductionFilters <<- tabBox(width = NULL, title = "Attempted Abduction Filters",
                          tabPanel("Case",
                                   selectInput("a_case_number", "Case Number", multiple = T,
                                               sort(unique(abductions$case_number))),
                                   selectInput("a_case_type", "Case Type", multiple = T,
                                               sort(unique(abductions$case_type))),
                                   selectInput("a_case_status", "Case Status", multiple = T,
                                               sort(unique(abductions$status))),
                                   selectInput("a_incident_type", "Incident Type", multiple = T,
                                               sort(unique(abductions$incident_type))),
                                   dateRangeInput("a_date", "Incident Date",
                                                  start = min(abductions$incident_date), end = max(abductions$incident_date))
                         ),
                         tabPanel("Location",
                                  selectInput("a_state", "Incident State", multiple = T,
                                              sort(unique(abductions$incident_state))),
                                  selectInput("a_city", "Incident City", multiple = T,
                                              sort(unique(abductions$incident_city))),
                                  selectInput("a_county", "Incident County", multiple = T,
                                              sort(unique(abductions$incident_county))),
                                  selectInput("a_zip", "Incident Zipcode", multiple = T,
                                              sort(unique(abductions$incident_zip))),
                                  selectInput("a_address", "Incident Address", multiple = T,
                                              sort(unique(abductions$incident_location))),
                                  selectInput("a_location_type", "Incident Location Type", multiple = T,
                                              sort(unique(abductions$incident_location_type))),
                                  selectInput("a_lea", "Incident LEA", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$LEA), "/")))))
                         ),
                         tabPanel("Child",
                                  selectInput("a_child_id", "Child ID", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$child_id), "/"))))),
                                  selectInput("a_child_gender", "Child Gender", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$child_gender), "/"))))),
                                  selectInput("a_child_race", "Child Race", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$child_race), "/"))))),
                                  selectInput("a_child_page", "Child Perceived Age", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$child_perceived_age), "/"))))),
                                  selectInput("a_child_away", "How Child Got Away", multiple = T,
                                              sort(unique(abductions$how_got_away))),
                                  selectInput("a_child_amount", "Number of Children Involved", multiple = T,
                                              sort(unique(abductions$child_amount)))
                         ),
                         tabPanel("Offender",
                                  selectInput("a_offender_method", "Offender Method", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$offender_method), "/"))))),
                                  selectInput("a_offender_gender", "Offender Gender", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$offender_gender), "/"))))),
                                  selectInput("a_offender_race", "Offender Race", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$offender_race), "/"))))),
                                  selectInput("a_offender_age", "Offender Age", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$offender_age), "/"))))),
                                  selectInput("a_offender_page", "Offender Perceived Age", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$offender_perceived_age), "/"))))),
                                  selectInput("a_offender_amount", "Number of Offenders Involved", multiple = T,
                                              sort(unique(abductions$offender_amount)))
                         ),
                         tabPanel("Vehicle",
                                  selectInput("a_vehicle_color", "Vehicle Color", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$vehicle_color), "/"))))),
                                  selectInput("a_vehicle_style", "Vehicle Style", multiple = T,
                                              sort(unique(unlist(strsplit(as.character(abductions$vehicle_style), "/")))))
                         )
)

missingTable <<- box(width = NULL, title = "Missing Children Data Table", status = "warning",
                     div(style = 'overflow-y: scroll', dataTableOutput("missing_table")),
                     actionLink("data_btn", "", icon = icon("question"), class = "leftAlign"),
                     downloadLink("down_data_tables", "Download", class = "rightAlign")
)

abductionTable <<- box(width = NULL, title = "Attempted Abductions Data Table", status = "warning",
                       div(style = 'overflow-y: scroll', dataTableOutput("abduction_table")),
                       actionLink("data_btn", "", icon = icon("question"), class = "leftAlign"),
                       downloadLink("down_data_tables", "Download", class = "rightAlign")
)



## main UI ##
dashboardPage(skin = "yellow",
  dashboardHeader(title = "NCMEC Analysis Tool"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Homepage", tabName = "homepage", icon = icon("home")),
      menuItem("Data Map", tabName = "datamap", icon = icon("map-marker")),
      menuItem("Data Table", tabName = "datatable", icon = icon("table")),
      menuItem("Pie Charts", tabName = "piechart", icon = icon("pie-chart"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "homepage",
        h1("Welcome to the National Center for Missing and Exploited Children Data Analysis Tool"),
        HTML("<br/>"),
        h3("By Connor Segneri - connorsegneri@gmail.com"),
        HTML("<br/><br/>"),
        column(6,
          box(width = NULL, title = "About this Tool", solidHeader = T,
            h4("This tool allows the user to visualize, filter, and download missing children and attempted kidnapping data provided by the National Council of Missing and Exploited Children. The \"Data Map\" tab displays the incidents across the United States and allows the user to visualize the filters that they apply to the data sets. The \"Data Table\" tab shows the user a classic \"excel spreadsheet\" view of the data that they can filter, sort, and search through. The \"Pie Charts\" tab shows the overall race, gender, and methods of the children and offenders for filterable locations. For more instructions, select the question mark buttons located in each tab's page.")
          )
        )
      ),
      tabItem(tabName = "datamap",
        fluidRow(tags$head(tags$style(".leftAlign{float:left;}")), tags$head(tags$style(".rightAlign{float:right;}")),
          column(4, align = 'center',
            fluidRow(missingFilters),
            fluidRow(abductionFilters)
          ),
          column(8,
            box(width = NULL, status = "warning",
              actionLink("map_btn", "", icon = icon("question"), class = "leftAlign"),
              downloadLink("down_map", "Download", class = "rightAlign"),
              HTML("<br/>"),
              tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
              leafletOutput("map")
            )

          )
        )
      ),
      tabItem(tabName = "datatable",
        fluidRow(
          column(12, align = 'center',
            selectInput("dt_select", "Select Data Set", choices = c(
                          "Missing Children Set" = "mc",
                          "Attempted Abductions Set" = "aa"))
          )
        ),
        fluidRow(tags$head(tags$style(".leftAlign{float:left;}")), tags$head(tags$style(".rightAlign{float:right;}")),
          column(4, align = 'center',
            actionLink("data_filter_btn", "", icon = icon("question"), class = "leftAlign"),
            uiOutput("dt_filters")
          ),
          column(8, align = 'center',
            uiOutput("dt_tables")
          )
        )
      ),
      tabItem(tabName = "piechart",
        fluidRow(tags$head(tags$style(".leftAlign{float:left;}")),
          column(3, align = 'center',
            box(width = NULL, title = "Locations Filters", status = "primary",
              actionLink("pie_filter_btn", "", icon = icon("question"), class = "leftAlign"),
              HTML("<br/>"),
              selectInput("pie_state", "State", multiple = T, choices = c(
                sort(unique(c(as.character(missing$missing_state), as.character(abductions$incident_state)))))),
              selectInput("pie_city", "City", multiple = T, choices = c(
                sort(unique(c(as.character(missing$missing_city), as.character(abductions$incident_city)))))),
              selectInput("pie_zip", "Zipcode", multiple = T, choices = c(
                sort(unique(c(as.character(missing$missing_zip), as.character(abductions$incident_zip))))))
            )
          ),
          column(9, align = 'center',
            box(width = NULL, title = "Pie Charts", status = "warning",
              fluidRow(
                column(6,
                  selectInput("pie_child_select", "Child Chart Options", choices = c(
                    "Gender" = "gender",
                    "Race" = "race")),
                  plotlyOutput("pie_child")
                ),
                column(6,
                  selectInput("pie_offender_select", "Offender Chart Options", choices = c(
                    "Gender" = "gender",
                    "Race" = "race",
                    "Method" = "method")),
                  plotlyOutput("pie_offender")
                )
              ),
              actionLink("pie_btn", "", icon = icon("question"), class = "leftAlign")
            )
          )
        )
      )
    )
  )
)
