setwd(Sys.getenv("PWD"))
library(ggplot2)
library(plotly)
pivot_longer <- tidyr::pivot_longer
data <- read.csv(
    "changeFFM_FM.csv",
    header=TRUE,
    col.names = c(paste0(2.5*1:4), "FFM", "T2DM")
)

data <- pivot_longer(data[, -6], cols=-FFM)
data$FFM <- ifelse(data$FFM == 1, "FFM", "FM")

p <- data %>%
    plot_ly(type="box") %>%
    add_trace(
        x = ~name[data$FFM == "FFM"],
        y = ~value[data$FFM == "FFM"]*100,
        color = I("tomato"),
        name = "FFM"
    ) %>%
    add_trace(
        x = ~name[data$FFM == "FM"],
        y = ~value[data$FFM == "FM"]*100,
        color=I("turquoise"),
        name = "FM"
    ) %>%
    layout(
        boxmode="group",
        yaxis = list(
            title="% Change in Weight (kg)",
            titlefont=list(size = 16),
            tickfont=list(size = 16)
        ),
        xaxis = list(
            title = "Dosing Scheme (mg/0.5mL)",
            titlefont=list(size = 16),
            tickfont=list(size = 16)
        ),
        title="% Change in Fat-Free Mass and Fat Mass over 52 Weeks",
        titlefont=list(size=20)
    )
print(p)
orca("percent_change_FFM_FM.png")
#ggsave("percent_change_FFM_FM.png", bg="white", dpi=600, height=6.5, width=8)
