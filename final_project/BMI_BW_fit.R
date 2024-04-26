setwd(Sys.getenv("PWD"))
library(ggplot2)
library(gridExtra)
data <- read.csv(
    "BMI_BW_data.csv",
    header=FALSE,
    col.names = c("BMI_T2DM", "BW_T2DM", "BMI", "BW", "gender")
)

T2DM_model = lm(BW_T2DM ~ BMI_T2DM, data = data)
normal_model = lm(BW ~ BMI, data = data)

p <- ggplot(data=data) +
    geom_point(aes(x = BMI_T2DM, y=BW_T2DM, color='T2DM'), alpha=0.5) +
    geom_smooth(aes(x=BMI_T2DM, y=BW_T2DM), method='lm', se=FALSE, color='tomato3') +
    geom_point(aes(x=BMI, y=BW, color='normal'), alpha=0.5) +
    geom_smooth(aes(x=BMI, y=BW), method='lm', se=FALSE, color='turquoise3') +
    scale_color_manual(name='Group', values=c("T2DM" = "tomato", "normal" = "turquoise")) + 
    labs(title="Bodyweight Against BMI", x='BMI (kg/m^2)', y= "BW (kg)") + 
    theme_bw()
print(p)