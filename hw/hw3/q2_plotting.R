library(RColorBrewer)
coul = colorRampPalette(brewer.pal(8, "PiYG"))(25)
questions = c('a', 'b', 'c')
for (i in 1:3) {
  sens_mat = as.matrix(read.csv(
    paste0("q2", questions[i], ".txt"),
    col.names=c('1', '2', '3', '4', '5'),
    header=FALSE
  ))
  heatmap(sens_mat, Colv=NA, Rowv=NA, col=coul)
}