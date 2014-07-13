
library(shiny)
library(ggplot2)
library(shinyAce)

source("R/dkdfinfo.r")
data(iris)
data(diamonds)

shinyUI(fluidPage(
  
  includeScript("www/jquery-ui-1.10.3.custom.min.js"),

  # Application title
  titlePanel("Graph Cookbook"),

  navlistPanel(
    "Info",
    tabPanel("Dataframes", value="dataframes",
      fluidRow(
        selectInput("myDataFrame", "Dataframe", choices=getDataFrames())
      ),
      hr(),
      fluidRow(
        tabsetPanel(
          tabPanel("Numerics", dataTableOutput("dataframeNumerics")),
          tabPanel("Factors", dataTableOutput("dataframeFactors")),
          tabPanel("Logicals", dataTableOutput("dataframeLogicals")),
          tabPanel("Dates", dataTableOutput("dataframeDates"))
        )
      )
    ),
    
    "------",
    "Graphs",
    
    # boxplot tabpanel
    tabPanel("Box Plot", value="boxplot",
      tabsetPanel(
        tabPanel("Plot", plotOutput("bp_plot")),
        tabPanel("Code", aceEditor("bp_code","", mode="r"))
      ),
      hr(),
      fluidRow(
        column(3,
               h4("Select Fields"),
               selectizeInput("bp_numeric", "Numeric", choices=getdfinfo(getDataFrames()[1])$numerics$name, options=list(dropdownParent="body")),
               selectizeInput("bp_factor", "Group By", choices=c("factor(0)", as.character(getdfinfo(getDataFrames()[1])$factors$name)), options=list(dropdownParent="body"))
               
        ),
        column(4, offset = 1,
               h4("Labels"),
               textInput("bp_title", "title"),
               textInput("bp_xlab", "X Axis"),
               textInput("bp_ylab", "Y Axis")
        ),
        column(4,
               h4("Options"),
               checkboxInput("bp_flip", label = "Horizontal", value=F),
               checkboxInput("bp_fill", label = "Colour Fill", value=F),
               checkboxInput("bp_notch", label = "Notched", value=F),
               checkboxInput("bp_legend", label = "Legend", value=F)
        ) 
      )
    ), # end of boxplot panel
    
    # boxplot tabpanel
    tabPanel("Scatter Plot", value="scatterplot",
       tabsetPanel(
         tabPanel("Plot", plotOutput("sp_plot")),
         tabPanel("Code", aceEditor("sp_code","", mode="r"))
       ),
       hr(),
       fluidRow(
         column(3,
                h4("Select Fields"),
                selectizeInput("sp_numeric", "Numeric", choices=getdfinfo(getDataFrames()[1])$numerics$name, 
                               options=list(dropdownParent="body", plugins=list(remove_button="", drag_drop="")), multiple=T)
         ),
         column(4, offset = 1,
                h4("Labels"),
                textInput("sp_title", "title"),
                textInput("sp_xlab", "X Axis"),
                textInput("sp_ylab", "Y Axis")
         ),
         column(4,
                h4("col3")
         ) 
       )
    ), # end of boxplot panel    
    
    
    
    
    id = "navlist", fluid=F
  )
))
