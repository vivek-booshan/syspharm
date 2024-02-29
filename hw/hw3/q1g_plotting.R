setwd(Sys.getenv("PWD"))
library(ggplot2)
library(scales)

hex = hue_pal()(5) #needed to match point with line
questions = c('a', 'b', 'c', 'e', 'f')
for (j in 1:5) {
  
  data = c() #init data frame
  p = ggplot() + 
    labs(title=paste0('Gut Concentration using q1', questions[j])) + 
    theme_bw() +
    scale_x_continuous(name = 'Time Since 10 am (hrs)', breaks=(seq(0, 14, 2))) +
    scale_y_continuous(name = 'Gut Concentration (mg/L)', breaks=(seq(0, 12, 1)))
  
  for (i in 1:5) {
    subject_data = read.csv(
      paste0('subject', i, 'table', questions[j], '.txt'),
      col.names=c('t', 'y'),
      header=FALSE
    )
    subject = rep(paste0('subject', i), times=nrow(subject_data))
    subject_data = cbind(subject, subject_data)
    
    data = rbind(data, subject_data)
    
    real_data <- read.csv(
      paste0("subject", i, "_experimental.txt"),
      col.names = c('t', 'y'),
      header=FALSE
    )
    real_data$t = real_data$t + 1 # offset by hour
    p = p + geom_point(data=real_data, aes(x=t, y=y), color=hex[i])
  }
  p = p + geom_line(data=data, aes(x=t, y=y, color=subject))
  print(p)
}