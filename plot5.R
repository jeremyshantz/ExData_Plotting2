# National Emissions Inventory, 1999, 2002, 2005, and 2008

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# using dplyr to manipulate the data set
library('dplyr')
setwd('~/R/Exploratory_Data_Analysis/project2/')
# Load the data sets; check first if they are already loaded to avoid expensive reloads
if (!exists('NEI')) {
    NEI <- readRDS("summarySCC_PM25.rds")    
}

if (!exists('SCC')) {
    SCC <- readRDS("Source_Classification_Code.rds")    
}

# Locate the SCC codes for motor vehicle
codes <- filter(SCC, grepl("Vehicle", EI.Sector)) %>%  select(SCC)
codes <- as.character(codes[[1]]) # cast as character vector

# Filter NEI to those rows matching the vehicle SCC codes and the Baltimore FIPS code
#   Select only emissions and year; group by year; then sum emissions
baltimore.vehicles <- NEI %>% 
    filter(fips == '24510', SCC %in% codes) %>%
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise_each(funs(sum))

# Make the basic plot
#png(filename="./plot5.png", width=480, height=480)
plot(x = baltimore.vehicles, type='l', ylab=NA, xlab=NA, xaxt = "n", yaxt = "n", lwd = 3)

# Y axis and label
axis(side = 2, line= 0, cex.axis=.6, las=1)
mtext(side=2, 'Emissions', line=2.7, font=1.6, cex=1.1)
mtext(side=2, "(in tons)", line=1.8, font=1, cex=.7)

# X axis and label
axis(side = 1, line = 0, cex.axis=.8, at = c(1999, 2002, 2005, 2008), lwd=0.5, lty=1 )
mtext(side = 1, NA, line = 1.8, font = 1.6, cex = 1.3)
mtext(side = 1, "Data source: Environmental Protection Agency (EPA)", line= 2.4, font=1, cex=.9, adj=-.25)

# Main title
mtext(side=3, line=2, font=1.6, cex=1.2,
      'Baltimore City Vehicle Emissions - 1999 to 2008')
mtext(side=3, line=.9, font=1.6, cex=.81, col='blue', 
      'Steep decrease from 1999 to 2002 then slower decline.')

# Add trend line and legend
abline(lm(Emissions ~ year, data = baltimore.vehicles), col='red', lwd = 3)
legend("topright", pch = '_', col = c("black","red"), legend = c("Emissions","Trend"))
grid()
#dev.off()