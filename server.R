
server = function(input, output, session) {

  output$missing_table = renderDataTable({
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
    filter_missing_set(missing, filters)
  })

}
