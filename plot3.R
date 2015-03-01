# National Emissions Inventory, 1999, 2002, 2005, and 2008

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
    # which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
    # Which have seen increases in emissions from 1999–2008? 
    # Use the ggplot2 plotting system to make a plot answer this question.

# Interpretation: plot the difference between the first and last data points in the time series 
    # to make clear the direction of emissions

# using dplyr to manipulate the data set
library('dplyr')
library('ggplot2')
library('reshape2')

# Load the data sets; check first if they are already loaded to avoid expensive reloads
if (!exists('NEI')) {
    NEI <- readRDS("summarySCC_PM25.rds")    
}

# Filter down to the Baltimore fips code, and just the years 1999 and 2008
summarized.data <- 
    NEI %>% 
    filter(fips == '24510') %>%
    filter(year == 1999 | year == 2008) %>%
    select(Emissions, type, year) %>%
    group_by(year, type) %>% # group by year and type; then sum emissions
    summarise_each(funs(sum)) %>% 
    dcast(type ~ year) # reshape data, putting 1999 and 2008 as columns with type in the rows

# Rename columns to avoid numeric column names
names(summarized.data) <- c('Type', 'Y1999', 'Y2008')

# Calculate the difference in emissions between 2008 and 1999
summarized.data$diff <- summarized.data$Y2008 - summarized.data$Y1999 

# Create a bar plot of the difference in emissions
p <- ggplot(data=summarized.data, aes(x=Type, y=diff, color=Type, fill=Type, width=0.1)) + 
    geom_bar(stat='identity') + 
    ggtitle("Baltimore Emissions - 1999 to 2008\nPoint emissions up slightly. Other emission types down") + 
    xlab('Data source: Environmental Protection Agency (EPA)') + 
    ylab('Emissions (in tons)')
print(p)
# Save plot to disk
ggsave(file='./plot3.png')
