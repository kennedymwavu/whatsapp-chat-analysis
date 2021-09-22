server <- function(input, output, session) {
  # Texts per day plotly:
  output$textsPerDayBars <- renderPlotly({
    textsPerDayBars
  })
  
  output$textsPerDayBarsVB <- renderValueBox({
    valueBox(
      value = paste0(
        dayWithMostTexts$n
      ), 
      subtitle = "Highest number of texts sent in a day so far"
    )
  })
  
  output$textsPerMonthLineChart <- renderPlotly({
    textsPerMonthLineChart
  })
}