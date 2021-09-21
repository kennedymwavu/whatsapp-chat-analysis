server <- function(input, output, session) {
  output$textsPerDayBars <- renderPlotly({
    textsPerDayBars
  })
}