setwd(Sys.getenv("PWD"))
library(ggplot2)
if (requireNamespace("tidyr")) {
    pivot_longer <- tidyr::pivot_longer
} else {
    stop("tidyr not installed")
}

fixed_IIV = read.csv(
    "fixed_IIV.txt", 
    header=FALSE, 
    col.names = c('wt', 'AUC_fixed_IIV')
)
fixed_woIIV = read.csv(
    "fixed_woIIV.txt",
    header=FALSE,
    col.names = c('wt', 'AUC_fixed')
)

weightbased_IIV = read.csv(
    "weight_IIV.txt",
    header=FALSE,
    col.names = c('wt', 'AUC_weightbased_IIV')
)

weightbased_woIIV = read.csv(
    "weight_woIIV.txt",
    header=FALSE,
    col.names = c('wt', 'AUC_weightbased')
)

fixed_merge = merge(fixed_IIV, fixed_woIIV, by='wt')
weight_merge = merge(weightbased_IIV, weightbased_woIIV, by='wt')
total_merge = merge(fixed_merge, weight_merge, by='wt')
total_merge_pivot = pivot_longer(total_merge, cols=-wt, names_to = "method", values_to = "AUC")
p = ggplot(data=total_merge_pivot) + geom_violin(aes(x=method, y=AUC)) + 
    scale_y_log10() + theme_bw() 
print(p)