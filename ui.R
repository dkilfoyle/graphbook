
library(shiny)
library(ggplot2)
library(shinyAce)

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
        tabPanel("Code", aceEditor("myCode","", mode="r"))
      ),
      hr(),
      fluidRow(
        column(3,
               h4("Select Fields"),
               selectInput("myDataFrame", "Dataframe", choices=getDataFrames()),
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
    ), id = "navlist", fluid=F
  )
))
