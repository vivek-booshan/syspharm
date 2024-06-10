setwd(Sys.getenv("PWD"))
library(ggplot2)
library(gridExtra)
library(grid)
data <- read.csv(
    "allometry_data.csv",
    header=FALSE,
    col.names=c("BMI_T2DM", "iCL_T2DM", "iVc_T2DM", "iVp_T2DM", "BMI", "iCL", "iVc", "iVp")
)

pCL <- ggplot(data=data) + 
    geom_point(aes(x=BMI_T2DM, y=iCL_T2DM, color="T2DM"), alpha=0.5) +
    geom_smooth(aes(x=BMI_T2DM, y=iCL_T2DM), method='lm', se=FALSE, color='tomato3') +
    geom_point(aes(x=BMI, y=iCL, color="non-T2DM"), alpha=0.5) + 
    geom_smooth(aes(x=BMI, y=iCL), method='lm', se=FALSE, color='turquoise3') +
    scale_color_manual(name = "Group", values = c("T2DM" = "tomato", "non-T2DM" = "turquoise")) +
    labs(x="", y="CL (L/hr)", tag="a") +
    theme_bw()

pVc <- ggplot(data=data) + 
    geom_point(aes(x=BMI_T2DM, y=iVc_T2DM, color="T2DM"), alpha=0.5) +
    geom_smooth(aes(x=BMI_T2DM, y=iVc_T2DM), method='lm', se=FALSE, color='tomato3') +
    geom_point(aes(x=BMI, y=iVc, color="non-T2DM"), alpha=0.5) + 
    geom_smooth(aes(x=BMI, y=iVc), method='lm', se=FALSE, color='turquoise3') +
    scale_color_manual(name = "Group", values = c("T2DM" = "tomato", "non-T2DM" = "turquoise")) +
    labs(x="", y="Vc (L)", tag="b") +
    theme_bw()

pVp <- ggplot(data=data) + 
    geom_point(aes(x=BMI_T2DM, y=iVp_T2DM, color="T2DM"), alpha=0.5) +
    geom_smooth(aes(x=BMI_T2DM, y=iVp_T2DM), method='lm', se=FALSE, color='tomato3') +
    geom_point(aes(x=BMI, y=iVp, color="non-T2DM"), alpha=0.5) + 
    geom_smooth(aes(x=BMI, y=iVp), method='lm', se=FALSE, color='turquoise3') +
    scale_color_manual(name = "Group", values = c("T2DM" = "tomato", "non-T2DM" = "turquoise")) +
    labs(x="BMI (kg/m^2)", y="Vp (L)", tag="c") +
    theme_bw()


g <- arrangeGrob(pCL, pVc, pVp, nrow=3, 
             top = textGrob(
                "Fit of Allometric Parameters against BMI",
                gp=gpar(fontsize=20,font=3)))

ggsave(file="BMI_CL_Vd.png", g, bg="white", dpi=600, height=8, width=8)
