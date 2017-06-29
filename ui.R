library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Linear Regression With Spline Term"),
  
  sidebarLayout(
      
    sidebarPanel(
       selectInput("data","Data Set:",c("Old Faithful"="faithful","Trees"="trees","Mtcars"="mtcars","Swiss"="swiss")),
       selectInput("x","X Axis",choices=names(faithful)),
       selectInput("y","Y Axis",choices=names(faithful)),
       sliderInput("spline","Breakpoint",min = 1,max = 5,value = 1,step=.1),
       checkboxInput("model1","Linear Model",value=TRUE),
       checkboxInput("model2","Linear Model with Spline Term",value=TRUE)
    ),
    
    mainPanel(
       plotOutput("plot"),
       h3("RMSE Linear Model"),
       textOutput("rmse1"),
       h3("RMSE Linear Model with Spline Term"),
       textOutput("rmse2"),
       br(),
       h3("Documentation"),
       p("This application shows the effect of using a spline term in linear regression. Two models are constructed, a simple linear model, and one
         using a spline term, to provide a breakpoint. The position of the breakpoint can be chosen by the user."),
       p("Select a data set from the drop-down menu.
         The options are several standard data sets provided by R. Next, select the variables you want to display on the x and y axis. 
         The plot shows the data and variables you selected, and the two fitted models. You can use the slider to adjust the position of the breakpoint. 
         The root mean squared errors of the two models are displayed for comparison.
         You can also use the checkboxes to toggle the display of the models on the plot.")
       
    )
  )
))
