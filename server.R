library(shiny)
require(rCharts)
options(RCHART_WIDTH=800)
shinyServer(
  function(input, output){
    output$chart1 <- renderChart({
      p1 <- rPlot()
      return(p1)
    })
    
    
    #output$oid1 <- renderPrint({input$id1})
    #output$oid2 <- renderPrint({input$id2})
    #output$odate <- renderPrint({input$date})
  }    
)
