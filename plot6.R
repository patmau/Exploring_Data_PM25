library(reshape2)
library(ggplot2)

pm <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

## get SCC (Source Classification Code) for motor vehicles
## assume these correspond to SCCs where the "EI.Sector" column
## is "Mobile - On-Road ... Vehicles"
motVehicle <- grep("^Mobile - On-Road.*Vehicles$", scc$EI.Sector)
motCode <- scc[motVehicle, "SCC"]

# subset for motor vehicles in Baltimore and L.A.
mot <- subset(pm, pm$SCC %in% motCode & (pm$fips == "24510" | pm$fips == "06037"))

# add a city column and replace fips by city name
mot$city <- mot$fips
mot$city <- gsub("06037", "Los Angeles", mot$city, fixed = TRUE)
mot$city <- gsub("24510", "Baltimore", mot$city, fixed = TRUE)


melted <- melt(mot, id.vars = c("year", "city"), measure.vars = "Emissions")
total <- dcast(melted, year + city ~ variable, sum, na.rm = TRUE)

png("plot6.png")
years = c(1999, 2002, 2005, 2008)
pmplot <- ggplot(total, aes(year, Emissions, colour = city)) +
    geom_line() +
    geom_point() +
    labs(x = "year", y = "PM2.5 [tons]",
         title = "Motor Vehicle Emission, Baltimore vs. Los Angeles") +
    scale_x_continuous(breaks = years, labels = as.character(years))

print(pmplot)
dev.off()

