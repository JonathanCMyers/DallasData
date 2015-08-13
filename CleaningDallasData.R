## Author: Jonathan Myers                  ## Date Written: 8/12/2015
## Run these lines only if you are using fresh R or do not have the packages
install.packages("xlsx")
install.packages("ggplot2")
install.packages("devtools")
library(devtools)
devtools::install_github("rCharts", "ramnathv")

## Requirements before starting
library(xlsx)
library(rCharts)
if(!file.exists("DallasData")){dir.create("DallasData")}

## Downloading the data
fileUrl <- "http://raw.texastribune.org.s3.amazonaws.com/dallas/salaries/2015-04/cityofdallas0415.xls"
fileName <- "./DallasData/data.xlsx"
download.file(fileUrl,fileName,mode="wb")
colClasses<-c("character","character","character","character","character","numeric","numeric","numeric")
dallasData<-read.xlsx2(fileName,sheetIndex=1,colClasses=colClasses,stringsAsFactors=FALSE) # So we can change the ethnicity later on based on clusters
dallasData <- as.data.frame(dallasData)

## Remove names and other data we will not use that take up space (make it nice and clean)
# Reduces file size from 2MB to 0.4MB
keep <- c("Gender", "Ethnicity", "Adjusted.Hire.Date", "Rate.of.Pay", "Annual.Hours")
dallasData <- dallasData[, (names(dallasData) %in% keep)]
head(dallasData)

## Cluster by Ethnicity:
# This takes us from 19 different ethnicities to only 7, which is easier to visualize
names(dallasData)
dallasData[dallasData$Ethnicity == "WHT",]$Ethnicity <- "White"
dallasData[dallasData$Ethnicity == "BLK",]$Ethnicity <- "Black"
dallasData[dallasData$Ethnicity == "AMIN",]$Ethnicity <- "American Indian"
dallasData[dallasData$Ethnicity == "MEXA",]$Ethnicity <- "Hispanic"
dallasData[dallasData$Ethnicity == "SPAN",]$Ethnicity <- "Hispanic"
dallasData[dallasData$Ethnicity == "PUER",]$Ethnicity <- "Hispanic"
dallasData[dallasData$Ethnicity == "CUBA",]$Ethnicity <- "Hispanic"
dallasData[dallasData$Ethnicity == "VIET",]$Ethnicity <- "Asian"
dallasData[dallasData$Ethnicity == "CHIN",]$Ethnicity <- "Asian"
dallasData[dallasData$Ethnicity == "KORN",]$Ethnicity <- "Asian"
dallasData[dallasData$Ethnicity == "JAPN",]$Ethnicity <- "Asian"
dallasData[dallasData$Ethnicity == "FILI",]$Ethnicity <- "Pacific Islander"
dallasData[dallasData$Ethnicity == "PACF",]$Ethnicity <- "Pacific Islander"
dallasData[dallasData$Ethnicity == "GUAM",]$Ethnicity <- "Pacific Islander"
dallasData[dallasData$Ethnicity == "HAWA",]$Ethnicity <- "Pacific Islander"
dallasData[dallasData$Ethnicity == "ASIN",]$Ethnicity <- "Other Asian"
dallasData[dallasData$Ethnicity == "OASI",]$Ethnicity <- "Other Asian"
dallasData <- dallasData[dallasData$Ethnicity != "OTHR",] # Remove the two ethnicities that I do not know how to
dallasData <- dallasData[dallasData$Ethnicity != "TWO",] # cluster, and who have significantly low populations
dallasData$Ethnicity <- as.factor(dallasData$Ethnicity)

## Re-Adjust the Rate.of.Pay variable in the data
# Some individuals have the Rate.of.Pay listed by the hourly earnings, and some have it listed by yearly earnings.
# This will standardize to make sure the data is consistent across all rows.
dallasData[dallasData$Rate.of.Pay < 81,]$Rate.of.Pay <- 
   dallasData[dallasData$Rate.of.Pay < 81,]$Rate.of.Pay * dallasData[dallasData$Rate.of.Pay < 81,]$Annual.Hours

## Write the cleaned and processed data to an excel spreadsheet
write.xlsx2(dallasData, "DallasData/CleanedDallasData.xlsx")
