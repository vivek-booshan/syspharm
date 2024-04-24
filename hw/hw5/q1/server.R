library(shiny)
library(ggplot2)
library(plotly)

hw2q1a_0 <- read.csv(
    "hw2q1a_infusion_0.csv",
    header = FALSE,
    col.names = c("t", "h", "p", "hp")
)
hw2q1a_0$htot <- hw2q1a_0$h + hw2q1a_0$hp
hw2q1a_0$ptot <- hw2q1a_0$p + hw2q1a_0$hp

hw2q1a_5890 <- read.csv(
    "hw2q1a_infusion_5890.csv",
    header = FALSE,
    col.names = c("t", "h", "p", "hp")
)
hw2q1a_5890$htot <- hw2q1a_5890$h + hw2q1a_5890$hp 
hw2q1a_5890$ptot <- hw2q1a_5890$p + hw2q1a_5890$hp

hw2q1a_58900 <- read.csv(
    "hw2q1a_infusion_58900.csv",
    header = FALSE,
    col.names = c("t", "h", "p", "hp")
)
hw2q1a_58900$htot <- hw2q1a_58900$h + hw2q1a_58900$hp
hw2q1a_58900$ptot <- hw2q1a_58900$p + hw2q1a_58900$hp

hw2q1a_589000 <- read.csv(
    "hw2q1a_infusion_589000.csv",
    header = FALSE,
    col.names = c("t", "h", "p", "hp")
)
hw2q1a_589000$htot <- hw2q1a_589000$h + hw2q1a_589000$hp
hw2q1a_589000$ptot <- hw2q1a_589000$p + hw2q1a_589000$hp

hw2q1b_0 <- read.csv(
   "hw2q1b_infusion_0.csv",
   header = FALSE,
   col.names = c("t", "h", "p", 'hp')
)
hw2q1b_0$htot <- hw2q1b_0$h + hw2q1b_0$hp
hw2q1b_0$ptot <- hw2q1b_0$p + hw2q1b_0$hp

hw2q1b_5890 <- read.csv(
   "hw2q1b_infusion_5890.csv",
   header = FALSE,
   col.names = c("t", "h", 'p', 'hp')
)
hw2q1b_5890$htot <- hw2q1b_5890$h + hw2q1b_5890$hp
hw2q1b_5890$ptot <- hw2q1b_5890$p + hw2q1b_5890$hp

hw2q1b_58900 <- read.csv(
   "hw2q1b_infusion_58900.csv",
   header = FALSE,
   col.names = c("t", "h", 'p', 'hp')
)
hw2q1b_58900$htot <- hw2q1b_58900$h + hw2q1b_58900$hp
hw2q1b_58900$ptot <- hw2q1b_58900$p + hw2q1b_58900$hp

hw2q1b_589000 <- read.csv(
   "hw2q1b_infusion_589000.csv",
   header = FALSE,
   col.names = c("t", "h", 'p', 'hp')
)
hw2q1b_589000$htot <- hw2q1b_589000$h + hw2q1b_589000$hp
hw2q1b_589000$ptot <- hw2q1b_589000$p + hw2q1b_589000$hp

hw2q1a = list(hw2q1a_0, hw2q1a_5890, hw2q1a_58900, hw2q1a_589000)
hw2q1b = list(hw2q1b_0, hw2q1b_5890, hw2q1b_58900, hw2q1b_589000)
variables = c('h', 'p', 'hp')
infusion = c('0', '5890', '58900', '589000')
geom_line_append <- function (p, subset, variable, infusion) {
    return(
        p + geom_line(
            data=subset, 
            aes_string(
                x="t", y=variable, 
                color=factor(infusion)
            )
        )
    )
}

function(input, output, session) {
    subset_a_list <- reactive({
        # returns closure, must extract to result
        result <- lapply(hw2q1a, function (dataset) {
            subset(dataset, t >= input$time[1] & t <= input$time[2])
        })
        return(result)
    })
    
    subset_b_list <- reactive({
        result <- lapply(hw2q1b, function(dataset) {
            subset(dataset, t >= input$time[1] & t <= input$time[2])
        })
        return(result)
    })

    output$plot_h <- renderPlotly({
        p <- ggplot()

        if (!input$short_halflife) {
            for (i in 1:4) {
                p <- geom_line_append(p, subset_a_list()[[i]], "h", infusion[i])
            }
        } else {
            for (i in 1:4) {
                p <- geom_line_append(p, subset_b_list()[[i]], "h", infusion[i])
            }
        }
        p <- p + labs(color="infusion (nmol/hr)", x="time (hrs)", y="[D] (nmol)", 
                      title="Concentration of Free Heparin (H) Over Time") +
            theme_bw()
        plotly_build(p)
    })

    output$plot_p <- renderPlotly({
        p <- ggplot()
        
        if (!input$short_halflife) { 
            for (i in 1:4) {
                p <- geom_line_append(p, subset_a_list()[[i]], "p", infusion[i])
            }
            p <- p + labs(color='infusion', x='time (hrs)', y = '[D] (nmol)')
        } else {
            for (i in 1:4) {
                p <- geom_line_append(p, subset_b_list()[[i]], "p", infusion[i])
            }
            p <- p + labs(color='infusion', x='time (hrs)', y = '[D] (nmol)')
        }
        p <- p + labs(
                color='infusion (nmol/hr)', 
                x='time (hrs)', y = '[D] (nmol)', 
                title="Concentration of Free Protamine (P) Over Time") +
            theme_bw()
        p
    })
    
    output$plot_hp <- renderPlotly({
        p <- ggplot()
        
        if (!input$short_halflife) { 
            for (i in 1:4) {
                p <- geom_line_append(p, subset_a_list()[[i]], "hp", infusion[i])
            }
        } else {
            for (i in 1:4) {
                p <- geom_line_append(p, subset_b_list()[[i]], "hp", infusion[i])
            }
        }
        p <- p + labs(
            color='infusion (nmol/hr)', 
            x='time (hrs)', y = '[D] (nmol)', 
            title="Concentration of Heparine Protamine (HP) Complex Over Time") +
            theme_bw()
        p
    })
    
    output$plot_htot <- renderPlotly({
        p <- ggplot()
        
        if (!input$short_halflife) { 
            for (i in 1:4) {
                p <- geom_line_append(p, subset_a_list()[[i]], "htot", infusion[i])
            }
        } else {
            for (i in 1:4) {
                p <- geom_line_append(p, subset_b_list()[[i]], "htot", infusion[i])
            }
        }
        p <- p + labs(
            color='infusion (nmol/hr)', 
            x='time (hrs)', y = '[D] (nmol)', 
            title="Concentration of Total Heparine (H + HP) Over Time") +
            theme_bw()
        p
    })
    
    output$plot_ptot <- renderPlotly({
        p <- ggplot()
        
        if (!input$short_halflife) { 
            for (i in 1:4) {
                p <- geom_line_append(p, subset_a_list()[[i]], "ptot", infusion[i])
            }
        } else {
            for (i in 1:4) {
                p <- geom_line_append(p, subset_b_list()[[i]], "ptot", infusion[i])
            }
        }
        p <- p + labs(
            color='infusion (nmol/hr)', x='time (hrs)', y = '[D] (nmol)', 
            title="Concentration of Total Protamine (P + HP) Over Time") +
            theme_bw()
        p
    })
}

