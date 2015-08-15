library(shiny)
library(rCharts)
library(xlsx)
library(knitr)

options(
    RCHARD_LIB = "polycharts",
    rcharts.mode="iframesrc",
    rcharts.cdn=TRUE,
    RCHART_WIDTH=600,
    RCHART_HEIGHT=400
)

opts_chunk$set(tidy=F, results="asis", comment=NA)

colClasses <- c("numeric", "character", "character", "numeric", "numeric", "numeric")
dallasData <- read.xlsx2("CleanedDallasData.xlsx",sheetIndex=1, colClasses=colClasses)
dallasData <- as.data.frame(dallasData)
subData <- dallasData

shinyServer(
    function(input, output){
        output$chart1 <- renderChart2({
            ## Combine the ethnicities chosen by the user into one data frame, which is plotted
            subData <- dallasData[dallasData$Ethnicity %in% input$eth2,]
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
                }
                else {
                    r1 <- rPlot(mean(Rate_of_Pay) ~ Ethnicity, data=subData, color="Ethnicity", type="bar")
                }
                r1$addParams(height=600, width=800, dom="chart1", title="Mean Rate of Pay by Ethnicity")
            }
            return(r1)
        })

        output$meanInformation <- renderText({
            outputText <- ""
            sortedInputEth2 <- sort(input$eth2) #So the mean results show up in the order that the data is graphed
            if(length(input$eth2) == 0) { 
                # Do nothing
            }
            else {
                if(input$divideByGender == TRUE) { 
                    for(i in 1:(length(sortedInputEth2))) {
                        outputText <- paste(outputText, "Mean Rate of Pay for", sortedInputEth2[i], "\n\r",
                                            "  Males:   $", sep=" ")
                        tempFrame <- subData[subData$Ethnicity == sortedInputEth2[i],]
                        tempFrameM <- tempFrame[tempFrame$Gender == "M",5]
                        outputText <- paste(outputText, 
                                            format(round(mean(tempFrameM), 2), nsmall=2), 
                                            "\n\r", sep=" ")
                        
                        tempFrameF <- tempFrame[tempFrame$Gender == "F",5]
                        outputText <- paste(outputText, "  Females: $", 
                                            format(round(mean(tempFrameF), 2), nsmall=2), 
                                            "\n\r\n\r", sep=" ")
                    }
                }
                else {
                    for(i in 1:(length(sortedInputEth2))){
                        outputText <- paste(outputText, "Mean Rate of Pay for", sortedInputEth2[i], "\n\r", 
                                            "  Individuals: $", sep=" ")
                        tempFrame <- subData[subData$Ethnicity == sortedInputEth2[i],5]
                        outputText <- paste(outputText, 
                                            format(round(mean(tempFrame), 2), nsmall=2), "\n\r\n\r", sep=" ")
                    }
                }
            }
            meanInformation <- outputText
        })
    }    
)
