# National Emissions Inventory, 1999, 2002, 2005, and 2008

# Across the United States, how have emissions from coal combustion-related 
#   sources changed from 1999–2008?

# using dplyr to manipulate the data set
library('dplyr')

# Load the data sets; check first if they are already loaded to avoid expensive reloads
if (!exists('NEI')) {
    NEI <- readRDS("summarySCC_PM25.rds")    
}

if (!exists('SCC')) {
    SCC <- readRDS("Source_Classification_Code.rds")    
}

# Locate the SCC codes for coal combustion (all rows with 'Coal' in EI.Section contain the word combustion in one of the other columns)
coalSCC <- filter(SCC, grepl("Coal", EI.Sector)) %>%  select(SCC)
coalSCC <- as.character(coalSCC[[1]]) # cast as character vector

# Filter NEI to those rows matching the coal SCC codes
#   Select only emissions and year; group by year; then sum emissions
coal <- NEI %>% 
    filter(SCC %in% coalSCC) %>%
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise_each(funs(sum)) %>% 
    mutate(Emissions = Emissions / 1000 ) # change the scale so the y-axis reads better

# Make the basic plot
png(filename="./plot4.png", width=480, height=480)
plot(x = coal, type='l', ylab=NA, xlab=NA, xaxt = "n", yaxt = "n", lwd = 3)

# Y axis and label
axis(side = 2, line= 0, cex.axis=.6, las=1)
mtext(side=2, 'Emissions', line=2.7, font=1.6, cex=1.1)
mtext(side=2, "(in 1000s of tons)", line=1.8, font=1, cex=.7)

# X axis and label
axis(side = 1, line = 0, cex.axis=.8, at = c(1999, 2002, 2005, 2008), lwd=0.5, lty=1 )
mtext(side = 1, NA, line = 1.8, font = 1.6, cex = 1.3)
mtext(side = 1, line= 2.4, font=1, cex=.7, adj=-.25,
      "Data source: Environmental Protection Agency (EPA)")

# Main title
mtext(side=3, line=2, font=1.6, cex=1.2, 'US Coal Emissions - 1999 to 2008')
mtext(side=3, line=.9, font=1.6, cex=1, col='blue', 
      'Dramatic decline in 2008 after six years of steady output')

# Add trend line and legend
abline(lm(Emissions ~ year, data=coal), col='red', lwd = 3)
legend("topright", pch = '_', col = c("black","red"), legend = c("Emissions","Trend"))
grid()

dev.off()