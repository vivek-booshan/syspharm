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
    titlePanel("Heparine Protamine Model"),
    
    sidebarPanel(
        class="sidebar-scroll",
        h5("Shown are the concentrations of free and total heparin/protamine 
           and the heparine-protamine complex based on varying infusion rates.
           Filter by time range or see what happens if the heparine-protamine 
           clearance rate is set to the same value as the heparin clearance rate."),
        sliderInput("time", "Time (hrs)", min=0, max=5, value=c(0, 5), step=0.05),
        checkboxInput('short_halflife', 'Set Heparine-Protamine Clearance to Heparin Clearance?'),
    ),
    
    mainPanel(
        fluidRow(
            verticalLayout(
                plotlyOutput('plot_h'),
                plotlyOutput('plot_p'),
                plotlyOutput('plot_hp'),
                plotlyOutput('plot_htot'),
                plotlyOutput('plot_ptot')
            )
        )
    )
)