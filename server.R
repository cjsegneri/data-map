
function(input, output, session) {

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
    # check offender method
    if (!is.null(input$k_method_inp)) { filtered = filtered[filtered$Offender.Method.Ride %in% input$k_method_inp,] }

    return (filtered)
  })

  output$map = renderLeaflet({

    # read in the missing and kidnapping data
    missing.filtered = getMissing()
    kidnapping.filtered = getKidnapping()

    # read in which datasets to show
    sets = whichSets()

    # create the map
    if (sets == 1) {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>%
        addCircleMarkers(
          data = missing.filtered, lng = ~longitude, lat = ~latitude, color = "#ff6666",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(255,102,102,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          )
                                                  ) %>%
        addCircleMarkers(
          data = kidnapping.filtered, lng = ~longitude, lat = ~latitude, color = "#66b2ff",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(102,178,255,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          )
                                                  ) %>%
        addLegend(
          "bottomleft", title = "Datasets", labels = c("Missing Persons", "Attempted Kidnapping"),
          colors = c("#ff6666","#66b2ff"), opacity = 0.5
        )
    } else if (sets == 2) {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>%
        addCircleMarkers(
          data = missing.filtered, lng = ~longitude, lat = ~latitude, color = "#ff6666",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(255,102,102,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          )
                                                  ) %>%
        addLegend(
          "bottomleft", title = "Datasets", labels = c("Missing Persons", "Attempted Kidnapping"),
          colors = c("#ff6666","#66b2ff"), opacity = 0.5
        )
    } else if (sets == 3) {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>%
        addCircleMarkers(
          data = kidnapping.filtered, lng = ~longitude, lat = ~latitude, color = "#66b2ff",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(102,178,255,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          )
                                                  ) %>%
        addLegend(
          "bottomleft", title = "Datasets", labels = c("Missing Persons", "Attempted Kidnapping"),
          colors = c("#ff6666","#66b2ff"), opacity = 0.5
        )
    } else {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron)
    }
  })


  output$download_btn = downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      missing.filtered = getMissing()
      write.csv(missing.filtered, file)
    }
  )

}
