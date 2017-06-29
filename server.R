library(shiny)
library(ggplot2)

shinyServer(function(input, output,session) {
    
  #change x and y axis options when dataset changes
  observe({
      updateSelectInput(session,"x",choices=names(dataset()))
      updateSelectInput(session,"y",choices=names(dataset()))
  })
    
  #change spline point slider when x-axis changes
  observe({
      isolate(ds <- dataset())
      r <- range(ds[,input$x])
      updateSliderInput(session,"spline",min=r[1]+.1,max=r[2]-.1,value=mean(r))
  })
    
  #change linear model when x and y axis change
  model1 <- reactive({
      isolate(ds <- dataset())
      lm(ds[,input$y]~ds[,input$x])
  })
  
  #change linear model with spline point when x and y axis change
  model2 <- reactive({
      isolate(ds <- dataset())
      spline  <- ifelse(ds[,input$x] - input$spline > 0, ds[,input$x] - input$spline, 0)
      lm(y~x+spline,data.frame(y=ds[,input$y],x=ds[,input$x],spline=spline))
  })
  
  #change dataset when new dataset is selected
  dataset <- reactive({
      do.call(assign,list("dataset",as.name(input$data)))
      dataset
  })
  
  #plot the data and models when x and y axis change
  output$plot <- renderPlot({
      isolate(ds <- dataset())
      plot(ds[,input$x],ds[,input$y],xlab=input$x,ylab=input$y)
      if(input$model1){
          abline(model1(),col="blue",lwd=2)
      }
      if(input$model2){
          r <- range(ds[,input$x])
          s <- seq(r[1],r[2],length.out=100)
          newdata=data.frame(x=s,spline=ifelse(s - input$spline > 0, s - input$spline,0))
          modlines <- predict(model2(),newdata)
          lines(s,modlines,col="red",lwd=2)
      }

  })
  
  #disply the root mean squared errors of the two models
  output$rmse1 <- renderText({
      sqrt(mean(model1()$residuals^2))
  })
  output$rmse2 <- renderText({
      sqrt(mean(model2()$residuals^2))
  })
  
})
