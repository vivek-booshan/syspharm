setwd(Sys.getenv("PWD"))
library(ggplot2)

TapData = read.csv(
  'TapData_mat.txt',
  header=FALSE,
  col.names=c('wt', 'V', 'CL', 'ka')
)
TapData$kca = TapData$CL / TapData$V

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
TapData$simkca = TapData$simCL / TapData$simV

headers = c('wt', 'V', 'CL', 'ka', 'kca', 'simV', 'simCL', 'simka', 'simkca')

for (i in 2:5) {
  p = ggplot() + geom_point(data=TapData, aes(x=wt, y=!!sym(headers[i]), color='pink')) +
    geom_point(data=TapData, aes(x=wt, y=!!sym(headers[i + 4]), color='blue'))
  print(p)
}

p = ggplot(data=TapData)
for (i in 2:9) {
  p = p + geom_violin(aes(x=wt, y=!!sym(headers[i])),
                      trim=FALSE, fill='gray')
}
print(p)
for (i in 2:5) {
  p = ggplot() + geom_point(data=TapData, aes(x=!!sym(headers[i]), y=!!sym(headers[i+4]), color='pink'))
  print(p)
}