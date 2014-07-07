
library(shiny)
library(ggplot2)

source("R/dkdfinfo.r")
data(iris)
data(diamonds)

shinyUI(fluidPage(

  # Application title
  titlePanel("Graph Cookbook"),

  navlistPanel(
    "Graphs",
    tabPanel("Box Plot", value="boxplot",
      tabsetPanel(
        tabPanel("Plot", plotOutput("myPlot")),
        tabPanel("Code", verbatimTextOutput("myCode"))
      ),
      hr(),
      fluidRow(
        column(3,
               h4("Select Fields"),
               selectInput("myDataFrame", "Dataframe", choices=getDataFrames()),
               selectInput("myNumeric", "Numeric", choices=getdfinfo(getDataFrames()[1])$numerics$name),
               selectInput("myFactor", "Group By", choices=getdfinfo(getDataFrames()[1])$factors$name)
               
        ),
        column(4, offset = 1,
               h4("Col2")
        ),
        column(4,
               h4("col3")
        ) 
      )
    ), id = "navlist", fluid=F
  )
))
