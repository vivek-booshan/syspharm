setwd(Sys.getenv("PWD"))
library(ggplot2)
library(plotly)
pivot_longer <- tidyr::pivot_longer
data <- read.csv(
    "changeBW.csv",
    header=TRUE,
    col.names = c(paste0(2.5*1:4), "T2DM")
)

data <- pivot_longer(data, cols=-T2DM)
data$T2DM <- ifelse(data$T2DM == 1, "T2DM", "normal")

p <- data %>%
    plot_ly(type="box") %>%
    add_trace(
        x = ~name[data$T2DM == "T2DM"],
        y = ~value[data$T2DM == "T2DM"]*100,
        color = I("tomato"),
        name = "T2DM"
    ) %>%
    add_trace(
        x = ~name[data$T2DM == "normal"],
        y = ~value[data$T2DM == "normal"]*100,
        color=I("turquoise"),
        name = "normal"
    ) %>%
    layout(
        boxmode="group",
        yaxis = list(
            title="% Change in Total BW (kg)"
        ),
        xaxis = list(
            title = "Dosing Scheme (mg/0.5mL)"
        ),
        title="% Change in Total BW over 52 Weeks for Monotonic Dosing"
    )
print(p)
