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
IIV_merge = merge(fixed_IIV, weightbased_IIV, by='wt')
woIIV_merge = merge(fixed_woIIV, weightbased_woIIV, by='wt')

###### q6a #######
total_merge = merge(fixed_merge, weight_merge, by='wt')
total_merge_pivot = pivot_longer(total_merge, cols=-wt, names_to = "method", values_to = "AUC")
p = ggplot(data=total_merge_pivot) + geom_violin(aes(x=method, y=AUC)) + 
    scale_y_log10() + theme_bw() 
print(p)

###### q6b #######
colnames(fixed_merge) = c("wt", "with IIV", "without IIV")
colnames(weight_merge) = c("wt", "with IIV", "without IIV")
colnames(IIV_merge) = c("wt", "Fixed", "Weight Based")
colnames(woIIV_merge) = c("wt", "Fixed", "Weight Based")

pivot_fixed_merge = pivot_longer(fixed_merge, cols=-wt, names_to="Fixed Dosing", values_to="AUC")
pivot_weight_merge = pivot_longer(weight_merge, cols=-wt, names_to="Weight Based Dosing", values_to="AUC")
pivot_IIV_merge = pivot_longer(IIV_merge, cols=-wt, names_to="IIV Dosing", values_to="AUC")
pivot_woIIV_merge = pivot_longer(woIIV_merge, cols=-wt, names_to="non-IIV Dosing", values_to="AUC")

fixed_plot = ggplot(data = pivot_fixed_merge) + 
    geom_point(alpha=0.4, aes(x=wt, y=AUC, color=`Fixed Dosing`)) +
    labs(x="weight (kgs)", title="Fixed Dosing Regime with and without IIV")
weight_plot = ggplot(data=pivot_weight_merge) + 
    geom_point(alpha=0.4, aes(x=wt, y=AUC, color=`Weight Based Dosing`)) +
    labs(x='weight (kgs)', title="Weight Based Dosing Regime with and without IIV")
IIV_plot = ggplot(data=pivot_IIV_merge) + 
    geom_point(alpha=0.4, aes(x=wt, y=AUC, color=`IIV Dosing`)) +
    labs(x="weight (kgs)", title="Dosing Regime with IIV")
woIIV_plot = ggplot(data=pivot_woIIV_merge) + 
    geom_point(alpha=0.4, aes(x=wt, y=AUC, color=`non-IIV Dosing`)) + 
    labs(x="weight(kgs)", title="Dosing Regime without IIV")
ggsave('q6_fixed_plot.png', bg='white') #print(fixed_plot)
gsave('q6_weight_plot.png', bg='white') #print(weight_plot)
ggsave('q6_IIV_plot.png', bg='white') #print(IIV_plot)
ggsave('q6_woIIV_plot.png', bg='white') #print(woIIV_plot)