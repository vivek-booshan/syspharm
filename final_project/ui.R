library(plotly)

fluidPage(
    tags$head(
        tags$style(HTML(
            "
              .sidebar-scroll {
                position: fixed;
                top: 10;
                height: 430px;
                overflow-y: auto; /* Enable vertical scrolling */
                width: 250px; /* Adjust width as needed */
                padding: 20px; /* Adjust padding as needed */
                background-color: #f9f9f9; /* Background color of the sidebar */
                border-right: 1px solid #ddd; /* Add border for better separation */
                z-index: 1000; /* Ensure the sidebar stays on top */
              }
             "
        ))
    ),
    titlePanel("Tirzepatide PK Model"),
    sidebarPanel(
        class =  "sidebar-scroll",
        h5("Below are the 5 parameters involved in the tirzepatide PK model.
           For each parameter, the Median and the Bounds of the 95% CI are shown."),
        selectInput('Vp', "Select Vp (L)", 
            c(
                "LB : 3.48" = "3.480000e+00",
                "Median : 3.91" = "3.910000e+00",
                "UB : 4.17" = "4.170000e+00"
            ),
            selected = "Median : 3.91"
        ),
        selectInput("Vc", "Select Vc (L)",
            c(
                "LB     : 2.07" = "2.070000e+00",
                "Median : 2.48" = "2.480000e+00",
                "UB     : 2.98" = "2.980000e+00"
            ),
            selected="Median : 2.48"
        ),
        selectInput("ka", "Select ka (1/hr)",
            c(
                "LB     : 0.0287" = "2.870000e-02",
                "Median : 0.0363" = "3.260000e-02",
                "UB     : 0.0448" = "4.480000e-02"
            ),
            selected = "Median : 0.0363"
        ),
        selectInput("CL", "Select CL (L/hr)",
            c(
                "LB     : 0.0311" = "3.110000e-02",
                "Median : 0.0326" = "3.260000e-02",
                "UB     : 0.0341" = "3.410000e-02"
            ),
            selected = "Median : 0.0326"
        ),
        selectInput("Q", "Select Q (L/hr)", 
            c(
                "LB     : 0.101" = "1.010000e-01",
                "Median : 0.125" = "1.250000e-01",
                "UB     : 0.144" = "1.440000e-01"
            ),
            selected = "Median : 0.125"
        ),
    ),
    mainPanel(
        fluidRow(
            verticalLayout(
                plotlyOutput("plot1"),
                plotlyOutput("plot2"),
                plotlyOutput("plot3")
            )
        )
    )
)