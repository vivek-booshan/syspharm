setwd(Sys.getenv("PWD"))
library(shiny)
library(ggplot2)
library(plotly)

FILE = paste0("data/",
            "output_2.480000e+00_3.910000e+00_3.630000e-02_3.260000e-02_1.250000e-01",
            ".csv")
median_data = read.csv(FILE, header=FALSE, col.names=c("t", "y1", "y2", "y3", "y4"))
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
            geom_line(data=median_data, aes(x=t, y=y1), color='pink') +
            geom_line(aes(x=t, y=y1)) +
            labs(x="Time (weeks)", y="Central Compartment (mg/L)", 
                 title="Tirzepatide Central Compartment Concentration Over 16 Weeks") +
            scale_x_continuous(breaks=seq(0, 16, by=4))
    })
    
    output$plot2 <- renderPlotly({
        p <- p() + 
            geom_line(data=median_data, aes(x=t, y=y2), color='pink') +
            geom_line(aes(x=t, y=y2)) + 
            labs(x="Time (weeks)", y="Peripheral Compartment (mg/L)", 
                 title="Tirzepatide Peripheral Compartment Concentration Over 16 Weeks") +
            scale_x_continuous(breaks=seq(0, 16, by=4))
    })
    
    output$plot3 <- renderPlotly({
        p <- p() + 
            geom_line(data=median_data, aes(x=t, y=y4), color='pink') +
            geom_line(aes(x=t, y=y4)) + 
            labs(x="Time (weeks)", y="Cumulative Dose Concentration (mg/L)", 
                 title="Cumulative Dose Concentration Over 16 Weeks") +
            scale_x_continuous(breaks=seq(0, 16, by=4))
    })
}
