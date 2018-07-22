
server = function(input, output, session) {

  # get all the missing child set filters
  getMissingFilters = function() {
    filters = list(
      input$m_case_number,
      input$m_case_type,
      input$m_state,
      input$m_city,
      input$m_zip,
      input$m_date,
      input$m_age,
      input$m_gender,
      input$m_race,
      input$m_veh_color,
      input$m_veh_style
    )
    return (filters)
  }

  # get all the abduction set filters
  getAbductionFilters = function() {
    case = list(
      input$a_case_number,
      input$a_case_type,
      input$a_case_status,
      input$a_incident_type,
      input$a_date
    )
    location = list(
      input$a_state,
      input$a_city,
      input$a_county,
      input$a_zip,
      input$a_address,
      input$a_location_type,
      input$a_lea
    )
    child = list(
      input$a_child_id,
      input$a_child_gender,
      input$a_child_race,
      input$a_child_page,
      input$a_child_away,
      input$a_child_amount
    )
    offender = list(
      input$a_offender_method,
      input$a_offender_gender,
      input$a_offender_race,
      input$a_offender_age,
      input$a_offender_page,
      input$a_offender_amount
    )
    vehicle = list(
      input$a_vehicle_color,
      input$a_vehicle_style
    )
    return (list(case, location, child, offender, vehicle))
  }

  # configure the data table tab UI
  output$dt_filters = renderUI({
      if (input$dt_select == "mc") { missingFilters } else { abductionFilters }
  })
  output$dt_tables = renderUI({
    if (input$dt_select == "mc") { missingTable } else { abductionTable }
  })

  # configure the missing data table
  output$missing_table = renderDataTable({
    filter_missing_set(missing_no_postals, getMissingFilters())
  })

  # configure the abduction data table
  output$abduction_table = renderDataTable({
    dt = filter_abduction_set(abductions_no_postals, getAbductionFilters())
    datatable(dt, options = list(pageLength = 5))
  })

  # configure the main leaflet map
  output$map = renderLeaflet({
    # add missing person data
    mis = filter_missing_set(missing, getMissingFilters())
    pops_mis = paste(sep = "<br/>",
                 paste("Case Number:<b>", mis$case_number, "</b>"),
                 paste("Case Type:<b>", mis$case_type, "</b>"),
                 "",
                 paste("Date Missing:<b>", mis$missing_date, "</b>"),
                 paste("Age Missing:<b>", mis$age_missing, "</b>"),
                 paste("Child Gender:<b>", mis$gender, "</b>"),
                 paste("Child Race:<b>", mis$race, "</b>"),
                 "",
                 paste("Vehicle Color:<b>", mis$vehicle_color, "</b>"),
                 paste("Vehicle Style:<b>", mis$vehicle_style, "</b>"))

    # add attempted abduction data
    abd = filter_abduction_set(abductions, getAbductionFilters())
    pops_abd = paste(sep = "<br/>",
                 paste("Case Number:<b>", abd$case_number, "</b>"),
                 paste("Incident Type:<b>", abd$incident_type, "</b>"),
                 paste("Incident Date:<b>", abd$incident_date, "</b>"),
                 "",
                 paste("Incident LEA:<b>", abd$LEA, "</b>"),
                 paste("Incident Incident Address:<b>", abd$incident_location, "</b>"),
                 paste("Incident Location Type:<b>", abd$incident_location_type, "</b>"),
                 "",
                 paste("Child ID:<b>", abd$child_id, "</b>"),
                 paste("Child Gender:<b>", abd$child_gender, "</b>"),
                 paste("Child Race:<b>", abd$child_race, "</b>"),
                 paste("Child Perceived Age:<b>", abd$child_perceived_age, "</b>"),
                 paste("How Child Got Away:<b>", abd$how_got_away, "</b>"),
                 paste("Number of Children:<b>", abd$child_amount, "</b>"),
                 "",
                 paste("Offender Method:<b>", abd$offender_method, "</b>"),
                 paste("Offender Gender:<b>", abd$offender_gender, "</b>"),
                 paste("Offender Race:<b>", abd$offender_race, "</b>"),
                 paste("Offender Age:<b>", abd$offender_age, "</b>"),
                 paste("Number of Offenders:<b>", abd$offender_amount, "</b>"),
                 "",
                 paste("Vehicle Color:<b>", abd$vehicle_color, "</b>"),
                 paste("Vehicle Style:<b>", abd$vehicle_style, "</b>"),
                 "",
                 paste("<center>Offender Statement:<b>"),
                 paste(abd$offender_statement, "</b></center>"))
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = mis, clusterOptions = markerClusterOptions(), popup = pops_mis, color = "blue") %>%
      addCircleMarkers(data = abd, clusterOptions = markerClusterOptions(), popup = pops_abd, color = "red") %>%
      addLegend("topright", colors = c("blue", "red"), labels = c("Missing Children Set", "Attempted Kidnapping Set"), opacity = 1)
  })

  # configure the child pie chart
  output$pie_child = renderPlotly({
    loc = list(input$pie_state, input$pie_city, input$pie_zip)
    create_child_pie(missing_no_postals, abductions_no_postals, input$pie_child_select, loc)
  })

  # configure the offender pie chart
  output$pie_offender = renderPlotly({
    loc = list(input$pie_state, input$pie_city, input$pie_zip)
    create_offender_pie(missing_no_postals, abductions_no_postals, input$pie_offender_select, loc)
  })

  #handle all the downloads
  output$down_data_tables = downloadHandler(
    filename = function() {
      name = ""
      if (input$dt_select == "mc") { name = "missing" } else { name = "abduction" }
      paste(name, "_data_", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      if (input$dt_select == "mc") {
        data = filter_missing_set(missing_no_postals, getMissingFilters())
      } else {
        data = filter_abduction_set(abductions_no_postals, getAbductionFilters())
      }
      write.csv(data, file)
    }
  )
  output$down_map = downloadHandler(
    filename = function() {
      name = ""
      if (input$map_select == "mc") { name = "missing" } else { name = "abduction" }
      paste(name, "_data_", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      if (input$map_select == "mc") {
        data = filter_missing_set(missing_no_postals, getMissingFilters())
      } else {
        data = filter_abduction_set(abductions_no_postals, getAbductionFilters())
      }
      write.csv(data, file)
    }
  )

  # handle all the question buttons
  observeEvent(input$map_filter_btn, {
    showModal(modalDialog(
      title = "Data Map - Filtering Options",
      "The \"Select Data Set\" drop down menu on the page allows you to switch between the two data sets. One being a missing person data set, and the other being an attempted abduction data set. The filtering options are contains in the multi-tabbed box. Each tab contains a different set of filtering options. The attempted abduction data set contains more filtering options than the missing person data set."
    ))
  })
  # handle all the question buttons
  observeEvent(input$map_btn, {
    showModal(modalDialog(
      title = "Data Map - Map View",
      "This is the map view. The filtering options on the left-hand side of the screen will alter the data that is viewable as soon as the filters are put into place. The nodes are clustered to prevent the map from being cluttered. Select a cluster to expand it. Select a single node to see the details about that specific incident. You can download the filtered data that is currently visible on the screen by selecting the download link on the top right of the map."
    ))
  })
  observeEvent(input$data_filter_btn, {
    showModal(modalDialog(
      title = "Data Table - Filtering Options",
      "The \"Select Data Set\" drop down menu on the page allows you to switch between the two data sets. One being a missing person data set, and the other being an attempted abduction data set. The filtering options are contains in the multi-tabbed box. Each tab contains a different set of filtering options. The attempted abduction data set contains more filtering options than the missing person data set."
    ))
  })
  # handle all the question buttons
  observeEvent(input$data_btn, {
    showModal(modalDialog(
      title = "Data Table - Data View",
      "This is the data table view. The filtering options on the left-hand side of the screen will alter the data that is viewable as soon as the filters are put into place. You can use the search bar to search for a specific row. The column names can be selected to sort the data based on the column selected. The filtered data can be downloaded by selecting the download link in the lower right-hand corner of the data table."
    ))
  })
  observeEvent(input$pie_filter_btn, {
    showModal(modalDialog(
      title = "Pie Charts - Filtering Options",
      "The filtering options here allow the user to filter by state, city, and zipcode."
    ))
  })
  # handle all the question buttons
  observeEvent(input$pie_btn, {
    showModal(modalDialog(
      title = "Pie Charts - Pie Chart View",
      "This is the pie chart view. The pie chart on the left represents the children, and the pie chart on the right represents the offenders. The pie chart options for the children allow the pie chart to display the percentages of child gender or child race. The pie chart options for the offenders allow the pie chart to display the offender gender, race, and kidnapping method. To see the total amount of people in each slice, hover over the slice. To download the pie charts, hover over the pie charts and click on the camera icon that appears in the top right corner. The error: \"subscript out of bounds\" means that the current filtering options return no data."
    ))
  })

}
