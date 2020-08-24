library(devtools)
install_github("https://github.com/ahmetakdeve/Lab5_17",subdir = "swelection")
library(shiny)
library(swelection)
library(dplyr)
library(ggplot2)
linkoping2<-votes_spec("0580K")

ui <- fluidPage(
  titlePanel("test"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Type in m's code and a's name to get the vote-party plot"),

      textInput("Area", 
                "Type in the name of an vote-area in Linkoping"),
      actionButton("search", "Search")
                ),
    mainPanel(
      plotOutput("voteparty")
    )
  )
)



server <- function(input, output){

  output$voteparty<-renderPlot({linkoping2 %>% filter(NAMN==as.character(input$Area)) %>%
      ggplot(aes(x=PARTI,y=PROCENT))+geom_bar(stat="identity")
  })
}


shinyApp(ui = ui, server = server)

