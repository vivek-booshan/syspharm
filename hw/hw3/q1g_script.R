library(ggplot2)

questions = c('a', 'b', 'c', 'e', 'f')
M
for (j in 1:5) {
  p <- ggplot() + labs(title=paste0('1', questions[j]))
  for (i in 1:5) {
    simulation_data <- read.csv(
      paste0("subject", i, "table", questions[j], ".txt"), 
      col.names = c('t', 'y'),
      header=FALSE
    )
    real_data <- read.csv(
      paste0("subject", i, "_experimental.txt"),
      col.names = c('t', 'y'),
      header=FALSE
    )
    print(real_data)
    real_data$t = real_data$t + 1
    # print(real_data)
    p <- p + geom_point(data=real_data, aes(x=t, y=y), color=i)
    p <- p + geom_line(data=simulation_data, aes(x=t, y=y), color=i)
  }
  print(p)
}