
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
    updateSelectInput(session, "bp_numeric", choices=dfinfo$numerics$name, selected="")
    updateSelectInput(session, "sp_numeric", choices=dfinfo$numerics$name, selected="")
    updateSelectInput(session, "bp_factor", choices=c("factor(0)", as.character(dfinfo$factors$name)), selected="factor(0)", label="Group By")
    
  }, priority=1)
  



  output$bp_plot <- renderPlot({
  
    if (input$navlist == "boxplot") {
      if (input$bp_numeric =="") return()
      
      xx = "ggplot(getSelectedDF(), aes(x={{bp_factor}}, y={{bp_numeric}}{{#bp_fill}}, fill={{bp_factor}}{{/bp_fill}}))"
      xx = paste0(xx, " +\n  geom_boxplot({{#bp_notch}}notch=T{{/bp_notch}})")
      if (input$bp_flip)        xx = paste0(xx, " +\n  coord_flip()")
      if (input$bp_xlab != "")  xx = paste0(xx, " +\n  xlab('{{bp_xlab}}')")
      if (input$bp_ylab != "")  xx = paste0(xx, " +\n  ylab('{{bp_ylab}}')")
      if (input$bp_title != "") xx = paste0(xx, " +\n  ggtitle('{{bp_title}}')")
      if (input$bp_legend == F) xx = paste0(xx, " +\n  guides(fill=F)")
      x=whisker.render(xx, reactiveValuesToList(input))
      updateAceEditor(session, "bp_code", x)
      return(eval(parse(text=whisker.render(x))))
    }
    
  })
    
  output$sp_plot <- renderPlot({  
    if (input$navlist == "scatterplot") {
      if (is.vector(input$sp_numeric) == F) return()
      if (length(input$sp_numeric) < 2) return()
      inputs = reactiveValuesToList(input)
      inputs$sp_numeric1 = input$sp_numeric[1]
      inputs$sp_numeric2 = input$sp_numeric[2]
      template = "ggplot(getSelectedDF(), aes(x={{sp_numeric1}}, y={{sp_numeric2}})) +\n  geom_point() +\n  xlab('{{sp_xlab}}') +\n ylab('{{sp_ylab}}')"
      x=whisker.render(template, inputs)
      updateAceEditor(session, "sp_code", x)
      return(eval(parse(text=whisker.render(x))))
    }

  })

})
