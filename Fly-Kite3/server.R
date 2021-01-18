#
# # Define server logic required 
library(shiny)
library(RCurl)
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
