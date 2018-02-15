
function(input, output, session) {

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
          data = missing.filtered, lng = ~longitude, lat = ~latitude, color = "#ff6666",
          clusterOptions = markerClusterOptions(iconCreateFunction =
                                                  JS("
                                                     function(cluster) {
                                                     return new L.DivIcon({
                                                     html: '<div style=\"background-color:rgba(255,102,102,0.8)\"><span>' + cluster.getChildCount() + '</div><span>',
                                                     className: 'marker-cluster'
                                                     });
                                                     }")
          ),
          popup = missing.popup
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
          ),
          popup = kidnapping.popup
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
          ),
          popup = missing.popup
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
          ),
          popup = kidnapping.popup
                                                  ) %>%
        addLegend(
          "bottomleft", title = "Datasets", labels = c("Missing Persons", "Attempted Kidnapping"),
          colors = c("#ff6666","#66b2ff"), opacity = 0.5
        )
    } else {
      leaflet() %>% addProviderTiles(providers$CartoDB.Positron)
    }
  })

}
