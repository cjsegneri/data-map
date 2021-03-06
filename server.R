
function(input, output, session) {

  # set the initial dates
  updateDateRangeInput(session, "k_date_range", label = "Show Incidents Between",
                       start = kidnapping.date.first, end = kidnapping.date.last)
  updateDateRangeInput(session, "m_date_range", label = "Show Incidents Between",
                       start = missing.date.first, end = missing.date.last)

  output$download_link <- downloadHandler(
    filename = function(){
      paste0("NCMEC-data",".zip")
    },
    content = function(file){
      #go to a temp dir to avoid permission issues
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      write.csv(missing.download, "Missing-Persons.csv")
      write.csv(kidnapping.download, "Kidnapping-Attempts.csv")
      files = c("Missing-Persons.csv", "Kidnapping-Attempts.csv")
      #create the zip file
      zip(file,files)
    },
    contentType = "application/zip"
  )

  whichSets = reactive({
    if (input$missing_switch & input$kidnapping_switch) { return (1) }
    if (input$missing_switch & !input$kidnapping_switch) { return (2) }
    if (!input$missing_switch & input$kidnapping_switch) { return (3) }
    if (!input$missing_switch & !input$kidnapping_switch) { return (4) }
  })

  getMissing = reactive({
    filtered = missing

    # check for state
    if (!is.null(input$m_state_inp)) { filtered = filtered[filtered$state %in% input$m_state_inp,] }
    # check for city
    if (!is.null(input$m_city_inp)) { filtered = filtered[filtered$city %in% input$m_city_inp,] }
    # check for zip
    if (!is.null(input$m_zip_inp)) { filtered = filtered[filtered$zip %in% input$m_zip_inp,] }
    # check for case number
    if (!is.null(input$m_case_num_inp)) { filtered = filtered[filtered$Case.Number %in% input$m_case_num_inp,] }
    # check for gender
    if (!is.null(input$m_child_gender_inp)) { filtered = filtered[filtered$Gender %in% input$m_child_gender_inp,] }
    # check for race
    if (!is.null(input$m_child_race_inp)) { filtered = filtered[filtered$Race %in% input$m_child_race_inp,] }
    # check for age
    if (!is.null(input$m_child_age_inp)) { filtered = filtered[filtered$Age.Missing %in% input$m_child_age_inp,] }
    # check for vehicle style
    if (!is.null(input$m_veh_style_inp)) { filtered = filtered[filtered$Vehicle.Style %in% input$m_veh_style_inp,] }
    # check for vehicle color
    if (!is.null(input$m_veh_color_inp)) { filtered = filtered[filtered$Vehicle.Color %in% input$m_veh_color_inp,] }
    # check the date
    if (!identical(input$m_date_range, c(missing.date.first, missing.date.last))) {
      filtered = filtered[!is.na(filtered$Missing.Date),]
      filtered = filtered[input$m_date_range[1] < filtered$Missing.Date,]
      filtered = filtered[input$m_date_range[2] > filtered$Missing.Date,]
    }

    missing.download <<- filtered
    return (filtered)
  })

  getKidnapping = reactive({
    filtered = kidnapping

    # check for state
    if (!is.null(input$k_state_inp)) { filtered = filtered[filtered$state %in% input$k_state_inp,] }
    # check for city
    if (!is.null(input$k_city_inp)) { filtered = filtered[filtered$city %in% input$k_city_inp,] }
    # check for zip
    if (!is.null(input$k_zip_inp)) { filtered = filtered[filtered$zip %in% input$k_zip_inp,] }
    # check case type
    if (!is.null(input$k_case_type_inp)) { filtered = filtered[filtered$Case.Type %in% input$k_case_type_inp,] }
    # check case number
    if (!is.null(input$k_case_num_inp)) { filtered = filtered[filtered$Case.Number %in% input$k_case_num_inp,] }
    # check status
    if (!is.null(input$k_status_inp)) { filtered = filtered[filtered$Status %in% input$k_status_inp,] }
    # check source
    if (!is.null(input$k_source_inp)) { filtered = filtered[filtered$Source %in% input$k_source_inp,] }
    # check child id
    if (!is.null(input$k_child_id_inp)) { filtered = filtered[filtered$Child.ID.1 %in% input$k_child_id_inp,] }
    # check child race
    if (!is.null(input$k_child_race_inp)) { filtered = filtered[filtered$Child.Race.1 %in% input$k_child_race_inp,] }
    # check child gender
    if (!is.null(input$k_child_gender_inp)) { filtered = filtered[filtered$Child.Gender.1 %in% input$k_child_gender_inp,] }
    # check child perceived age
    if (!is.null(input$k_child_perc_age_inp)) { filtered = filtered[filtered$Child.Perceived.Age.1 %in% input$k_child_perc_age_inp,] }
    # check offender race
    if (!is.null(input$k_off_race_inp)) { filtered = filtered[filtered$Offender.Race.1 %in% input$k_off_race_inp,] }
    # check offender gender
    if (!is.null(input$k_off_gender_inp)) { filtered = filtered[filtered$Offender.Gender.1 %in% input$k_off_gender_inp,] }
    # check offender age
    if (!is.null(input$k_off_age_inp)) { filtered = filtered[filtered$Offender.Age.1 %in% input$k_off_age_inp,] }
    # check offender perceived age
    if (!is.null(input$k_off_perc_age_inp)) { filtered = filtered[filtered$Offender.Perceived.Age.1 %in% input$k_off_perc_age_inp,] }
    # check the date
    if (!identical(input$k_date_range, c(kidnapping.date.first, kidnapping.date.last))) {
      filtered = filtered[!is.na(filtered$Incident.Date),]
      filtered = filtered[input$k_date_range[1] < filtered$Incident.Date,]
      filtered = filtered[input$k_date_range[2] > filtered$Incident.Date,]
    }

    kidnapping.download <<- filtered
    return (filtered)
  })

  output$map = renderLeaflet({

    # read in the missing and kidnapping data
    missing.filtered = getMissing()
    kidnapping.filtered = getKidnapping()

    # read in which datasets to show
    sets = whichSets()

    # create the labels
    missing.popup = paste(sep = "<br/>",
                          "<center><b>Location Info</b></center>",
                          paste0("State: ", missing.filtered$state),
                          paste0("City: ", missing.filtered$city),
                          paste0("Zipcode: ", missing.filtered$zip, "<br/>"),
                          "<center><b>Child Info</b></center>",
                          paste0("Case Number: ", missing.filtered$Case.Number),
                          paste0("Child Race: ", missing.filtered$Race),
                          paste0("Child Gender: ", missing.filtered$Gender),
                          paste0("Child Age: ", missing.filtered$Age.Missing, "<br/>"),
                          "<center><b>Vehicle Info</b></center>",
                          paste0("Vehicle Style: ", missing.filtered$Vehicle.Style),
                          paste0("Vehicle Color: ", missing.filtered$Vehicle.Color)
                          )
    kidnapping.popup = paste(sep = "<br/>",
                             "<center><b>Location Info</b></center>",
                             paste0("State: ", kidnapping.filtered$state),
                             paste0("City: ", kidnapping.filtered$city),
                             paste0("Zipcode: ", kidnapping.filtered$zip, "<br/>"),
                             "<center><b>Case Info</b></center>",
                             paste0("Case Type: ", kidnapping.filtered$Case.Type),
                             paste0("Case Number: ", kidnapping.filtered$Case.Number),
                             paste0("Status: ", kidnapping.filtered$Status),
                             paste0("Source: ", kidnapping.filtered$Source, "<br/>"),
                             "<center><b>Child Info</b></center>",
                             paste0("Child ID: ", kidnapping.filtered$Child.ID.1),
                             paste0("Child Race: ", kidnapping.filtered$Child.Race.1),
                             paste0("Child Gender: ", kidnapping.filtered$Child.Gender.1),
                             paste0("Child Perceived Age: ", kidnapping.filtered$Child.Perceived.Age.1, "<br/>"),
                             "<center><b>Offender Info</b></center>",
                             paste0("Offender Race: ", kidnapping.filtered$Offender.Race.1),
                             paste0("Offender Gender: ", kidnapping.filtered$Offender.Gender.1),
                             paste0("Offender Age: ", kidnapping.filtered$Offender.Age.1),
                             paste0("Offender Perceived Age: ", kidnapping.filtered$Offender.Perceived.Age.1, "<br/>"),
                             "<center><b>Vehicle Info</b></center>",
                             paste0("Vehicle Style: ", kidnapping.filtered$Vehicle.Style.1),
                             paste0("Vehicle Color: ", kidnapping.filtered$Vehicle.Color.1)
                             )

    # create the map
    if (sets == 1) {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>%
        addCircleMarkers(
          data = missing.filtered, lng = ~longitude, lat = ~latitude, color = "#C39BD3",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(195,155,211,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          ),
          popup = missing.popup
                                                  ) %>%
        addCircleMarkers(
          data = kidnapping.filtered, lng = ~longitude, lat = ~latitude, color = "#82E0AA",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(130,224,170,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          ),
          popup = kidnapping.popup
                                                  ) %>%
        addLegend(
          "bottomleft", title = "Datasets", labels = c("Missing Persons", "Attempted Kidnapping"),
          colors = c("#C39BD3","#82E0AA"), opacity = 0.5
        )
    } else if (sets == 2) {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>%
        addCircleMarkers(
          data = missing.filtered, lng = ~longitude, lat = ~latitude, color = "#C39BD3",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(195,155,211,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          ),
          popup = missing.popup
                                                  ) %>%
        addLegend(
          "bottomleft", title = "Datasets", labels = c("Missing Persons", "Attempted Kidnapping"),
          colors = c("#C39BD3","#82E0AA"), opacity = 0.5
        )
    } else if (sets == 3) {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>%
        addCircleMarkers(
          data = kidnapping.filtered, lng = ~longitude, lat = ~latitude, color = "#82E0AA",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(130,224,170,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          ),
          popup = kidnapping.popup
                                                  ) %>%
        addLegend(
          "bottomleft", title = "Datasets", labels = c("Missing Persons", "Attempted Kidnapping"),
          colors = c("#C39BD3","#82E0AA"), opacity = 0.5
        )
    } else {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron)
    }
  })

  output$pie_chart = renderPlotly({
    colors = c(
      "#EC7063",
      "#5499C7",
      "#58D68D",
      "#F5B041"
    )
    labels = c(
      "Used an Animal",
      "Offered Candy",
      "Offered Money",
      "Offered a Car Ride"
    )
    values = c(
      table(kidnapping.download$Offender.Method.Animal)[[2]],
      table(kidnapping.download$Offender.Method.Candy)[[2]],
      table(kidnapping.download$Offender.Method.Money)[[2]],
      table(kidnapping.download$Offender.Method.Ride)[[2]]
    )
    plot_ly(labels = labels, values = values, type = 'pie',
                 textposition = 'inside',
                 textinfo = 'label+percent',
                 hoverinfo = 'text',
                 text = ~paste(values, ' occurences'),
                 marker = list(colors = colors,
                               line = list(color = '#FFFFFF', width = 1)),
                 #The 'pull' attribute can also be used to create space between the sectors
                 showlegend = FALSE) %>%
      layout(title = "Kidnapping Methodologies")
  })

  output$gender_plot = renderPlotly({
    x = c(
      "Male",
      "Female",
      "Unknown"
    )
    child = c(
      table(kidnapping.download$Child.Gender.1)[[2]],
      table(kidnapping.download$Child.Gender.1)[[1]],
      table(kidnapping.download$Child.Gender.1)[[3]]
    )
    offender = c(
      table(kidnapping.download$Offender.Gender.1)[[3]],
      table(kidnapping.download$Offender.Gender.1)[[2]],
      table(kidnapping.download$Offender.Gender.1)[[4]]
    )
    plot_ly(x = x, y = child, type = 'bar', name = "Child") %>%
      add_trace(y = offender, name = "Offender")
  })

  output$race_plot = renderPlotly({
    x = c(
      "Am. Ind.",
      "Asian",
      "Biracial",
      "Black",
      "Hispanic",
      "Unknown",
      "White"
    )
    child = c(
      table(kidnapping.download$Child.Race.1)[[1]],
      table(kidnapping.download$Child.Race.1)[[2]],
      table(kidnapping.download$Child.Race.1)[[3]],
      table(kidnapping.download$Child.Race.1)[[4]],
      table(kidnapping.download$Child.Race.1)[[5]],
      table(kidnapping.download$Child.Race.1)[[6]],
      table(kidnapping.download$Child.Race.1)[[7]]
    )
    offender = c(
      table(kidnapping.download$Offender.Race.1)[[2]],
      table(kidnapping.download$Offender.Race.1)[[3]],
      table(kidnapping.download$Offender.Race.1)[[4]],
      table(kidnapping.download$Offender.Race.1)[[5]],
      table(kidnapping.download$Offender.Race.1)[[6]],
      table(kidnapping.download$Offender.Race.1)[[8]],
      table(kidnapping.download$Offender.Race.1)[[10]]
    )
    plot_ly(x = x, y = child, type = 'bar', name = "Child") %>%
      add_trace(y = offender, name = "Offender")
  })

  output$heatmap = renderLeaflet({
    # read in the shape file
    usgeo = read_shape(file = "cb_2016_us_state_5m/cb_2016_us_state_5m.shp", as.sf = TRUE)

    # get a table of the frequencies of incidents in each state
    kidnapping_table_by_state = as.data.frame(table(kidnapping.download$Incident.State))

    # convert factors into characters
    usgeo$STUSPS = as.character(usgeo$STUSPS)
    kidnapping_table_by_state$Var1 = as.character(kidnapping_table_by_state$Var1)

    # order the columns by state
    usgeo = usgeo[order(usgeo$STUSPS),]
    kidnapping_table_by_state = kidnapping_table_by_state[order(kidnapping_table_by_state$Var1),]

    # get the states that are not in both columns
    removed_states = usgeo$STUSPS[!usgeo$STUSPS %in% kidnapping_table_by_state$Var1]
    # remove these states
    usgeo = usgeo[!usgeo$STUSPS %in% removed_states,]

    # make sure the column names are the same
    colnames(kidnapping_table_by_state)[1] = "STUSPS"

    # merge the data
    usmap = append_data(usgeo, kidnapping_table_by_state, key.shp = "STUSPS", key.data = "STUSPS")

    # create the leaflet palette
    mypalette = colorNumeric(palette = "Reds", domain = usmap$Freq)

    # create the popup window
    us_popup = paste0("<b>State: ", usmap$NAME, "</b></br>", "Incidents: ", usmap$Freq)

    # display the map
    leaflet(usmap, width = "100%") %>%
      setView(lng = -97, lat = 42, zoom = 3) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(stroke = FALSE,
                  smoothFactor = 0.2,
                  fillOpacity = 0.8,
                  popup = us_popup,
                  color = ~mypalette(usmap$Freq)
      )
  })

}
