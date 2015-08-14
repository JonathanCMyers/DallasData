library(shiny)
library(rCharts)
library(quantmod)

#options(RCHART_LIB="polycharts")

shinyUI(pageWithSidebar(
  headerPanel("Dallas Employment Data"),
  sidebarPanel(
   
    
    selectInput(inputId="Ethnicity",
                label="Select a list of ethnicities:",
                choices=c("American Indian", "Asian", "Black", "Hispanic",
                          "Other Asian", "Pacific Islander", "White"),
                multiple=TRUE
    
                
    ),
    #uiOutput("ethOptions"),
    checkboxInput("rchartPlot", "Show rCharts plot", FALSE)
    
    #radioButtons("radio", label=h3("Which graph would you like to see?"),
    #             choices=list("Show no plot" = 1, "Show rCharts plot" = 2, "Show ggplot2" = 3))
    
    #uiOutput("triggerRChart")
    #dallasData$Ethnicity
    #selectInput(inputId="ethnicity",
    #            label="Select ethnicity to compare salaries",
    #            choices=sort(unique(dallasData$Ethnicity)),
    #            selected="White"),
    #selectInput(inputId="gender",
    #            label="Select gender to compare salaries",
    #            choices=sort(unique(dallasData$Gender)),
    #            selected="F"
    #            )
    
    #numericInput("id1", "Numeric input, labeled id1", 0, min=0, max=10, step=1),
    #checkboxGroupInput("id2", "Checkbox", 
                      # c("Value1"="1", "Value2"="2", "Value3"="3")),
    #dateInput("date", "Date:")
  ),
  mainPanel(
    h4("Selected words"),
    textOutput("\n"),
    showOutput("test", "dimple")
    
   # conditionalPanel(
     # div(class="wrapper"),
      #h4("Plot showing Rate of Pay by Ethnicity (using rCharts)"),
      #condition="input.radio == 2",
     # condition="input.rchartPlot == TRUE",
      #showOutput("chart1", "dimple")
      #showOutput("chart1", "polycharts") 
      #showOutput("chart1", "nvd3")
    )
    
    
    #h3("Illustrating Outputs"),
    #h4("You entered"),
    #verbatimTextOutput("oid1"),
    #h4("You entered"),
    #verbatimTextOutput("oid2"),
    #h4("You entered"),
    #verbatimTextOutput("odate")
  )
))
