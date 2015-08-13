library(shiny)
library(rCharts)
if(file.exists("DallasData")) {setwd("DallasData")}
source("CleaningDallasData.R")
colClasses <- c("numeric", "character", "character", "numeric", "numeric", "numeric")
dallasData <- read.xlsx2("CleanedDallasData.xlsx",sheetIndex=1, colClasses=colClasses)
dallasData <- as.data.frame(dallasData)
dallasData$Gender <- as.factor(dallasData$Gender)
dallasData$Ethnicity <- as.factor(dallasData$Ethnicity)
#r1 <- rPlot(Rate_of_Pay ~ Ethnicity | Gender, data=dallasData, color="Gender", type="point")
#r1
#hist(dallasData$Rate.of.Pay)
#r2 <- rPlot(Rate.of.Pay ~ Ethnicity | Gender, color="Ethnicity", data=dallasData, type="point")
#r2
#data(HairEyeColor)
#head(dallasData)
#hair_eye <- as.data.frame(HairEyeColor)
#r3 <- rPlot(Freq ~ Hair | Eye, color="Eye", data=hair_eye, type="point")
#r3
runApp()
