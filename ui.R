ui <- shinydashboardPlus::dashboardPage(
  title = "Wasanii", 
  scrollToTop = TRUE, 
  options = list(sidebarExpandOnHover = TRUE), 
  
  # ---- Header ----
  header = shinydashboardPlus::dashboardHeader(
    title = span(
      tagList(
        icon(
          name = "won-sign", 
          class = "fa-solid fa-won-sign"
        ), 
        "Wasanii"
      ), 
      style = "font-weight: bold; font-family: Tahoma; font-size: 25px"
    )
  ), 
  
  # ---- Sidebar ----
  sidebar = shinydashboardPlus::dashboardSidebar(
    minified = TRUE, collapsed = TRUE, 
    
    sidebarMenu(
      id = "tabs", 
      
      menuItem(
        text = "Home", 
        tabName = "Home", 
        icon = icon(name = "bank", class = "fa-solid fa-bank")
      ), 
      
      tags$br(), 
      
      menuItem(
        text = "Stats", 
        tabName = "Stats", 
        icon = icon(name = "chart-line", class = "fas fa-chart-line")
      ), 
      
      tags$br(), 
      
      menuItem(
        text = "About", 
        tabName = "About", 
        icon = icon(name = "tags", class = "fa-solid fa-tags")
      )
    )
  ), 
  
  # ---- Body ----
  body = dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ), 
    
    includeHTML(
      path = "www/font.html"
    ), 
    
    shinyDashboardThemes(theme = "poor_mans_flatly"), 
    
    tabItems(
      # ---- HOME ----
      tabItem(
        tabName = "Home", 
        
        fluidRow(
          column(
            width = 12, 
            align = "center", 
            
            h2("Members")
          )
        ), 
        
        fluidRow(
          userBox(
            title = userDescription(
              title = span("Ayoo", style = "color:white;"),
              subtitle = span("Source", style = "color:white;"),
              image = "images/ayoo.jpg"
            ),
            status = "orange",
            closable = FALSE,
            maximizable = TRUE,
            "Class Rep"
          ), 
          
          userBox(
            title = userDescription(
              title = span("Joy", style = "color:white;"),
              subtitle = span("Detailed", style = "color:white;"),
              image = "images/joy.jpg"
            ),
            status = "navy",
            closable = FALSE,
            maximizable = TRUE,
            "Group Founder"
          )
        ), 
        
        tags$br(), 
        
        fluidRow(
          userBox(
            title = userDescription(
              title = span("Mwavu", style = "color:white;"),
              subtitle = span("Smiler", style = "color:white"),
              image = "images/mwavu.jpeg"
            ),
            status = "success",
            closable = FALSE,
            maximizable = TRUE
          ), 
          
          userBox(
            title = userDescription(
              title = span("Nelvine", style = "color:white;"),
              subtitle = span("Executive", style = "color:white"),
              image = "images/nelvine.jpg"
            ),
            status = "maroon",
            closable = FALSE,
            maximizable = TRUE
          )
        ), 
        
        fluidRow(
          userBox(
            title = userDescription(
              title = span("Rachael", style = "color:white;"),
              subtitle = span("Comedian", style = "color:white;"),
              image = "images/rachael.jpg"
            ),
            status = "primary",
            closable = FALSE,
            maximizable = TRUE, 
            "DIY"
          )
        )
      ), 
      
      # ---- STATS ----
      tabItem(
        tabName = "Stats", 
        
        tabsetPanel(
          # ---- .overview ----
          tabPanel(
            title = h3("Overview"), 
            
            tags$br(), 
            
            # Texts Per Day:
            fluidRow(
              column(
                width = 12, 
                align = "center", 
                
                box(
                  title = "Texts Per Day", 
                  status = "primary", 
                  width = 9, 
                  solidHeader = TRUE, 
                  
                  plotlyOutput(
                    outputId = "textsPerDayBars", 
                    width = "100%", height = "100%"
                  ) |> withSpinner(type = 7)
                ), 
                
                column(
                  width = 3, 
                  
                  valueBoxOutput(
                    outputId = "textsPerDayBarsVB", 
                    width = NULL
                  ) |> withSpinner(type = 7)
                )
              )
            ), 
            
            tags$br(), 
            
            tags$hr(style = "border: 0.05rem solid #203843;"), 
            
            tags$br(), 
            # Texts per month line chart:
            fluidRow(
              column(
                width = 12, 
                align = "center", 
                
                box(
                  width = NULL, 
                  title = "Monthly Texts Per Person", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  
                  plotlyOutput(
                    outputId = "textsPerMonthLineChart", 
                    width = "100%", height = "100%"
                  ) |> withSpinner(type = 7)
                )
                # *** For now this part has no VB ***
              )
            ), 
            
            tags$br(), 
            tags$br(), 
            tags$br(), 
            tags$br()
          ), 
          
          # ---- .comparisons ----
          tabPanel(
            title = h3("Comparisons"), 
            
            tags$br(), 
            
            fluidRow(
              column(
                width = 12, 
                align = "center", 
                
                h3("Number of texts")
              )
            ), 
            
            tabBox(
              width = 12, 
              
              tabPanel(
                title = "Texts per person", 
                
                # Who's sent what number of texts?
                fluidRow(
                  column(
                    width = 12, 
                    align = "center", 
                    
                    box(
                      width = 8, 
                      title = "Total texts per person", 
                      solidHeader = TRUE, 
                      status = "primary", 
                      
                      plotlyOutput(
                        outputId = "totalTextsPerPerson", 
                        width = "100%", height = "100%"
                      ) |> withSpinner(type = 7)
                    ), 
                    
                    column(
                      width = 4, 
                      
                      valueBoxOutput(
                        outputId = "whoMaxTexts", 
                        width = NULL
                      ) |> withSpinner(type = 7), 
                      
                      valueBoxOutput(
                        outputId = "whoMinTexts", 
                        width = NULL
                      ) |> withSpinner(type = 7), 
                      
                      valueBoxOutput(
                        outputId = "otherTotalTextsVB", 
                        width = NULL
                      ) |> withSpinner(type = 7)
                    )
                  )
                )
              ), 
              
              tabPanel(
                title = "Ratios", 
                
                # What ratio of the total texts has everyone sent?
                fluidRow(
                  column(
                    width = 12, 
                    align = "center", 
                    
                    box(
                      width = 8, 
                      title = "Ratio of total texts per person", 
                      solidHeader = TRUE, 
                      status = "primary", 
                      
                      plotlyOutput(
                        outputId = "textRatioPerPerson", 
                        width = "100%", height = "100%"
                      ) |> withSpinner(type = 7)
                    ), 
                    
                    column(
                      width = 4, 
                      
                      valueBoxOutput(
                        outputId = "textRatioPerPersonMostVB", 
                        width = NULL
                      ) |> withSpinner(type = 7), 
                      
                      valueBoxOutput(
                        outputId = "textRatioPerPersonLeastVB", 
                        width = NULL
                      ) |> withSpinner(type = 7), 
                      
                      valueBoxOutput(
                        outputId = "textRatioPerPersonOtherVB", 
                        width = NULL
                      ) |> withSpinner(type = 7)
                    )
                  )
                )
              )
            ), 
            
            tags$hr(style = "border: 0.05rem solid #203843;"), 
            
            fluidRow(
              column(
                width = 12, 
                align = "center", 
                
                h3("Favorite emojis")
              )
            ), 
            
            sidebarLayout(
              sidebarPanel = sidebarPanel(
                numericInput(
                  inputId = "topnEmojis", 
                  label = "Top n Emojis", 
                  value = 5, 
                  min = 3, 
                  max = 10
                )
              ), 
              
              mainPanel = mainPanel(
                tabBox(
                  width = 12, 
                  
                  tabPanel(
                    title = "Ayoo", 
                    
                    plotlyOutput(
                      outputId = "ayooFavEmojis", 
                      width = "100%", height = "100%"
                    ) |> withSpinner(type = 7)
                  ), 
                  
                  tabPanel(
                    title = "Joy", 
                    
                    plotlyOutput(
                      outputId = "joyFavEmojis", 
                      width = "100%", height = "100%"
                    ) |> withSpinner(type = 7)
                  ), 
                  
                  tabPanel(
                    title = "Mwavu", 
                    
                    plotlyOutput(
                      outputId = "mwavuFavEmojis", 
                      width = "100%", height = "100%"
                    ) |> withSpinner(type = 7)
                  ), 
                  
                  tabPanel(
                    title = "Nelvine", 
                    
                    plotlyOutput(
                      outputId = "nelvineFavEmojis", 
                      width = "100%", height = "100%"
                    ) |> withSpinner(type = 7)
                  ), 
                  
                  tabPanel(
                    title = "Rachael", 
                    
                    plotlyOutput(
                      outputId = "rachaelFavEmojis", 
                      width = "100%", height = "100%"
                    ) |> withSpinner(type = 7)
                  )
                )
              )
            ), 
            
            tags$hr(style = "border: 0.05rem solid #203843;"), 
            
            fluidRow(
              column(
                width = 12, 
                align = "center", 
                
                h3("Most used words")
              )
            ), 
            
            sidebarLayout(
              sidebarPanel = sidebarPanel(
                numericInput(
                  inputId = "topnWords", 
                  label = "Top n Words", 
                  value = 10, 
                  max = 20, 
                  min = 3
                )
              ), 
              
              mainPanel = mainPanel(
                tabBox(
                  width = 12, 
                  
                  tabPanel(
                    title = "Ayoo", 
                    
                    plotlyOutput(
                      outputId = "ayooFavWords"
                    ) |> withSpinner(type = 7)
                  ), 
                  
                  tabPanel(
                    title = "Joy", 
                    
                    plotlyOutput(
                      outputId = "joyFavWords"
                    ) |> withSpinner(type = 7)
                  ), 
                  
                  tabPanel(
                    title = "Mwavu", 
                    
                    plotlyOutput(
                      outputId = "mwavuFavWords"
                    ) |> withSpinner(type = 7)
                  ), 
                  
                  tabPanel(
                    title = "Nelvine", 
                    
                    plotlyOutput(
                      outputId = "nelvineFavWords"
                    ) |> withSpinner(type = 7)
                  ), 
                  
                  tabPanel(
                    title = "Rachael", 
                    
                    plotlyOutput(
                      outputId = "rachaelFavWords"
                    ) |> withSpinner(type = 7)
                  )
                )
              )
            ), 
            
            tags$br(), 
            tags$br(), 
            tags$br()
          )
        )
      ), 
      
      # ---- ABOUT ----
      tabItem(
        tabName = "About", 
        
        htmltools::tags$iframe(
          src = "about.html", 
          width = '100%',  height = 500,  style = "border:none;"
        ), 
        
        htmltools::tags$iframe(
          src = "footer.html", 
          width = "100%", 
          height = 500, 
          style = "border:none;"
        )
      )
    )
  )
) 

