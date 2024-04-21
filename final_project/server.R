setwd(Sys.getenv("PWD"))
library(shiny)
library(ggplot2)
library(plotly)

function (input, output) {
    data <- reactive({
        FILE = paste0('data/output_', input$Vc, '_', input$Vp, '_', input$ka, '_', input$CL, '_', input$Q, '.csv')
        read.csv(FILE, header=FALSE, col.names=c("t", "y1", "y2", "y3", "y4"))
    })
    p <- reactive({
        ggplot(data = data()) + theme_bw()
    })
    output$plot1 <- renderPlotly({
        p <- p() + 
            geom_line(aes(x=t, y=y1)) +
            labs(x="Time (Hrs)", y="Central Compartment (mg/0.5ml)", title="Tirzepatide Central Compartment Concentration Over 12 Weeks")
        print(p)
    })
    
    output$plot2 <- renderPlotly({
        p <- p() + 
            geom_line(aes(x=t, y=y2)) + 
            labs(x="Time (Hrs)", y="Peripheral Compartment (mg/0.5ml)", title="Tirzepatide Peripheral Compartment Concentration Over 12 Weeks")
    })
    
    output$plot3 <- renderPlotly({
        p <- p() + 
            geom_line(aes(x=t, y=y4)) + 
            labs(x="Time (Hrs)", y="Cumulative Dose Concentration (mg/0.5ml)", title="Cumulative Dose Concentration Over 12 Weeks")
    })
}
