setwd(Sys.getenv("PWD"))
library(shiny)
library(ggplot2)
library(plotly)
library(tidyr)

params = c("V", "CL", "ka", "kCL")
wIIV = read.csv("wIIV.txt", header = FALSE, col.names = c("wt", "V_IIV", "CL_IIV", "ka_IIV", "kCL_IIV"))
woIIV = read.csv("woIIV.txt", header = FALSE, col.names=c("wt", "V", "CL", "ka", "kCL"))
pivot_IIV = pivot_longer(merge(log(wIIV), log(woIIV), by="wt"), cols=everything())

AUC_fixed_IIV = read.csv("fixed_IIV.txt", header=FALSE, col.names = c("wt", "fixed_IIV"))
AUC_fixed = read.csv("fixed_woIIV.txt", header=FALSE, col.names = c("wt", "fixed"))
AUC_weight_IIV = read.csv("weight_IIV.txt", header=FALSE, col.names = c("wt", "weight_IIV"))
AUC_weight = read.csv("weight_woIIV.txt", header=FALSE, col.names=c("wt", "weight"))
merge_fixed = merge(AUC_fixed, AUC_fixed_IIV, by="wt")
merge_weight = merge(AUC_weight, AUC_weight_IIV, by="wt")
pivot_AUC = pivot_longer(merge(merge_fixed, merge_weight, by="wt"), cols=!wt)
function(input, output) {
    
    pivot_IIV_filter <- reactive({
        switch(input$iiv, 
            "without IIV" = return(filter(pivot_IIV, name %in% c("wt", params))),
            "just IIV" = return(filter(pivot_IIV, name %in% c("wt", paste0(params, "_IIV")))),
            "both" = return(pivot_IIV)
        )
    })
    pivot_AUC_filter <- reactive({
        switch(input$iiv,
            "without IIV" = {df <- (filter(pivot_AUC, name %in% c("fixed", "weight")))},
            "just IIV" = {df <- (filter(pivot_AUC, name %in% c("fixed_IIV", "weight_IIV")))},
            "both" = {df <- pivot_AUC}
        )
        switch(input$dose,
            "fixed" = return(filter(df, name %in% c("fixed", "fixed_IIV"))),
            "weight" = return(filter(df, name %in% c("weight", "weight_IIV"))),
            "both" = return(df)
        )
    })
    output$IIV <- renderPlotly({
         p <- pivot_IIV_filter() %>%
            plot_ly(
                x=~name,
                y=~value,
                split=~name,
                type='violin'
             ) %>%
             layout(
                 yaxis=list(range=c(-15, 15), title="Log Distribution"),
                 xaxis=list(title="Allometry and IIV")
             )
         p
    })
    
    output$AUC <- renderPlotly({
        p <- pivot_AUC_filter() %>%
            plot_ly(
                x=~name,
                y=~value,
                split=~name,
                type="violin"
            ) %>%
            layout(
                yaxis=list(range=c(-500, 3500), title="AUC"),
                xaxis=list(title="Dosage Regime and IIV")
            )
        p
    })
}