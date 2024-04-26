setwd(Sys.getenv("PWD"))
library(ggplot2)
library(gridExtra)
data <- read.csv(
    "allometry_data.csv",
    header=FALSE,
    col.names=c("BMI_T2DM", "iCL_T2DM", "iVc_T2DM", "iVp_T2DM", "BMI", "iCL", "iVc", "iVp")
)

pCL <- ggplot(data=data) + 
    geom_point(aes(x=BMI_T2DM, y=iCL_T2DM, color="T2DM"), alpha=0.5) +
    geom_smooth(aes(x=BMI_T2DM, y=iCL_T2DM), method='lm', se=FALSE, color='tomato3') +
    geom_point(aes(x=BMI, y=iCL, color="normal"), alpha=0.5) + 
    geom_smooth(aes(x=BMI, y=iCL), method='lm', se=FALSE, color='turquoise3') +
    scale_color_manual(name = "Group", values = c("T2DM" = "tomato", "normal" = "turquoise")) +
    labs(title="Individual Clearance against BMI", x="BMI (kg/m^2)", y="CL (L/hr)") +
    theme_bw()

pVc <- ggplot(data=data) + 
    geom_point(aes(x=BMI_T2DM, y=iVc_T2DM, color="T2DM"), alpha=0.5) +
    geom_smooth(aes(x=BMI_T2DM, y=iVc_T2DM), method='lm', se=FALSE, color='tomato3') +
    geom_point(aes(x=BMI, y=iVc, color="normal"), alpha=0.5) + 
    geom_smooth(aes(x=BMI, y=iVc), method='lm', se=FALSE, color='turquoise3') +
    scale_color_manual(name = "Group", values = c("T2DM" = "tomato", "normal" = "turquoise")) +
    labs(title="Individual Vc against BMI", x="BMI (kg/m^2)", y="Vc (L)") +
    theme_bw()

pVp <- ggplot(data=data) + 
    geom_point(aes(x=BMI_T2DM, y=iVp_T2DM, color="T2DM"), alpha=0.5) +
    geom_smooth(aes(x=BMI_T2DM, y=iVp_T2DM), method='lm', se=FALSE, color='tomato3') +
    geom_point(aes(x=BMI, y=iVp, color="normal"), alpha=0.5) + 
    geom_smooth(aes(x=BMI, y=iVp), method='lm', se=FALSE, color='turquoise3') +
    scale_color_manual(name = "Group", values = c("T2DM" = "tomato", "normal" = "turquoise")) +
    labs(title="Individual Vp against BMI", x="BMI (kg/m^2)", y="Vp (L)") +
    theme_bw()


grid.arrange(pCL, pVc, pVp, nrow=3)
