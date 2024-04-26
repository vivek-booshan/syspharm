setwd(Sys.getenv("PWD"))
library(plotly)

pivot_longer <- tidyr::pivot_longer

data <- read.csv(
    "BMI_BW_data.csv",
    header=TRUE,
    col.names=c("T2DM_BMI", "T2DM_BW", "T2DM_SEX", "noT2DM_BMI", "noT2DM_BW", "noT2DM_SEX")
)
BMI = data[c("T2DM_BMI", "noT2DM_BMI", "T2DM_SEX")];
BW = data[c("T2DM_BW", "noT2DM_BW", "T2DM_SEX")];

data <- pivot_longer(data, cols=-noT2DM_SEX);
BMI_pivot <- BMI %>% 
    pivot_longer(cols=-T2DM_SEX, values_to="BMI") %>% 
    mutate(T2DM = if_else(grepl("^T2DM", name), "T2DM", "noT2DM")) %>% 
    select(-name)
BMI_pivot$T2DM_SEX <- as.factor(BMI_pivot$T2DM_SEX)
BW_pivot <- BW %>% 
    pivot_longer(cols=-T2DM_SEX, values_to="BW") %>% 
    mutate(T2DM = if_else(grepl("^T2DM", name), "T2DM", "noT2DM")) %>% 
    select(-name)
BW_pivot$T2DM_SEX <- as.factor(BW_pivot$T2DM_SEX)

p <- BMI_pivot %>%
    plot_ly(type='violin') %>%
    add_trace(
        y = ~BMI[BMI_pivot$T2DM_SEX == 1],
        split = ~T2DM[BMI_pivot$T2DM_SEX == 1],
        color = I("blue"),
        box = list(visible = T),
        meanline = list(visible=T)
    ) %>%
    add_trace(
        y = ~BMI[BMI_pivot$T2DM_SEX == 0],
        split = ~T2DM[BMI_pivot$T2DM_SEX == 0],
        color = I("pink"),
        box = list(visible = T),
        meanline = list(visible=T)
    ) %>% 
    layout(
        showlegend=FALSE,
        violinmode = 'group', 
        yaxis=list(
            title="BMI"
            ),
        title = "BMI Distributions by Sex for Virtual Patients"
    )
print(p)

p <- BW_pivot %>%
    plot_ly(type='violin') %>%
    add_trace(
        y = ~BW[BW_pivot$T2DM_SEX == 1],
        split = ~T2DM[BW_pivot$T2DM_SEX == 1],
        color = I("blue"),
        box = list(visible = T),
        meanline = list(visible=T)
    ) %>%
    add_trace(
        y = ~BW[BW_pivot$T2DM_SEX == 0],
        split = ~T2DM[BW_pivot$T2DM_SEX == 0],
        color = I("pink"),
        box = list(visible = T),
        meanline = list(visible=T)
    ) %>% 
    layout(
        showlegend=FALSE,
        violinmode = 'group', 
        yaxis=list(
            title="Bodyweight (kg)"
        ),
        title = "Bodyweight Distributions by Sex for Virtual Patients"
    )
print(p)