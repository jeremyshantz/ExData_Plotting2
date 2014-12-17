# National Emissions Inventory, 1999, 2002, 2005, and 2008

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
    # which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
    # Which have seen increases in emissions from 1999–2008? 
    # Use the ggplot2 plotting system to make a plot answer this question.

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
    summarise_each(funs(sum))

suppressWarnings(print(
    qplot(data=summarized.data, y=Emissions, x=year, facets=.~type, 
          ylab="x", xlab="",
          binwidth=.4
    )
    + ggtitle(paste('Emissions', '\n'))
))
