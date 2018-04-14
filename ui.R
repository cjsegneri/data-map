
dashboardPage(skin = "yellow",
  dashboardHeader(title = "NCMEC DAT"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Homepage", tabName = "homepage", icon = icon("home")),
      menuItem("Data Map", tabName = "datamap", icon = icon("map-marker")),
      menuItem("Data Table", tabName = "datatable", icon = icon("table")),
      menuItem("Pie Chart", tabName = "piechart", icon = icon("pie-chart")),
      menuItem("Bar Plot", tabName = "barplot", icon = icon("bar-chart")),
      menuItem("Heat Map", tabName = "heatmap", icon = icon("map"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "homepage",
        h2("Homepage")
      ),
      tabItem(tabName = "datamap",
        h2("Data Map")
      ),
      tabItem(tabName = "datatable",
        fluidRow(
          column(4, align = 'center',
            tabBox(width = NULL, title = "Missing Child Filters",
              tabPanel("Case",
                selectInput("m_case_number", "Case Number", sort(unique(missing$case_number))),
                selectInput("m_case_type", "Case Type", sort(unique(missing$case_type)))
              ),
              tabPanel("Location",
                selectInput("m_state", "Missing State", sort(unique(missing$missing_state))),
                selectInput("m_city", "Missing City", sort(unique(missing$missing_city))),
                selectInput("m_zip", "Missing Zipcode", sort(unique(missing$missing_zip)))
              ),
              tabPanel("Child",
                selectInput("m_date", "Date Missing", sort(unique(missing$missing_date))),
                selectInput("m_age", "Age Missing", sort(unique(missing$age_missing))),
                selectInput("m_gender", "Child Gender", sort(unique(missing$gender))),
                selectInput("m_race", "Child Race", sort(unique(missing$race)))
              ),
              tabPanel("Vehicle",
                selectInput("m_veh_color", "Vehicle Color", sort(unique(missing$vehicle_color))),
                selectInput("m_veh_style", "Vehicle Style", sort(unique(missing$vehicle_style)))
              )
            )
          ),
          column(8, align = 'center',
            box(width = NULL, title = "Data Table", status = "warning",
              div(style = 'overflow-y: scroll', dataTableOutput("missing_table"))
            )
          )
        )
      ),
      tabItem(tabName = "piechart",
        h2("Pie Chart")
      ),
      tabItem(tabName = "barplot",
        h2("Bar Plot")
      ),
      tabItem(tabName = "heatmap",
        h2("Heat Map")
      )
    )
  )
)
