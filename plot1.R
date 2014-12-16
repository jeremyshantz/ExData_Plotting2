
# National Emissions Inventory, 1999, 2002, 2005, and 2008

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
    # Using the base plotting system, make a plot showing the total PM2.5 emission 
    # from all sources for each of the years 1999, 2002, 2005, and 2008.

# Using dplyr to manipulate the data set
library('dplyr')

# Load the data set; check first if it is already loaded to avoid expensive reloads
if (!exists('NEI')) {
    NEI <- readRDS("summarySCC_PM25.rds")    
}

# Select only emissions and year, group by year, then sum emissions
summarized.data <- 
    NEI %>% 
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise_each(funs(sum))
    
# Make the basic plot
png(filename="./plot1.png", width=480, height=480)
plot(x = summarized.data, type='l', ylab='Emissions (tons)', xlab='Year')

# Annotate the plot
title(main=bquote(atop('Fine particulate matter ('~PM[2.5]~') emissions', 'decreased in the United States, 1999-2008' )))
# par("col.sub" = "black")
# par(mar =  c(5,4,4,2)) 
# title(sub=bquote(atop('Data source: Environmental Protection Agency (EPA)')))

dev.off()
