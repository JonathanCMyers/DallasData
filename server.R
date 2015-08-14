library(shiny)
library(rCharts)
library(ggplot2)
library(xlsx)
library(quantmod)

options(
    RCHARD_LIB = "polycharts",
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

# Set up data frames segmented by ethnicity
dallasAmericanIndian <- dallasData[dallasData$Ethnicity == "American Indian",]
dallasAsian <- dallasData[dallasData$Ethnicity == "Asian",]
dallasBlack <- dallasData[dallasData$Ethnicity == "Black",]
dallasHispanic <- dallasData[dallasData$Ethnicity == "Hispanic",]
dallasOtherAsian <- dallasData[dallasData$Ethnicity == "Other Asian",]
dallasPacificIslander <- dallasData[dallasData$Ethnicity == "Pacific Islander",]
dallasWhite <- dallasData[dallasData$Ethnicity == "White",]

ethnicityList <- list("American Indian" = dallasAmericanIndian, "Asian" = dallasAsian, 
                      "Black" = dallasBlack, "Hispanic" = dallasHispanic, "Other Asian" = dallasOtherAsian,
                      "Pacific Islander" = dallasPacificIslander, "White" = dallasWhite)
subData <- dallasData
outputText <- ""

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
        #output$testVector <- renderText({
        #    if(length(input$eth2) > 0) { return(input$eth2) }
        #    else { return("-1") }
        #})
        #output$lengthOfSubData <- renderText({
        #    return(nrow(subData))
        #})
        output$chart1 <- renderChart2({
            ## Combine the ethnicities chosen by the user into one data frame, which is plotted
            if(length(input$eth2) == 0) {
                subData <- data.frame("X."=numeric(0), "Gender"=character(0), "Ethnicity"=character(0), 
                                      "Adjusted_Hire_Date"=numeric(0), "Rate_of_Pay"=numeric(0), "Annual_Hours"=numeric(0))
            }
            else if(length(input$eth2) == 1) {
                subData <- ethnicityList[[input$eth2]]
            }
            else if(length(input$eth2) == 2) {
                subData <- rbind(ethnicityList[[input$eth2[1]]], ethnicityList[[input$eth2[2]]])
            }
            else if(length(input$eth2) > 2) {
                count <- 1
                subData <- data.frame("X."=numeric(0), "Gender"=character(0), "Ethnicity"=character(0), 
                                      "Adjusted_Hire_Date"=numeric(0), "Rate_of_Pay"=numeric(0), "Annual_Hours"=numeric(0))
                subData$Gender <- as.factor(subData$Gender)
                subData$Ethnicity <- as.factor(subData$Ethnicity)
                repeat{
                    subData <- rbind(subData, ethnicityList[[input$eth2[count]]])
                    if(count == length(input$eth2)) { break }
                    count <- count+1
                }
            }
            # The entire decision tree above does not have any difference from:
                    #subData <- dallasData[dallasData$Ethnicity %in% input$eth2,]
            # in regards to how many points are plotted by rCharts
            
            
            if(input$graphMeans == FALSE) {
                ## Shows different graphs depending on if we are dividing the output by gender or not
                if(input$divideByGender == TRUE) {
                    r1 <- rPlot(Rate_of_Pay ~ Ethnicity, data=subData, color="Gender", type="point")
                }
                else {
                    r1 <- rPlot(Rate_of_Pay ~ Ethnicity, data=subData, color="Ethnicity", type="point")
                }
                r1$addParams(height=600, width=800, dom="chart1", title="Rate of Pay by Ethnicity")
                r1$set(fontSize="50px")
            }
            else if(input$graphMeans == TRUE) {
                if(input$divideByGender == TRUE) {
                    r1 <- rPlot(mean(Rate_of_Pay) ~ Ethnicity | Gender, data=subData, color="Gender", type="bar")
                    #payMeans <- numeric(length(input$eth2)*2)
                    outputText <- ""
                    for(i in 1:(length(input$eth2))){
                        outputText <- cat(outputText, "Mean Rate of Pay for", input$eth2[i], "males: $")
                        
                        tempFrame <- subData[subData$Ethnicity == input$eth2[i],]
                        tempFrameM <- tempFrame[tempFrame$Gender == "Male",5]
                        cat(outputText, mean(tempFrameM))
                        
                        tempFrameF <- tempFrame[tempFrame$Gender == "Female",5]
                        outputText <<- cat(outputText, "     females: $", mean(tempFrameF), "\n")
                    }
                    #output$meanInformation <- outputText
                }
                else {
                    r1 <- rPlot(mean(Rate_of_Pay) ~ Ethnicity, data=subData, color="Ethnicity", type="bar")
                    outputText <- ""
                    for(i in 1:(length(input$eth2))){
                        outputText <- cat(outputText, "Mean Rate of Pay for", input$eth2[i], "s: $")
                        
                        tempFrame <- subData[subData$Ethnicity == input$eth2[i],]
                        outputText <<- cat(outputText, colMeans(tempFrame)[["Rate_of_Pay"]], "\n")
                    }
                    #output$meanInformation <- outputText
                }
                r1$addParams(height=600, width=800, dom="chart1", title="Mean Rate of Pay by Ethnicity")
            }
            return(r1)
        })
        
        output$meanInformation <- renderText({
            return(outputText)
        })
        
        #output$meanInformation <- renderText
        
        
        #output$oid1 <- renderPrint({input$id1})
        #output$oid2 <- renderPrint({input$id2})
        #output$odate <- renderPrint({input$date})
    }    
)
