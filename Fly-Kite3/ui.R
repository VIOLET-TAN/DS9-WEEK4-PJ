#
# This is a Shiny web application for when is suitable to fly kites. 
# LOADING PACKAGES
library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)

# LOADING TXT DATA TABLE
kfweather <- read.delim(file = "kfweather.txt", 
                        header = TRUE, sep = ",", stringsAsFactors = TRUE)
# BUILDING MODEL
model <- randomForest(go ~ ., data = kfweather, ntree = 500, mtry = 4, importance = TRUE)
# Define UI for application
ui <- fluidPage(theme = shinytheme("simplex"),
                # Application title
                headerPanel('Time to Fly a Kite?'),
                sidebarPanel(HTML("<h3>Give Parameters and Hit Go</h3>"),  
                             selectInput("skylook" , label = "Skylook", 
                                         choices = list ("Sunny"="sunny" , 
                                                         "Cloudy"="cloudy",
                                                         "Rainy"="rainy"),
                                         selected = "Cloudy"),
                             sliderInput("temperature" , "Temperature" , min=64 , max=86,
                                         value=70),
                             sliderInput("humidity" , "Humidity" , min=65 , max=96,
                                         value=90),
                             selectInput("windy" , "Windy" , choices =list ("Yes"="TRUE" , 
                                                                            "No"="FALSE"), selected = "TRUE"),
                             
                             actionButton("submitbutton", "Go", 
                                          class = "btn btn-primary")
                ),
                
                
                mainPanel(tags$label(h3('Prediction Outcome'), 
                                     verbatimTextOutput('contents'), 
                                     tableOutput('tabledata'))
                )
)
#

