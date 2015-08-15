library(shiny)
library(rCharts)
library(quantmod)

shinyUI(pageWithSidebar(
    headerPanel("Dallas Employment Data"),
    sidebarPanel(
        selectInput(inputId="eth2",
                    label="Select a list of ethnicities:",
                    choices=c("American Indian", "Asian", "Black", "Hispanic",
                              "Other Asian", "Pacific Islander", "White"),
                    multiple=TRUE),
        checkboxInput("divideByGender", "Divide by Gender", TRUE),
        checkboxInput("graphMeans", "Graph means instead of points", FALSE),
        
        h3("\n\n"),
        verbatimTextOutput("meanInformation")
    ),
    mainPanel(
        textOutput("\n"),
        showOutput("chart1", "polycharts") 
    )
))
