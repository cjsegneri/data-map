
header <- dashboardHeader(
  title = "NCMEC Data Map"
)

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("map", height = 500)
           ),
           box(width = NULL, status = "warning",
               checkboxGroupInput("mapOption",
                                  "Choose Databases",
                                  choices = c("Missing Children Data (Red)" = "miss",
                                              "Incidents Data (Blue)" = "inci"),
                                  selected = c("miss","inci")),
               actionButton("reset", "Reset Map"),
               div(style="display:inline-block",
                   downloadButton("downloadData1", "Download Incident Query"),
                   style="float:center"),

               div(style="display:inline-block",
                   downloadButton("downloadData2", "Download Missing Query"),
                   style="float:center")
           )
    ),
    column(width = 3,
           tabBox(width = NULL, title = "Filtering Options",
                  tabPanel("Location",
                           selectInput("state", "State", choices = sort(c(as.character(attempts$Incident.State),
                                                                          as.character(missing$Missing.State))),
                                       multiple = TRUE),

                           selectInput("city", "City", choices = sort(c(as.character(attempts$Incident.City),
                                                                        as.character(missing$Missing.City))),
                                       multiple = TRUE),

                           selectInput("zip", "Zip", choices = sort(c(attempts$Zip.Code,missing$Zip.Code)),
                                       multiple = TRUE)
                           ),
                  tabPanel("Child",
                           selectInput("caseID", "Case ID", choices = sort(c(attempts$Case.Number,missing$Case.Number)),
                                       multiple = TRUE),

                           selectInput("gender", "Gender", choices = sort(c(as.character(attempts$Child.Gender.1),
                                                                            as.character(missing$Gender))),
                                       multiple = TRUE),

                           selectInput("race", "Race", choices = sort(c(as.character(attempts$Child.Race.1),
                                                                        as.character(missing$Race))),
                                       multiple = TRUE)
                           ),
                  tabPanel("Offender",
                           selectInput("vehstyle", "Vehicle Style", choices = sort(c(as.character(attempts$Vehicle.Style.1),
                                                                                     as.character(missing$Vehicle.Style))),
                                       multiple = TRUE),

                           selectInput("vehcolor", "Vehicle Color", choices = sort(c(as.character(attempts$Vehicle.Color.1),
                                                                                     as.character(missing$Vehicle.Color))),
                                       multiple = TRUE)
                           )
           ),
           tabBox(width = NULL, title = "Missing Person Only Filtering",
                  tabPanel("Case",
                           selectInput("casetype", "Case Type", choices = sort((as.character(attempts$Case.Type))),
                                       multiple = TRUE),

                           selectInput("casestatus", "Case Status", choices = sort(as.character(attempts$Status)),
                                       multiple = TRUE),

                           selectInput("casesource", "Case Source", choices = sort(as.character(attempts$Source)),
                                       multiple = TRUE)
                           ),
                  tabPanel("Location",
                           selectInput("address", "Address", choices = sort(as.character(attempts$Incident.Location)),
                                       multiple = TRUE),

                           selectInput("locationtype", "Location Type", choices = sort(as.character(attempts$Incident.Location.Type)),
                                       multiple = TRUE),

                           selectInput("county", "County", choices = sort(as.character(attempts$Incident.County)),
                                       multiple = TRUE)
                           ),
                  tabPanel("Child",
                           selectInput("childID", "Child ID", choices = sort(c(attempts$Child.ID.1,
                                                                               attempts$Child.ID.2,
                                                                               attempts$Child.ID.3,
                                                                               attempts$Child.ID.4,
                                                                               attempts$Child.ID.5,
                                                                               attempts$Child.ID.6)),
                                       multiple = TRUE),

                           selectInput("gotaway", "How They Got Away", choices = sort(as.character(attempts$How.Got.Away)),
                                       multiple = TRUE)
                           ),
                  tabPanel("Offender",
                           selectInput("offendergender", "Offender Gender", choices = sort(c(as.character(attempts$Offender.Gender.1),
                                                                                             as.character(attempts$Offender.Gender.2),
                                                                                             as.character(attempts$Offender.Gender.3))),
                                       multiple = TRUE),

                           selectInput("offenderage", "Offender Age", choices = sort(c(as.character(attempts$Offender.Age.1),
                                                                                       as.character(attempts$Offender.Age.2),
                                                                                       as.character(attempts$Offender.Age.3))),
                                       multiple = TRUE),

                           selectInput("offenderpercage", "Offender Perceived Age", choices = sort(c(as.character(attempts$Offender.Perceived.Age.1),
                                                                                                     as.character(attempts$Offender.Perceived.Age.2),
                                                                                                     as.character(attempts$Offender.Perceived.Age.3))),
                                       multiple = TRUE),

                           radioButtons("animal", "Used Animals", choices = c("No", "Yes")),

                           radioButtons("candy", "Used Candy", choices = c("No", "Yes")),

                           radioButtons("money", "Used Money", choices = c("No", "Yes")),

                           radioButtons("ride", "Offered a Ride", choices = c("No", "Yes"))
                           )
                  )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
