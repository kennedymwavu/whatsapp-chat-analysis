server <- function(input, output, session) {
  # ---- Overview ----
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
  
  # ---- Comparison ----
  output$totalTextsPerPerson <- renderPlotly({
    totalTextsPerPerson
  })
  
  output$whoMaxTexts <- renderValueBox({
    valueBox(
      value = paste0(
        whoMaxTexts$author, 
        ", ", 
        whoMaxTexts$n
      ), 
      
      subtitle = "Sent most texts"
    )
  })
  
  output$whoMinTexts <- renderValueBox({
    valueBox(
      value = paste0(
        whoMinTexts$author, 
        ", ", 
        whoMinTexts$n
      ), 
      
      subtitle = "Sent least texts"
    )
  })
  
  output$otherTotalTextsVB <- renderValueBox({
    valueBox(
      value = otherTotalTexts$totalTexts, 
      subtitle = "Others"
    )
  })
  
  # Texts ratio per person:
  output$textRatioPerPerson <- renderPlotly({
    textRatioPerPerson
  })
  
  output$textRatioPerPersonMostVB <- renderValueBox({
    valueBox(
      value = paste0(
        whoMaxTexts$author, 
        ", ", 
        whoMaxTexts$Percentage, "%"
      ), 
      
      subtitle = "Leading sender market share"
    )
  })
  
  output$textRatioPerPersonLeastVB <- renderValueBox({
    valueBox(
      value = paste0(
        whoMinTexts$author, 
        ", ", 
        whoMinTexts$Percentage, 
        "%"
      ), 
      
      subtitle = "Least sender market share"
    )
  })
  
  
  output$textRatioPerPersonOtherVB <- renderValueBox({
    valueBox(
      value = otherTotalTexts$Percent, 
      subtitle = "Others market share"
    )
  })
  
  output$ayooFavEmojis <- renderPlotly({
    emojiCountPlotList$Ayoo
  })
  
  output$joyFavEmojis <- renderPlotly({
    emojiCountPlotList$Joy
  })
  
  output$mwavuFavEmojis <- renderPlotly({
    emojiCountPlotList$Mwavu
  })
  
  output$nelvineFavEmojis <- renderPlotly({
    emojiCountPlotList$Nelvine
  })
  
  output$rachaelFavEmojis <- renderPlotly({
    emojiCountPlotList$Rachael
  })
  
  output$ayooFavWords <- renderPlotly({
    wordCountPlotList$Ayoo
  })
  
  output$joyFavWords <- renderPlotly({
    wordCountPlotList$Joy
  })
  
  output$mwavuFavWords <- renderPlotly({
    wordCountPlotList$Mwavu
  })
  
  output$nelvineFavWords <- renderPlotly({
    wordCountPlotList$Nelvine
  })
  
  output$rachaelFavWords <- renderPlotly({
    wordCountPlotList$Rachael
  })
}