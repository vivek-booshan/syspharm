#### DEPENDENCIES
setwd(Sys.getenv("PWD"))
library(ggplot2)
if (requireNamespace("tidyr")) {
    pivot_longer <- tidyr::pivot_longer
} else {
    stop("tidyr not installed")
}

#### PREPARE DATA
TapData = read.csv(
    'TapData_mat.txt',
    header=FALSE,
    col.names=c('wt', 'V', 'CL', 'ka')
)
TapData$kCL = TapData$CL / TapData$V

param_allo = read.csv(
    'allometry_parameters.txt',
    header=FALSE,
    col.names=c('COEFF', 'EXP')
)
sim_param = matrix(0, length(TapData$wt), 3)
for (i in 1:3) {
    sim_param[ , i] = param_allo[i, ]$COEFF * (TapData$wt / 45)^param_allo[i, ]$EXP
}

TapData$simV  = sim_param[, 1]
TapData$simCL = sim_param[, 2]
TapData$simka = sim_param[, 3]
TapData$simkCL = TapData$simCL / TapData$simV

headers = c('wt', 'V', 'CL', 'ka', 'kCL', 'simV', 'simCL', 'simka', 'simkCL')

#### PLOTS
for (i in 2:5) {
    p = ggplot() + 
        geom_point(data=TapData, aes(x=wt, y=!!sym(headers[i]), color='measured')) +
        geom_point(data=TapData, aes(x=wt, y=!!sym(headers[i + 4]), color='simulated')) +
        labs(y=headers[i]) +
        theme_bw()
    ggsave(paste0("q2a_", headers[i], ".png"), bg='white')
    print(p)
}

longTapData = pivot_longer(TapData, cols=-wt, names_to="parameter", values_to="value")
longTapData$parameter = as.factor(longTapData$parameter)
p = ggplot(data=longTapData) + 
    geom_violin(aes(x=parameter, y=value),trim=FALSE) +
    scale_y_log10() +
    theme_bw()
ggsave("q2b_violin.png", bg='white')
print(p)

for (i in 2:5) {
    p = ggplot() + 
        geom_point(
            data=TapData, 
            aes(x=!!sym(headers[i]), y=!!sym(headers[i+4]), 
                color='pink')) +
        labs(
            title=paste(
                "Comparison between", headers[i], 
                "with simulated", headers[i+4]), 
            x=paste("IIV", headers[i]),
            y=paste("non-IIV", headers[i])
        )
        ggsave(paste0("q2c_", headers[i], ".png"), bg='white')
    print(p)
}