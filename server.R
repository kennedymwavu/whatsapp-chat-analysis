server <- function(input, output, session) {
  # ----authentication----
  # call the server part
  # check_credentials returns a function to authenticate users
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials)
  )
  
  output$auth_output <- renderPrint({
    reactiveValuesToList(res_auth)
  })
  
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
      subtitle = "Highest number of texts sent in a day so far", 
      color = "light-blue"
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
      
      subtitle = "Sent most texts", 
      color = "green"
    )
  })
  
  output$whoMinTexts <- renderValueBox({
    valueBox(
      value = paste0(
        whoMinTexts$author, 
        ", ", 
        whoMinTexts$n
      ), 
      
      subtitle = "Sent least texts", 
      color = "blue"
    )
  })
  
  output$otherTotalTextsVB <- renderValueBox({
    valueBox(
      value = otherTotalTexts$totalTexts, 
      subtitle = "Others", 
      color = "orange"
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
      
      subtitle = "Leading sender market share", 
      
      color = "green"
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
      
      subtitle = "Least sender market share", 
      color = "blue"
    )
  })
  
  
  output$textRatioPerPersonOtherVB <- renderValueBox({
    valueBox(
      value = otherTotalTexts$Percent, 
      subtitle = "Others market share", 
      color = "orange"
    )
  })
  
  # ----.fav emojis----
  emojiCountPlotList <- reactive({
    emoji_f(topn = input$topnEmojis, emojis = emojis)
  }) |> 
    bindCache(input$topnEmojis)
  
  output$ayooFavEmojis <- renderPlotly({
    emojiCountPlotList()$Ayoo
  })
  
  output$joyFavEmojis <- renderPlotly({
    emojiCountPlotList()$Joy
  })
  
  output$mwavuFavEmojis <- renderPlotly({
    emojiCountPlotList()$Mwavu
  })
  
  output$nelvineFavEmojis <- renderPlotly({
    emojiCountPlotList()$Nelvine
  })
  
  output$rachaelFavEmojis <- renderPlotly({
    emojiCountPlotList()$Rachael
  })
  
  # ----.fav words----
  wordCountPlotList <- reactive({
    top_words(topn = input$topnWords, words = words)
  }) |> 
    bindCache(input$topnWords)
  
  output$ayooFavWords <- renderPlotly({
    wordCountPlotList()$Ayoo
  })
  
  output$joyFavWords <- renderPlotly({
    wordCountPlotList()$Joy
  })
  
  output$mwavuFavWords <- renderPlotly({
    wordCountPlotList()$Mwavu
  })
  
  output$nelvineFavWords <- renderPlotly({
    wordCountPlotList()$Nelvine
  })
  
  output$rachaelFavWords <- renderPlotly({
    wordCountPlotList()$Rachael
  })
}

