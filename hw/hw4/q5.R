#### DEPENDENCIES
setwd(Sys.getenv("PWD"))
library(ggplot2)
if (requireNamespace("tidyr")) {
    pivot_longer <- tidyr::pivot_longer
} else {
    stop("tidyr not installed")
}

#### INITIALIZED DATA
headerIIV = c('wt', 'V_IIV', 'CL_IIV', 'ka_IIV', 'kCL_IIV')
headerwoIIV = c('wt', 'V', 'CL', 'ka', 'kCL')
simData_wIIV = read.csv("wIIV.txt", col.names=headerIIV)
simData_woIIV = read.csv("woIIV.txt", col.names=headerwoIIV)

#### PLOT
#### q5a
for (i in 2:5) {
    p = ggplot() + 
        geom_point(data=simData_wIIV,aes(x=wt, y=!!sym(headerIIV[i]), color='measured')) +
        geom_point(data=simData_woIIV,aes(x=wt, y=!!sym(headerwoIIV[i]), color='simulated')) +
        labs(y=headerwoIIV[i]) +
        theme_bw()
    ggsave(paste0("q5a_", headerwoIIV[i], ".png"), bg='white')
    print(p)
}
#### q5b
longsimData_wIIV = pivot_longer(simData_wIIV, cols=-wt, names_to="parameter", values_to="values")
longsimData_woIIV = pivot_longer(simData_woIIV, cols=-wt, names_to="parameter", values_to="values")
p = ggplot() + 
    geom_violin(data=longsimData_wIIV, aes(x=parameter, y=values), trim=FALSE) +
    scale_y_log10() +
    geom_violin(data=longsimData_woIIV, aes(x=parameter, y=values), trim=FALSE) +
    scale_y_log10()
ggsave("q5b_violin.png", bg='white')
print(p)
#### q5c
merged = merge(simData_wIIV, simData_woIIV, by="wt")
for (i in 2:5) {
    p = ggplot() + 
        geom_point(
            data=merged, 
            aes(
                x=!!sym(headerIIV[i]), y=!!sym(headerwoIIV[i]), 
                color='pink')
        ) +
        labs(
            title=paste(
                "Comparison between", headerwoIIV[i], 
                "with IIV calculated", headerwoIIV[i]), 
            x=paste("IIV", headerwoIIV[i]),
            y=paste("non-IIV", headerwoIIV[i])
        ) +
    theme_bw()
    ggsave(paste0("q5c_", headerwoIIV[i], ".png"), bg='white')
    print(p)
}