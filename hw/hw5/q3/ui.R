library(shiny)
library(ggplot2)
library(plotly)

fluidPage(
    tags$head(
        tags$style(HTML(
            "
              .sidebar-scroll {
                position: fixed;
                top: 10;
                height: 430px;
                overflow-y: auto; /* Enable vertical scrolling */
                width: 250px; /* Adjust width as needed */
                padding: 20px; /* Adjust padding as needed */
                background-color: #f9f9f9; /* Background color of the sidebar */
                border-right: 1px solid #ddd; /* Add border for better separation */
                z-index: 1000; /* Ensure the sidebar stays on top */
              }
             "
        ))
    ),
    titlePanel("Tapentadol Model"),
    
    sidebarPanel(
        class = "sidebar-scroll",
        h5("Shown are the allometric parameter and dosage distributions
           for a Tapentadol Model with and without interindividual variability (IIV).
           Choose between IIV and Dosage type to filter the plots as needed."),
        selectInput(
            "iiv", "Interindividual Variability", 
            choices = c("without IIV", "just IIV", "both"),
            selected="both"
        ),
        selectInput(
            "dose", "Dosage Method", 
            choices = c("Fixed Dosage" = "fixed", "Weight-Based Dosage" = "weight", "both"),
            selected="both"
        )
    ),
    
    mainPanel(
        fluidRow(
            verticalLayout(
                plotlyOutput("IIV"),
                plotlyOutput("AUC")
            )
        )
    )
)