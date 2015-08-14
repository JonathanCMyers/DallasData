library(shiny)
library(rCharts)
if(file.exists("DallasData")) {setwd("DallasData")}
if(!file.exists("CleanedDallasData.xlsx")){source("CleaningDallasData.R")}
head(dallasData)
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
#

subData <- dallasData[dallasData$Ethnicity=="White",]

data(tips, package="reshape2")
p3 <- rPlot(x = "day", y = "box(tip)", data=tips, type="box")
p3$show('iframesrc', cdn=TRUE)



r1 <- rPlot(x = "Ethnicity", y = "Rate_of_Pay", data=subData, type="box")
plot(r1)
r1$show('iframesrc', cdn=TRUE)
return(r1)


plot(p4)

colClasses <- c("numeric", "character", "character", "numeric", "numeric", "numeric")
dallasData <- read.xlsx2("CleanedDallasData.xlsx",sheetIndex=1, colClasses=colClasses)
dallasData <- as.data.frame(dallasData)
dallasData$Gender <- as.factor(dallasData$Gender)
dallasData$Ethnicity <- as.factor(dallasData$Ethnicity)
r1 <- rPlot(Rate_of_Pay ~ Ethnicity, data=dallasData, color="Gender", type="box")
r1
