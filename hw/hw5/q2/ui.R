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
    titlePanel("Caffeine Model"),
    
    sidebarPanel(
        class = "sidebar-scroll",
        h5("The following 3 scatter plots between
           the clearance rate and absorbance rate constants against
           the central volume component as well as against each other. 
           The final plot shows the caffeine concentration against experimental measurements.
           (For all plots, values based on knowledge of the 10 am coffee dose and without are shown)"),
        selectInput("subject", "Select Subject", choices = paste("subject", 1:5)),
        tags$b("Select a subject to highlight it!")
    ),
    
    mainPanel(
        fluidRow(
            verticalLayout(
                plotlyOutput('plot_kcl_V'),
                plotlyOutput('plot_ka_V'),
                plotlyOutput('plot_kcl_ka'),
                plotlyOutput('plot_caffeine_conc')
            )
        )
    )
)