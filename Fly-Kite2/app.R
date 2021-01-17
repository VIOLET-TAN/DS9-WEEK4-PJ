#
# # This is a Shiny web application for when is suitable to fly kites. 
#LOADING PACKAGES
library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)
library(reshape2)
#LOADING TXT DATA TABLE
kfweather <- read.delim(file = "C:/Users/VioletT/OneDrive/COURSERA/DEVELOPING DATA PRODUCTS/WEEK4/DS9-WK4-PJ/kfweather.txt", 
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

# Define server logic required 
server <- function(input, output) {
    datasetInput <- reactive({
        df <- data.frame(Name = c("skylook",
                                  "temperature",
                                  "humidity",
                                  "windy"),
                         Value = as.character(c(input$skylook,
                                                input$temperature,
                                                input$humidity,
                                                input$windy)),
                         stringsAsFactors = FALSE)
        go <- "go"
        df <- rbind(df,go)
        input <- transpose(df)
        write.table(input,"input.csv", sep=",", quote = FALSE, 
                    row.names = FALSE, col.names = FALSE)
        test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
        test$skylook <- factor(test$skylook, levels = c("cloudy", 
                                                        "rainy", 
                                                        "sunny"))
        Output <- data.frame(Prediction=predict(model,test), 
                             round(predict(model,test,type="prob"), 3))
        print(Output)
    })
    output$contents <- renderPrint({
        if (input$submitbutton>0) { 
            isolate("Done!")
        } else {
            return("Ready. Click Go!")
        }
    })
    output$tabledata <- renderTable({
        if (input$submitbutton>0) {
            isolate(datasetInput())
        } 
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)