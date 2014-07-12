
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
    tabPanel("Data", value="dataframes",
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
               selectizeInput("myNumeric", "Numeric", choices=getdfinfo(getDataFrames()[1])$numerics$name, options=list(dropdownParent="body")),
               selectizeInput("myFactor", "Group By", choices=c("factor(0)", as.character(getdfinfo(getDataFrames()[1])$factors$name)), options=list(dropdownParent="body"))
               
        ),
        column(4, offset = 1,
               h4("Labels"),
               textInput("myTitle", "title"),
               textInput("myXLab", "X Axis"),
               textInput("myYLab", "Y Axis")
        ),
        column(4,
               h4("col3")
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
                selectizeInput("myNumeric", "Numeric", choices=getdfinfo(getDataFrames()[1])$numerics$name, 
                               options=list(dropdownParent="body", plugins=list(remove_button="", drag_drop="")), multiple=T)
         ),
         column(4, offset = 1,
                h4("Labels"),
                textInput("myTitle", "title"),
                textInput("myXLab", "X Axis"),
                textInput("myYLab", "Y Axis")
         ),
         column(4,
                h4("col3")
         ) 
       )
    ), # end of boxplot panel    
    
    
    
    
    id = "navlist", fluid=F
  )
))
