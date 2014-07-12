
library(shiny)
library(whisker)

shinyServer(function(input, output, session) {
  
  # Return the requested dataset
  getSelectedDFName <- reactive({
    input$myDataFrame
  })

  getSelectedDF <- reactive({
    eval(parse(text=input$myDataFrame))
  })
  
  getDFInfo <- reactive({
    getdfinfo(input$myDataFrame)
  })
  
  # use observe to connect a change in input$dataset to the select boxes
  observe({
    dfinfo = getDFInfo()
    
    if (nrow(dfinfo$numerics)>0)  output$dataframeNumerics <- renderDataTable(dfinfo$numerics, options=list(bPaginate=F, bFilter=F, bInfo=F))
    if (nrow(dfinfo$factors)>0)   output$dataframeFactors <- renderDataTable(dfinfo$factors, options=list(bPaginate=F, bFilter=F, bInfo=F))
    if (nrow(dfinfo$logicals)>0)  output$dataframeLogicals <- renderDataTable(dfinfo$logicals, options=list(bPaginate=F, bFilter=F, bInfo=F))
    if (nrow(dfinfo$dates)>0)     output$dataframeDates <- renderDataTable(dfinfo$dates, options=list(bPaginate=F, bFilter=F, bInfo=F))
    
    # Update the field selects
    updateSelectInput(session, "myNumeric", choices=dfinfo$numerics$name, selected="")
    updateSelectInput(session, "myFactor", choices=c("factor(0)", as.character(dfinfo$factors$name)), selected="factor(0)", label="Group By")
    
  }, priority=1)
  



  output$bp_plot <- renderPlot({
  
    if (input$navlist == "boxplot") {
      if (input$myNumeric =="") return()
      template = "ggplot(getSelectedDF(), aes(x={{myFactor}}, y={{myNumeric}})) + geom_boxplot() + xlab('{{myXLab}}') + ylab('{{myYLab}}')"
      x=whisker.render(template, reactiveValuesToList(input))
      return(eval(parse(text=whisker.render(x))))
    }
    
  })
    
  output$sp_plot <- renderPlot({  
    if (input$navlist == "scatterplot") {
      if (input$myNumeric =="") return()
      template = "ggplot(getSelectedDF(), aes(x={{myFactor}}, y={{myNumeric}})) + geom_boxplot() + xlab('{{myXLab}}') + ylab('{{myYLab}}')"
      x=whisker.render(template, reactiveValuesToList(input))
      return(eval(parse(text=whisker.render(x))))
    }

  })

})
