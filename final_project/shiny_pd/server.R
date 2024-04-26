setwd(Sys.getenv("PWD"))
library(shiny)
library(ggplot2)
library(plotly)

BMI = seq(15, 50, 0.1)
function (input, output) {
    data <- reactive({
        FILE = paste0('shinyBMI_', which(BMI == input$bmi), "_data.csv")
        read.csv(
            file=FILE,
            header=FALSE,
            col.names=c("t", "male_T2DM", "female_T2DM", "male_normal", "female_normal")
        )
    })
    
    observe({
        print(which(BMI ==input$bmi))
        print(paste0(input$sex, "_", input$diabetes))
    })
    output$plot <- renderPlotly({
        
        if (input$sex == "male") {
            oppsex = "female"
        } else {
            oppsex = "male"
        }
        
        if (input$diabetes == "T2DM") {
            oppdia = "normal"
        } else {
            oppdia = "T2DM"
        }
        data_scale <- data()
        data_scale[, -1] <- lapply(data_scale[, -1], function (x) (x/max(x) - 1))
        user = paste0(input$sex, "_", input$diabetes)
        non_user_dia = paste0(input$sex, "_", oppdia)
        non_user_sex = paste0(oppsex, "_", input$diabetes)
        non_user_both = paste0(oppsex, "_", oppdia)
        p <- ggplot(data=data_scale) + theme_bw() +
            geom_line(aes(x=t, y=!!sym(user), color=user)) + 
            geom_line(aes(x=t, y=!!sym(non_user_dia), color=non_user_dia), alpha=0.2) +
            geom_line(aes(x=t, y=!!sym(non_user_sex), color=non_user_sex), alpha=0.2) + 
            geom_line(aes(x=t, y=!!sym(non_user_both), color=non_user_both), alpha=0.2) +
            labs(
                title="Expected % Change in Bodyweight after 1 year", 
                x="time (weeks)", y="% Change in Bodyweight") 
    })
    
}