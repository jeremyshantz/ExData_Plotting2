
# National Emissions Inventory, 1999, 2002, 2005, and 2008

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
    # Using the base plotting system, make a plot showing the total PM2.5 emission 
    # from all sources for each of the years 1999, 2002, 2005, and 2008.

# Using dplyr to manipulate the data set
library('dplyr')
setwd('~/R/Exploratory_Data_Analysis/project2/')

# Load the data set; check first if it is already loaded to avoid expensive reloads
if (!exists('NEI')) {
    NEI <- readRDS("summarySCC_PM25.rds")    
}

# Select only emissions and year; group by year; then sum emissions
summarized.data <- 
    NEI %>% 
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise_each(funs(sum)) %>%
    mutate(Emissions = Emissions / 1000 ) # reads betters in the plot

# Make the basic plot
#png(filename="./plot1.png", width=480, height=480)
plot(x = summarized.data, type='l', ylab='', xlab='', xaxt = "n", yaxt = "n", lwd = 3)

# Main title
mtext(side=3, line=2, font=1.6, cex=1.2, 'US fine particulate matter ('~PM[2.5]~') emissions 1999-2008')
mtext(side=3, line=.8, font=1.6, cex=1.0, col='blue', 'Emissions decreased in the United States')

# Y axis
axis(side=2, lwd=0.5, lty=1 )
mtext(side = 2, "Emissions (in 1000s of tons)", line= 2.4, font=0.8, cex=0.9)

# X axis
axis(side=1, at=c(1999, 2002, 2005, 2008), lwd=0.5, lty=1 )
mtext(side = 1, "Data source: Environmental Protection Agency (EPA)", line= 2.4, font=1, cex=.7, adj=-.25)

# Add trend line and legend to make the decrease more apparent
abline(lm(Emissions ~ year, data=summarized.data), col='red', lwd = 3)
legend("topright", pch = '_', col = c("black","red"), legend = c("Emissions","Trend"))
grid()

#dev.off()