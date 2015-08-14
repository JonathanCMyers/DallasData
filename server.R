library(shiny)
library(rCharts)
library(ggplot2)
library(xlsx)
library(quantmod)

options(
  RCHARD_LIB = "dimple",
  rcharts.mode="iframesrc",
  rcharts.cdn=TRUE,
  RCHART_WIDTH=600,
  RCHART_HEIGHT=400
)

library(knitr)
opts_chunk$set(tidy=F, results="asis", comment=NA)

#options(RCHART_WIDTH=800)

colClasses <- c("numeric", "character", "character", "numeric", "numeric", "numeric")
dallasData <- read.xlsx2("CleanedDallasData.xlsx",sheetIndex=1, colClasses=colClasses)
dallasData <- as.data.frame(dallasData)
dallasData$Gender <- as.factor(dallasData$Gender)
dallasData$Ethnicity <- as.factor(dallasData$Ethnicity)


shinyServer(
  function(input, output){
    
    #getSelectedWords <- reactive({
    #  if(length(input$word) < 1) { return(NULL) }
    #  else { return(as.character(input$word)) }
    #})
    
    #output$selectedWords <- renderText({
    #  text <- getSelectedWords()
    #  if(length(text) == 0) { return("Nothing selected") }
    #  else { return(text) }
    #})
    
    #output$triggerRChart <- renderUI({
    #  if(length(input$word) > 0) { 
    #   
    #  }
    #})
    
    #output$ethOptions <- renderUI({
    #  selectInput(inputId="Ethnicity",
    #              label="Select a list of ethnicities:",
    #              choices=c("American Indian", "Asian", "Black", "Hispanic",
    #                        "Other Asian", "Pacific Islander", "White"),
    #              multiple=TRUE
    #  )
    #})
    
    
    output$chart1 <- renderChart2({
      
      d1 <- dPlot(y="Rate_of_Pay", x="Ethnicity", data=dallasData, groups="variable", type="bar")
      d1$yAxis(type="addCategoryAxis", orderRule="Pay")
      d1$xAxis(type="addPctAxis")
      return(d1)
      
      #p1 <- nPlot(Rate_of_Pay ~ Ethnicity, data=dallasData, group="Gender", type="scatterChart")
      #p1$xAxis(axisLabel = "Ethnicity")
      #p1
      
      #p4 <- nPlot( ~ cyl, data=mtcars, type="pieChart")
      #return(p4)
      
      #subData <- dallasData[dallasData$Ethnicity=="White",]
      
      #r1 <- rPlot(Rate_of_Pay ~ Ethnicity, data=subData, color="Gender", type="point")
      #r1 <- rPlot(x = "Ethnicity", y = "Rate_of_Pay", data=subData, type="box")
      #r1$addParams(height=600, width=800, dom="chart1", title="Rate of Pay by Ethnicity")
      #r1$set(fontSize="50px")
      #return(r1)
      #dmap <- dplot(x=c(""))
    })
    
    
    #output$oid1 <- renderPrint({input$id1})
    #output$oid2 <- renderPrint({input$id2})
    #output$odate <- renderPrint({input$date})
  }    
)
