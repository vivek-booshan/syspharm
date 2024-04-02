library(shiny)
library(ggplot2)

fluidPage(
    
    titlePanel("Heparine Protamine Model"),
    
    sidebarPanel(
        numericInput("min", "Min value : ", value=0),
        numericInput("max", "Max value : ", value=5),
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