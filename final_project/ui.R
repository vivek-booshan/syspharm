fluidPage(
    #tags$head
    titlePanel("Tirzepatide PK Model"),
    sidebarPanel(
        selectInput('Vp', "Select Vp (L)", 
            c(
                "3.48" = "3.480000e+00",
                "3.91" = "3.910000e+00",
                "4.17" = "4.170000e+00"
            ),
            selected = "3.48"
        ),
        selectInput("Vc", "Select Vc (L)",
            c(
                "2.07" = "2.070000e+00",
                "2.48" = "2.480000e+00",
                "2.98" = "2.980000e+00"
            ),
            selected="2.48"
        ),
        selectInput("ka", "Select ka (1/hr)",
            c(
                "0.0287" = "2.870000e-02",
                "0.0363" = "3.260000e-02",
                "0.0448" = "4.480000e-02"
            ),
            selected = "0.0363"
        ),
        selectInput("CL", "Select CL (L/hr)",
            c(
                "0.0311" = "3.110000e-02",
                "0.0326" = "3.260000e-02",
                "0.0341" = "3.410000e-02"
            )
        ),
        selectInput("Q", "Select Q (L/hr)", 
            c(
                "0.101" = "1.010000e-01",
                "0.126" = "1.260000e-01",
                "0.144" = "1.440000e-01"
            )
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