
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

  # configure the map filter UI
  output$map_filters = renderUI({
    if (input$map_select == "mc") { missingFilters } else { abductionFilters }
  })

  # configure the missing data table
  output$missing_table = renderDataTable({
    filter_missing_set(missing, getMissingFilters())
  })

  # configure the abduction data table
  output$abduction_table = renderDataTable({
    dt = filter_abduction_set(abductions, getAbductionFilters())
    datatable(dt, options = list(pageLength = 5))
  })

  # configure the main leaflet map
  output$map = renderLeaflet({
    # check which map to show
    if (input$map_select == "mc") {
      mis = filter_missing_set(missing, getMissingFilters())
      pops = paste(sep = "<br/>",
                   paste("Case Number:<b>", mis$case_number, "</b>"),
                   paste("Case Type:<b>", mis$case_type, "</b>"),
                   "",
                   paste("Date Missing:<b>", mis$missing_date, "</b>"),
                   paste("Age Missing:<b>", mis$age_missing, "</b>"),
                   paste("Child Gender:<b>", mis$gender, "</b>"),
                   paste("Child Race:<b>", mis$gender, "</b>"),
                   "",
                   paste("Vehicle Color:<b>", mis$vehicle_color, "</b>"),
                   paste("Vehicle Style:<b>", mis$vehicle_style, "</b>"))
      leaflet() %>%
        addTiles() %>%
        addCircleMarkers(data = mis, clusterOptions = markerClusterOptions(), popup = pops) %>%
        addControl(h4("Missing Children Map"), position = "topright")
    } else {
      abd = filter_abduction_set(abductions, getAbductionFilters())
      pops = paste(sep = "<br/>",
                   paste("Case Number:<b>", abd$case_number, "</b>"),
                   paste("Incident Type:<b>", abd$case_number, "</b>"),
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
        addCircleMarkers(data = abd, clusterOptions = markerClusterOptions(), popup = pops) %>%
        addControl(h4("Attempted Abductions Map"), position = "topright")
    }
  })

  # configure the child pie chart
  output$pie_child = renderPlotly({
    loc = list(input$pie_state, input$pie_city, input$pie_zip)
    print(loc)
    create_child_pie(missing, abductions, input$pie_child_select, loc)
  })

  # configure the offender pie chart
  output$pie_offender = renderPlotly({
    loc = list(input$pie_state, input$pie_city, input$pie_zip)
    create_offender_pie(missing, abductions, input$pie_offender_select, loc)
  })

}
