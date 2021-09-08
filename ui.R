library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

ui <- shinydashboardPlus::dashboardPage(
  title = "Wasanii", 
  
  options = list(sidebarExpandOnHover = TRUE), 
  
  header = shinydashboardPlus::dashboardHeader(
    title = ""
  ), 
  
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
  
  body = dashboardBody(
    tabItems(
      tabItem(
        tabName = "Home", 
        p("Welcome to Wasanii dashboard")
      ), 
      
      tabItem(
        tabName = "Stats", 
        p("All Stats & Plots go here.")
      ), 
      
      tabItem(
        tabName = "About", 
        p("Who's Wasanii? Contact? App author.")
      )
    )
  )
)
