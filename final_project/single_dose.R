setwd(Sys.getenv("PWD"))
library(ggplot2)
library(gridExtra)
library(grid)
pivot_longer <- tidyr::pivot_longer
swfun <- function(x) {
    switch(x,
        '2.5',
        '5',
        '7.5',
        '10'
   )
}
data <- read.csv(
    "single_dose_data.csv", 
    header=FALSE, 
    col.names=c('t', 'central', 'peripheral', 'dose', 'cumulative', 'balance', 'ID'))
#data <- pivot_longer(data, cols=-ID)
data$ID <- sapply(data$ID, swfun)
data$ID <- factor(data$ID, levels=c('2.5', '5', '7.5', '10'))
p = ggplot(data, aes(x=t, color=ID))
p1 = p + geom_point(aes(y=central), show.legend=FALSE) + 
    labs(y="Concentration (mg/L)", x="time (wks)", tag="a") + 
    ylim(0, 1.2) +
    theme_bw() 
p2 = p + geom_point(aes(y=peripheral), show.legend=FALSE) + 
    ylim(0, 1.2) + 
    labs(y="", x="time (wks)", tag="b") +
    theme_bw()
p3 = p + geom_point(aes(x=t, y=dose, color=ID), show.legend=FALSE) + 
    labs(y="Concentration (mg/L)", x="time (wks)", tag="c") +
    theme_bw() + 
    xlim(0, 1)
p4 = p + geom_point(aes(x=t, y=cumulative, color=ID), show.legend=FALSE) + 
    labs(y="", x="time (wks)", tag="d") + 
    theme_bw()
p5 = p + geom_line(aes(x=t, y=balance, color=ID)) + 
    labs(color='Dose (mg/0.5mL)', y = "Mass Balance (mg)", x="time (wks)", tag="e") + 
    theme_bw()

g <- arrangeGrob(p1, p2, p3, p4, p5, 
             ncol = 2, layout_matrix=cbind(c(1, 3, 5), c(2, 4, 5)),
             top = textGrob(
                 "Single Dose Compartment Concentrations and Balance",
                 gp=gpar(fontsize=20,font=3))
             )
ggsave(file="single_dose.png", g, bg="white", dpi=600, height=8, width=8)
