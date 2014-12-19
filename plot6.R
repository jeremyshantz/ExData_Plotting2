# National Emissions Inventory, 1999, 2002, 2005, and 2008

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
    # sources in Los Angeles County, California (fips == "06037"). 
    # Which city has seen greater changes over time in motor vehicle emissions?

# Interpretation of "greater changes over time"
    # This plot illustates the percentage change in emissions between observation periods.
    # The larger the percentage, the greater change there has been over time.
    # The larger distance between the Baltimore data points compared to the relatively flat
    #   line for Los Angeles illustrate that Baltimore has had greater changes over time 
    # Note that since we are measuring the difference between observations, we end up with
    #   three data points on the plot. The 1999 data is used to calculate the 2002 figure.

# Using dplyr to manipulate the data set
library('dplyr')

# Load the data sets; check first if they are already loaded to avoid expensive reloads
    # These files must be in the working directory
if (!exists('NEI')) {
    NEI <- readRDS("summarySCC_PM25.rds")    
}

if (!exists('SCC')) {
    SCC <- readRDS("Source_Classification_Code.rds")    
}

# Locate the SCC codes for motor vehicle, defined as all categories where EI.Sector contains 'Vehicle'
codes <- filter(SCC, grepl("Vehicle", EI.Sector)) %>%  select(SCC)
codes <- as.character(codes[[1]]) # cast as character vector

# Filter NEI to those rows matching the vehicle SCC codes and the Baltimore FIPS code
#   Select only emissions and year; group by year; then sum emissions
baltimore.vehicles <- NEI %>% 
    filter(fips == '24510', SCC %in% codes) %>%
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise_each(funs(sum))

# Filter for the LA set
losangeles.vehicles <- NEI %>% 
    filter(fips == '06037', SCC %in% codes) %>%
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise_each(funs(sum))

# Calculate the % change across periods using the lag function.
percentchange.la <- ( losangeles.vehicles[,2] - lag(losangeles.vehicles[,2][[1]], 1)) / lag(losangeles.vehicles[,2][[1]], 1) * 100
percentchange.baltimore <- ( baltimore.vehicles[,2] - lag(baltimore.vehicles[,2][[1]], 1)) / lag(baltimore.vehicles[,2][[1]], 1) * 100

# Create a new data.frame for percent change
percentchange <- data.frame(c("2002","2005","2008"), percentchange.la[2:nrow(percentchange.la),])
percentchange <- mutate(percentchange, Baltimore = percentchange.baltimore[2:nrow(percentchange.baltimore),])
percentchange[,1] <- as.character(percentchange[,1])
names(percentchange) <- c('Year', 'Los Angeles', 'Baltimore')

# Make the basic plot
png(filename="./plot6.png", width=480, height=480)
plot(percentchange[,1], percentchange[,2], type='n', ylab=NA, xlab=NA, ylim=c(-70,30), xaxt = "n", yaxt = "n")

# Add city lines and grid
points(percentchange[,1], percentchange[,3], type='l', col=colors()[53], lwd = 3)
points(percentchange[,1], percentchange[,2], type='l', col=colors()[555], lwd = 3 )
grid()

# Y axis and label
axis(side = 2, line= 0, cex.axis=.6, las=1)
mtext(side=2, '% Change', line=2.7, font=1.6, cex=1.1)
mtext(side=2, "Year over year", line=1.8, font=1, cex=.7)

# X axis and label
axis(side = 1, line = -2, cex.axis=.7, at = c(2002, 2005, 2008), lwd=0.5, lty=1 )
mtext(side = 1, line = 1, font = 1, cex = .78, adj = .7,
      'Note: The figure given for 2002 is the percentage change in emissions from 1999. The 1999 data is in this plot.')
mtext(side = 1, line= 2.4, font=1, cex=.6, adj = -.12, 
      "Data source: Environmental Protection Agency (EPA)")

# Main title
mtext(side=3, line=2, font=1.6, cex=1.1,
      'Baltimore vs Los Angeles Vehicle Emissions - Yearly % Change')
mtext(side=3, line=.9, font=1.6, cex=.8, col='black', 
      'Baltimore emissions have seen greater changes from 1999 to 2008, both up and down')

# Add legend
legend("topright", pch = '_', col = c(colors()[555], colors()[53]), legend = c("Los Angeles", "Baltimore"), lwd = 3)

dev.off()