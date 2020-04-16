library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Shiny Regression"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("correlation",
                        "Correlation:",
                        min = .1,
                        max = .9,
                        value = .5,
            			step = 0.01,
            			animate = TRUE),
            checkboxInput('showOptimalRegression',
            			  'Show optional regression',
            			  value = TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
        	tabsetPanel(
        		tabPanel('Regression',
        				 plotOutput("regressionPlot")		
        		),
        		tabPanel('Sum of Squares',
        				 plotOutput('sosPlot')
        		)
        	)
            
        )
    )
))
