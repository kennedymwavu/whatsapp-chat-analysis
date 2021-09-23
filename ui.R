library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinycssloaders)

ui <- shinydashboardPlus::dashboardPage(
  title = "Wasanii", 
  
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
      
      menuItem(
        text = "Stats", 
        tabName = "Stats", 
        icon = icon(name = "chart-line", class = "fas fa-chart-line")
      ), 
      
      menuItem(
        text = "About", 
        tabName = "About", 
        icon = icon(name = "tags", class = "fa-solid fa-tags")
      )
    )
  ), 
  
  # ---- Body ----
  body = dashboardBody(
    tabItems(
      # ---- HOME ----
      tabItem(
        tabName = "Home", 
        p("Welcome to Wasanii dashboard")
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
            )
          ), 
          
          # ---- .comparisons ----
          tabPanel(
            title = h3("Comparisons"), 
            
            tags$br(), 
            
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
                      width = 7, 
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
                      ), 
                      
                      valueBoxOutput(
                        outputId = "textRatioPerPersonLeastVB", 
                        width = NULL
                      )
                    )
                  )
                )
              )
            )
          )
        )
      ), 
      
      # ---- ABOUT ----
      tabItem(
        tabName = "About", 
        p("Who's Wasanii? Contact? App author.")
      )
    )
  )
)
