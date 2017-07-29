
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
    theme = shinythemes::shinytheme("superhero"),
  # Application title
  titlePanel("Australian House Price Indexes"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        h2("Metrics:"),
        uiOutput("dateSelector"),
        uiOutput("region"),
        uiOutput("propertyType"),
        uiOutput("measure"),
        hr(""),
        h2("Instructions:"),
        p("1. Select the dates of interest using the slider."),
        p("2. Select the regions you wish to compare against each other. You can select multiple items"),
        p("3. Select a property type for the index."),
        p("4. Select a measure of the index you"),
        hr("")
    ),
    # Show a plot of the generated distribution
    mainPanel(
        h2("Introduction:"),
        p("The data below is obtained from the Australian Bureau of Statistics. It shows the quarterly increase in house prices over a number of years with"),
        p("the index basline as 2010."),
        h2("Graph:"),
        plotOutput("distPlot"),
        h2("Data Table:"),
        tableOutput("dispText")
    )
  )
))
