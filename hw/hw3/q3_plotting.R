setwd(Sys.getenv("PWD"))

library(RColorBrewer)
library(tidyr)
library(ggplot2)

sensitivities = c('24hr AUC', '7 day AUC', 'C_trough')
colnames = rep(c(paste('subject', 1:5)))
questions = c('a', 'b', 'c')

linspace <- function(a, b) {
  # a is array, b is num_interval
  seq(from=min(a), to=max(a), by=(max(a) - min(a))/b)
}

weights = linspace(3:8, 20)
clearances = linspace(50:150, 20)

header.true <- function(df) {
  # move row1 to col names
  names(df) <- as.character(unlist(df[1, ]))
  df[-1, ]
}

for (i in 1:3) {
  sens_mat = as.data.frame(read.csv(
    paste0("q3", questions[i], ".txt"),
    header=FALSE
  ))
  sens_mat = rbind(weights, sens_mat)
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
  p = ggplot(data=sens_mat, aes(x=weights, y=clearances, fill=sens)) + 
    labs(title=paste('Global Sensitivity for', sensitivities[i]),
         x = "weights (lbs)", y="clearance half-life") +
    theme_minimal() + geom_tile() +
    scale_fill_distiller(name='Sensitivity', palette='Spectral')
  print(p)
  ggsave(paste0("q3", questions[i], ".png"), bg="white")
}