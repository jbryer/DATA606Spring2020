library(shiny)

closest <- function(xv,sv) {
	xv[which(abs(xv-sv)==min(abs(xv-sv)))] 
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
	results <- data.frame(r=seq(0.1, 0.9, by=.01), 
						  m=as.numeric(NA),
						  b=as.numeric(NA),
						  sumsquares=as.numeric(NA))
	for(i in 1:nrow(results)) {
		results[i,]$m <- results[i,]$r * (sd.y / sd.x)
		results[i,]$b <-  mean.y - results[i,]$m * mean.x
		predicted <- results[i,]$m * df$x + results[i,]$b
		residual <- df$y - predicted
		results[i,]$sumsquares <- sum(residual^2)
	}
	
    output$regressionPlot <- renderPlot({
    	mean.x <- mean(df$x)
    	sd.x <- sd(df$x)
    	mean.y <- mean(df$y)
    	sd.y <- sd(df$y)
    	
    	lm.out <- lm(y ~ x, data = df)
    	
    	cor.xy <- input$correlation

    	m <- cor.xy * (sd.y / sd.x) # Slope
    	b <- mean.y - m * mean.x # Intercept
    	
    	p <- ggplot(df, aes(x = x, y = y)) +
    		geom_vline(xintercept = mean.x, color = 'blue', linetype = 2) +
    		geom_hline(yintercept = mean.y, color = 'blue', linetype = 2) +
    		geom_point() +
    		geom_abline(slope = m, intercept = b, color = 'maroon')
    	
    	if(input$showOptimalRegression) {
	    	p <- p + geom_abline(slope = lm.out$coefficients[2],
	    							   intercept = lm.out$coefficients[1], 
	    							   color = 'lightgrey', size = 3, alpha = 0.5) 
    	}
    		
    	
    	return(p)
    })

    output$sosPlot <- renderPlot({
    	results.highlight <- results %>%
    		filter(r == closest(results$r, input$correlation))
    	
    	p <- ggplot(results, aes(x = r, y = sumsquares)) + 
    		geom_path() +
    		geom_point(alpha = 0.3) +
    		geom_point(data = results.highlight, color = 'maroon', size = 3) +
    		ylab('Sum of Squared Residuals') + xlab('Correlation')
    	
    	if(input$showOptimalRegression) {
    		p <- p + geom_vline(xintercept = cor(df$x, df$y))
    	}
    	
    	return(p)
    })
})
