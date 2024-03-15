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
units = c('kg', 'L', 'L/hr', 'L/hr', '1/hr')

#### PLOT
#### q5a
for (i in 2:5) {
    p = ggplot() + 
        geom_point(data=simData_wIIV,aes(x=wt, y=!!sym(headerIIV[i]), color='with IIV')) +
        geom_point(data=simData_woIIV,aes(x=wt, y=!!sym(headerwoIIV[i]), color='without IIV')) +
        labs(y=paste0(headerwoIIV[i], " (", units[i], ")"),
             x=paste0("weight (kgs)"),
             title=paste0("Overlay of IIV Calculated and Standard Allometric Parameters")) +
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
    scale_y_log10() + 
    labs(x="parameters", y="Arbitrary Log10 Units") +
    labs(title="Distribution of IIV and non-IIV Parameter Values") + 
    theme_bw()
ggsave("q5b_violin.png", bg='white')
print(p)
#### q5c
merged = merge(simData_wIIV, simData_woIIV, by="wt")
for (i in 2:5) {
    p = ggplot() + 
        geom_point(
            data=merged, 
            aes(
                x=!!sym(headerIIV[i]), y=!!sym(headerwoIIV[i]))
        ) +
        labs(
            title=paste(
                "Comparison between", headerwoIIV[i], 
                "with IIV calculated", headerwoIIV[i]), 
            x=paste("IIV", headerwoIIV[i], "(", units[i], ")"),
            y=paste("non-IIV", headerwoIIV[i], "(", units[i], ")")) +
        theme_bw()
    ggsave(paste0("q5c_", headerwoIIV[i], ".png"), bg='white')
    print(p)
}