
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
    updateSelectInput(session, "myFactor", choices=dfinfo$factors$name, selected="")
    
  }, priority=1)
  
  

  output$myPlot <- renderPlot({
  
    if (input$navlist == "boxplot") {
      if (input$myNumeric =="") return()
      numeric1=input$myNumeric
      template="ggplot(getSelectedDF(), aes(x=factor(0), y={{numeric1}})) + geom_boxplot()"
      x=whisker.render(template)
      eval(parse(text=whisker.render(template)))
    }

  })

})
