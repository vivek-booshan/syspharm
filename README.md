# Final Project

## Model
The pharmacokinetic and pharmacodynamic model for tirzepatide can be found in the Model.m file.
Please see documentation within the file for more details on the algorithm and options available.
Additionally, in matlab, `help Model` will also provide a quick list of functions from which further documentation can be revealed using
`help [insert function]`.

Currently, any other *.m or *.R scripts are simply class scripts for plotting related to the final project in EN.540.630

## [PK Shiny App](https://vivek-booshan.shinyapps.io/final_project/)
- data/
- server.R
- ui.R

## [PD Shiny App](https://vivek-booshan.shinyapps.io/shiny_pd/)
- shiny_pd/
- shiny_pd/server.R
- ui.R

  
### TODO
- migrate to new repository
- restructure directory and naming
- need to do sensitivity analysis
- need to fix weight loss mechanic by removing placebo for 0 mg dosing. 
- generate plots comparing FM and LBM compositions instead of BMI and bodyweight
