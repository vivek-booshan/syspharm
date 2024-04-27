setwd(Sys.getenv("PWD"))
library(shiny)
library(ggplot2)
library(plotly)
library(tidyr)

q1c <- read.csv(
    "hw3q1c.txt",
    header = FALSE,
    col.names = c("q", "kcl", "V", "ka", "Vd")
)
q1c$names = paste("subject", 1:5)

q1f <- read.csv(
    "hw3q1f.txt",
    header = FALSE,
    col.names = c("q", "kcl", "V", "ka", "Vd")
)
q1f$names = paste("subject", 1:5)
subjects = c("subject 1", "subject 2", "subject 3", 'subject 4', 'subject 5')

caffeine_c <- lapply(1:5, function(i) {
    tablec <- read.csv(
        paste0("subject", i, "tablec.txt"), 
        header=FALSE, 
        col.names=c("t", "yc"))
    tablec$name <- paste("subject", i)
    return(tablec)
})
caffeine_f <- lapply(1:5, function(i) {
    tablef <- read.csv(
        paste0("subject", i, "tablef.txt"),
        header=FALSE,
        col.names=c("t", "yf"))
    tablef$name <- paste("subject", i)
    return(tablef)
})
caffeine_real <- read.csv("exp_data.txt", header=FALSE, check.names=FALSE, col.names=paste("subject", 1:5))
caffeine_real$t <- c(0.25, 0.5, 0.75, 2, 5, 8)
caffeine_real$t <- caffeine_real$t + 1
caffeine_real <- pivot_longer(caffeine_real, !t)
function(input, output) {
    
    output$plot_kcl_V <- renderPlotly({
        p <- ggplot() + theme_bw() +
            geom_point(data=q1c, aes(x=V, y=kcl, shape="w/o 10am", color=(subjects)), alpha=0.5) +
            geom_point(data=q1f, aes(x=V, y=kcl, shape='w/ 10am', color=(subjects)), alpha=0.5) +
            labs(color="Color: Subject", shape="Shape: Inclusion of 10 am dose", 
                 title="clearance rate (kcl) against central compartment volume (V)",
                 x="V (L)", y="kcl (1/hr)")
        p <- p + geom_point(data=subset(q1c, names == input$subject), aes(x=V, y=kcl, shape="w/o 10am", color=input$subject), size=5)
        p <- p + geom_point(data=subset(q1f, names == input$subject), aes(x=V, y=kcl, shape="w/ 10am", color=input$subject), size=5)
    })
    
    output$plot_ka_V <- renderPlotly({
        p <- ggplot() + theme_bw() +
            geom_point(data=q1c, aes(x=V, y=ka, shape="w/o 10am", color=(subjects)), alpha=0.5) + 
            geom_point(data=q1f, aes(x=V, y=ka, shape='w/ 10am', color=(subjects)), alpha=0.5) +
            labs(color="Color: Subject", shape="Shape: Inclusion of 10 am dose", 
                 title="absorbance rate (kcl) against central compartment volume (V)",
                 x="V (L)", y="ka (1/hr)")
        p <- p + geom_point(data=subset(q1c, names == input$subject), aes(x=V, y=ka, shape="w/o 10am", color=input$subject), size=5)
        p <- p + geom_point(data=subset(q1f, names == input$subject), aes(x=V, y=ka, shape="w/ 10am", color=input$subject), size=5)
    })
    
    output$plot_kcl_ka <- renderPlotly({
        p <- ggplot() + theme_bw() +
            geom_point(data=q1c, aes(x=kcl, y=ka, shape="w/o 10am", color=(subjects)), alpha=0.5) + 
            geom_point(data=q1f, aes(x=kcl, y=ka, shape='w/ 10am', color=(subjects)), alpha=0.5) +
            labs(color="Color: Subject", shape="Shape: Inclusion of 10 am dose", 
                 title="clearance rate (kcl) against absorbance rate (ka)",
                 x="kcl (1/hr)", y="ka (1/hr)")
        p <- p + geom_point(data=subset(q1c, names == input$subject), aes(x=kcl, y=ka, shape="w/o 10am", color=input$subject), size=5)
        p <- p + geom_point(data=subset(q1f, names == input$subject), aes(x=kcl, y=ka, shape="w/ 10am", color=input$subject), size=5)
    })
    
    output$plot_caffeine_conc <- renderPlotly({
        p <- ggplot() + theme_bw()
        for (i in 1:5) {
            p <- p + 
                geom_line(data=caffeine_c[[i]], aes(x=t, y=yc, color=name, linetype="w/o 10am"), alpha=0.2) +
                geom_line(data=caffeine_f[[i]], aes(x=t, y=yf, color=name, linetype="w/ 10am"), alpha=0.3) 
        }
        p <- p + 
            geom_line(
                data=caffeine_c[[as.numeric(gsub("[^0-9]", "", input$subject))]],
                aes(x=t, y=yc, color=name, linetype="w/o 10am")) +
            geom_line(
                data=caffeine_f[[as.numeric(gsub("[^0-9]", "", input$subject))]],
                aes(x=t, y=yf, color=name, linetype="w/ 10am")) +
            geom_point(
                data=caffeine_real,
                aes(x=t, y=value, color=name), alpha=0.2
            ) + 
            geom_point(
                data=subset(caffeine_real, name == input$subject),
                aes(x=t, y=value, color=input$subject)
            ) + labs(color="Color: Subject", linetype="Linetype: Inclusion of 10 am dose",
                     x="Hours since 10 am", y="Caffeine Concentration (mg/L)",
                     title="Predicted and Measured Caffeine Concentration Since 10am")
            
    })
}