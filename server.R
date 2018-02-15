
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
          data = kidnapping, lng = ~longitude, lat = ~latitude, color = "#66b2ff",
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
          data = kidnapping, lng = ~longitude, lat = ~latitude, color = "#66b2ff",
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
