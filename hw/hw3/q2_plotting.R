setwd(Sys.getenv("PWD"))

library(RColorBrewer)
library(tidyr)
library(ggplot2)

sensitivities = c('14hr AUC', '1hr AUC', 'Sum of Squares')
colnames = rep(c(paste('subject', 1:5)))
parameters = rep(c('D1', 'D2', 'kcl', 'Vd', 'ka'))
questions = c('a', 'b', 'c')
# make row 1 as col names
header.true <- function(df) {
  names(df) <- as.character(unlist(df[1, ]))
  df[-1, ]
}

for (i in 1:3) {
  sens_mat = as.data.frame(read.csv(
    paste0("q2", questions[i], ".txt"),
    header=FALSE
  ))
  sens_mat = rbind(colnames, sens_mat)
  sens_mat = header.true(sens_mat)
  sens_mat = cbind(parameters, sens_mat)
  sens_mat = pivot_longer(
    sens_mat, 
    !parameters, 
    names_to='subject', 
    values_to='sens'
  )
  sens_mat$parameters = factor(sens_mat$parameters, levels=rev(parameters))
  print(sens_mat)
  sens_mat$sens = as.numeric(sens_mat$sens)
  p = ggplot(data=sens_mat, aes(x=subject, y=parameters, fill=sens)) + 
    labs(title=paste('Local Sensitivity for', sensitivities[i])) +
    theme_minimal() + geom_tile() +
    scale_fill_distiller(name='Sensitivity', palette='Spectral')
  print(p)

}

