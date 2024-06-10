setwd(Sys.getenv("PWD"))

library(RColorBrewer)
library(tidyr)
library(ggplot2)

volume = c('vc', 'vp')
colnames = rep(c(paste('subject', 1:5)))
tag = c('a', 'b', 'c')
vd = c("Central", "Peripheral")
linspace <- function(a, b) {
    # a is array, b is num_interval
    seq(from=min(a), to=max(a), by=(max(a) - min(a))/b)
}

vc = linspace(2:3, 20)
clearances = linspace(c(0.03,0.035), 20)
vp = linspace(c(3.45, 4.2), 20)

header.true <- function(df) {
    # move row1 to col names
    names(df) <- as.character(unlist(df[1, ]))
    df[-1, ]
}

for (i in 1:2) {
    sens_mat = as.data.frame(read.csv(
        paste0(volume[i], "_cl_1wk.txt"),
        header=FALSE
    ))
    sens_mat = rbind(get(volume[i]), sens_mat)
    sens_mat = header.true(sens_mat)
    sens_mat = cbind(clearances, sens_mat)
    sens_mat = pivot_longer(
        sens_mat, 
        !clearances, 
        names_to='weights', 
        values_to='sens'
    )
    # sens_mat$clearances = factor(sens_mat$parameters, levels=rev(parameters))
    print(sens_mat)
    sens_mat$sens = as.numeric(sens_mat$sens)
    p = ggplot(data=sens_mat, aes(x=weights, y=clearances, fill=sens), cex.lab=2) + 
        labs(title=paste('Global Sensitivity of', vd[i], "Volume of Distribution"),
             x = paste(vd[i], "Volume of Distribution (L)"), y="Clearance (L/hr)",
             tag = tag[i]) +
        theme_minimal() + geom_tile() +
        theme(axis.title=element_text(size=15)) +
        theme(plot.title = element_text(size=15, hjust=0.5)) +
        scale_fill_distiller(name='AUC', palette='RdBu') +
        scale_x_discrete(breaks=seq(min(get(volume[i])), max(get(volume[i])), 0.15))
    print(p)
    ggsave(paste0("pk_sensitivity_", tag[i], ".png"), bg="white", dpi=600, height=6, width=8)
}

sens_mat = as.data.frame(read.csv(
    paste0("vc_vp_1wk.txt"),
    header=FALSE
))
sens_mat = rbind(vc, sens_mat)
sens_mat = header.true(sens_mat)
sens_mat = cbind(vp, sens_mat)
sens_mat = pivot_longer(
    sens_mat, 
    !vp, 
    names_to='weights', 
    values_to='sens'
)
# sens_mat$clearances = factor(sens_mat$parameters, levels=rev(parameters))
print(sens_mat)
sens_mat$sens = as.numeric(sens_mat$sens)
p = ggplot(data=sens_mat, aes(x=weights, y=vp, fill=sens)) + 
    labs(title=paste('Global Sensitivity of Central and Peripheral Volumes of Distribution'),
         x = paste("Central Volume of Distribution (L)"), y="Peripheral Volume of Distribution (L)",
         tag = "c") +
    theme_minimal() + geom_tile() +
    theme(axis.title=element_text(size=15)) +
    theme(plot.title = element_text(size=15, hjust=0.5)) +
    scale_fill_distiller(name='AUC', palette='RdBu') +
    scale_x_discrete(breaks=seq(min(vc), max(vc), 0.1))
ggsave(paste0("pk_sensitivity_c.png"), bg="white", dpi=600, height=6, width=8)
