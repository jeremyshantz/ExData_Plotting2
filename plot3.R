# National Emissions Inventory, 1999, 2002, 2005, and 2008

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
    # which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
    # Which have seen increases in emissions from 1999–2008? 
    # Use the ggplot2 plotting system to make a plot answer this question.

# Interpretation: plot only the first and last data points in the time series 
    # to make clear the direction of emissions

# using dplyr to manipulate the data set
library('dplyr')
library('ggplot2')

# Load the data sets; check first if they are already loaded to avoid expensive reloads
if (!exists('NEI')) {
    NEI <- readRDS("summarySCC_PM25.rds")    
}

# Filter down to the Baltimore fips code,
#   Select type emissions and year: group by year: then sum emissions
summarized.data <- 
    NEI %>% 
    filter(fips == '24510') %>%
    select(Emissions, type, year) %>%
    group_by(year, type) %>%
    summarise_each(funs(sum)) %>%
    filter(year == 1999 | year == 2008)



p <- ggplot(data=summarized.data, aes(x=year, y=Emissions, group=type, color=direction, shape=type ))  + 
    geom_line() +
    geom_point() +
    theme(legend.position=c(.7, .4))  +
    ggtitle("Baltimore Emissions 1999 - 2008\nPoint emissions up slightly. Other emission types down")

xxx <- function(x) { 
    print(class(x)) 
}

ddd <- 
    NEI %>% 
    filter(fips == '24510') %>%
    select(Emissions, type, year) %>%
    group_by(year, type) %>%
    filter(year == 1999 | year == 2008) %>%
    summarise_each(funs(sum))

# percentchange.la <- ( losangeles.vehicles[,2] - lag(losangeles.vehicles[,2][[1]], 1)) / lag(losangeles.vehicles[,2][[1]], 1) * 100
    
diff <- data.frame(diff = c(1,4,2,-4), Type=c('a', 'b', 'c', 'd'))

p <- ggplot(data=diff, aes(x=Type, y=diff, color=Type, fill=Type, width=0.1)) + 
    geom_bar(stat='identity') + 
    ggtitle("Baltimore Emissions - Percent Change - 1999 to 2008\nPoint emissions up slightly. Other emission types down")

print(p)
#ggsave(file='./plot3.png')
