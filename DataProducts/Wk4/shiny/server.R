
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(lubridate)
library(ggplot2)
dateconversion <- function(dataset) {
    dataset$Time <- sapply(dataset$Time, as.character)
    k <- setNames(do.call(rbind.data.frame, strsplit(dataset$Time, "-")), c("month", "year"))
    k <- sapply(k, as.character)
    dateconversion <- cbind(dataset, k)
    dateconversion$year <- sapply(dateconversion$year, as.character)
    dateconversion$month <- sapply(dateconversion$month, as.character)
    dateconversion$month <- match(dateconversion$month, month.abb)
    dateconversion[which(nchar(dateconversion$month) < 2), "month"] <- paste0("0", dateconversion[which(nchar(dateconversion$month) < 2), "month"])
    dateconversion$date <- dmy(paste("01", dateconversion$month, dateconversion$year, sep="-"))
    dateconversion <- na.omit(dateconversion)
    return(dateconversion)
}

if(!dir.exists("./cache")) {
    house_prices <- read.csv("./data/RES_PROP_INDEX_28072017192550296.csv", header = TRUE)
    house_prices <- dateconversion(house_prices)
    dir.create("./cache")
    saveRDS(house_prices, "./cache/house.RDS")
} else {
    house_prices <- readRDS("./cache/house.RDS")
}
maxdate = max(house_prices$date)
mindate = min(house_prices$date)


shinyServer(function(input, output) {

    output$dateSelector <- renderUI({
        sliderInput("dateSelector",
                    "Date Range:",
                    min = mindate,
                    max = maxdate,
                    value = c(mindate, maxdate)
        )
    })

    output$region <- renderUI({
        checkboxGroupInput("region",
                    "Select Region:",
                    choices = levels(house_prices$Region),
                    selected = "Weighted average of eight capital cities"
        )
    })
    
    output$propertyType <- renderUI({
        radioButtons("propertyType",
                           "Select Property Type:",
                           choices = levels(house_prices$Property.type)
        )
    })
    
    output$measure <- renderUI({
        radioButtons("measure",
                     "Index Measure:",
                     choices = levels(house_prices$Measure)
        )
    })
    
    output$dispText <- renderTable({
        subsetdata <- house_prices[which(house_prices$date >= input$dateSelector[1] & 
                                             house_prices$date <= input$dateSelector[2] & 
                                             house_prices$Property.type == input$propertyType & 
                                             house_prices$Region %in% input$region &
                                            house_prices$Measure == input$measure), 
                                   c("date","Value","Region","Property.type","Measure")]
        subsetdata$date <- sapply(subsetdata$date, as.character)
        subsetdata
    })
    
    output$distPlot <- renderPlot({
        subsetdata <- house_prices[which(house_prices$date >= input$dateSelector[1] & 
                                             house_prices$date <= input$dateSelector[2] & 
                                             house_prices$Property.type == input$propertyType & 
                                             house_prices$Region %in% input$region &
                                             house_prices$Measure == input$measure), 
                                   c("date","Value","Region","Property.type","Measure")]
        ggplot(subsetdata, aes(x = date, y = Value, colour = Region)) +
        geom_path()
  })

})
