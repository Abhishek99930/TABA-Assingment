library("shiny")
if (!require(shiny)){install.packages("shiny")}
if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(stringr)){install.packages("stringr")}
if (!require(readr)){install.packages("readr")}
if (!require(rvest)){install.packages("rvest")}
library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)
library(readr)
library(rvest)
require(stringr)

shinyUI(
  fluidPage(
    
    titlePanel("UDPipe around NLP-workflow"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file1", "Upload data (Text file with header)"),
        
        fileInput("file2", "Upload data (Udpipe Trainedmdel)"),
        
        checkboxGroupInput(inputId = 'upos',
                           label = h3('Part of Speech'),
                           choices =list("adjective"= "ADJ",
                                         "Noun" = "NOUN",
                                         "proper noun" = "PROPN",
                                         "adverb"="ADV","verb"= "VERB"),
                           selected = c("ADJ","NOUN","PROPN"))
      ),   # end of sidebar panel
      
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             h4(p("Data input")),
                             p("This app supports only comma separated values (.txt)",align="justify"),
                             p("Please refer to the link below for sample txt file."),
                             a(href="https://raw.githubusercontent.com/sudhir-voleti/sample-data-sets/master/text%20analysis%20data/amazon%20nokia%20lumia%20reviews.txt"
                               ,"Sample data input file"),   
                             br(),
                             h4('How to use this App'),
                             p('To use this app, click on', 
                               span(strong("Upload data (Text file with header)")),
                               'and uppload the text data file. You also have to add the trained udpipe model')),
                    
                    tabPanel("Co-occurence_plot", 
                             plotOutput('plot1')),
                    
                    tabPanel("Word_cloud",
                             tableOutput('plot2')),
                    
                    tabPanel("Data",
                             dataTableOutput('Data'))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI



