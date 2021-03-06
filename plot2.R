
# National Emissions Inventory, 1999, 2002, 2005, and 2008

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
    # Use the base plotting system to make a plot answering this question.

# using dplyr to manipulate the data set
library('dplyr')
setwd('~/R/Exploratory_Data_Analysis/project2/')

# Load the data sets; check first if they are already loaded to avoid expensive reloads
if (!exists('NEI')) {
    NEI <- readRDS("summarySCC_PM25.rds")    
}

# Filter down to the Baltimore fips code,
#   Select only emissions and year; group by year; then sum emissions
summarized.data <- 
    NEI %>% 
    filter(fips == '24510') %>%
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise_each(funs(sum)) %>% 
    mutate(Emissions = Emissions / 1000 ) # change the scale so plot reads better

# Make the basic plot
#png(filename="./plot2.png", width=480, height=480)
plot(x = summarized.data, type='l', ylab=NA, xlab=NA, xaxt = "n", yaxt = "n", lwd = 3)

# Y axis and label
axis(side = 2, line= 0, cex.axis=.6, las=1)
mtext(side=2, 'Emissions', line=2.7, font=1.6, cex=1.3)
mtext(side=2, "(in 1000s of tons)", line=1.85, font=1, cex=.65)

# X axis and label
axis(side = 1, line = 0, cex.axis=.8, at = c(1999, 2002, 2005, 2008), lwd=0.5, lty=1 )
mtext(side = 1, NA, line = 1.8, font = 1.6, cex = 1.3)
mtext(side = 1, line= 2.4, font=1, cex=.7, adj=-.25, "Data source: Environmental Protection Agency (EPA)")

# Main title
mtext(side=3, line=2, font=1.6, cex=1.2, 'Baltimore emissions decreased')
mtext(side=3, line=.8, font=1.6, cex=.8, 'Fine particulate matter ('~PM[2.5]~'), 1999 to 2008')

# Add trend line and legend to make the decrease more apparent
abline(lm(Emissions ~ year, data=summarized.data), col='red', lwd = 3)
legend("topright", pch = '_', col = c("black","red"), legend = c("Emissions","Trend"))
grid()

#dev.off()
