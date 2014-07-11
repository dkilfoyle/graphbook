
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
    
    # Update the field selects
    updateSelectInput(session, "myNumeric", choices=dfinfo$numerics$name, selected="")
    updateSelectInput(session, "myFactor", choices=c("factor(0)", as.character(dfinfo$factors$name)), selected="factor(0)", label="Group By")
    
    # Update the labels
    # updateTextInput(session, "myXAxis", value=)
    
  }, priority=1)
  
  

  output$myPlot <- renderPlot({
  
    if (input$navlist == "boxplot") {
      if (input$myNumeric =="") return()
      template = "ggplot(getSelectedDF(), aes(x={{myFactor}}, y={{myNumeric}})) + geom_boxplot() + xlab('{{myXLab}}') + ylab('{{myYLab}}')"
      x=whisker.render(template, reactiveValuesToList(input))
      eval(parse(text=whisker.render(x)))
    }

  })

})
