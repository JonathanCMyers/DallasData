library(shiny)
library(rCharts)
options(RCHART_LIB="polycharts")
shinyUI(pageWithSidebar(
  headerPanel("Dallas Employment Data"),
  sidebarPanel(
    
    selectInput(inputId="ethnicity",
                label="Select ethnicity to compare salaries",
                choices=sort(unique(dallasData$Ethnicity)),
                selected="White"),
    selectInput(inputId="gender",
                label="Select gender to compare salaries",
                choices=sort(unique(dallasData$Gender)),
                selected="F"
                )
    
    #numericInput("id1", "Numeric input, labeled id1", 0, min=0, max=10, step=1),
    #checkboxGroupInput("id2", "Checkbox", 
                       c("Value1"="1", "Value2"="2", "Value3"="3")),
    #dateInput("date", "Date:")
  ),
  mainPanel(
    showOutput("chart1", "polycharts")
    #h3("Illustrating Outputs"),
    #h4("You entered"),
    #verbatimTextOutput("oid1"),
    #h4("You entered"),
    #verbatimTextOutput("oid2"),
    #h4("You entered"),
    #verbatimTextOutput("odate")
  )
))
