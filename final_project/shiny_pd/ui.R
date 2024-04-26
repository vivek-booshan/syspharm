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
    titlePanel("Tirzepatide PD Model"),
    sidebarPanel(
        class =  "sidebar-scroll",
        h5("Input the closest BMI to your BMI value, your sex, and diabetic status to see
           the expected % change in your bodyweight for a 10mg dosing protocol"),
        sliderInput("bmi", "Patient BMI", min = 15, max = 50, value = 30, step=0.1),
        selectInput("sex", "Sex", choices=c("Male" = "male", "Female" = "female"), selected = "Male"),
        selectInput("diabetes", "Type 2 Diabetes", choices=c("Yes" = "T2DM", "No" = "normal"), selected = "No")
    ),
    mainPanel(
        fluidRow(
            verticalLayout(
                plotlyOutput("plot")
            )
        )
    )
)