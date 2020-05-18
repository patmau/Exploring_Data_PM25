library(reshape2)
library(ggplot2)

pm <- readRDS("summarySCC_PM25.rds")

bm <- subset(pm, pm$fips == "24510")

melted <- melt(bm, id.vars = c("year", "type"), measure.vars = "Emissions")
total <- dcast(melted, year + type ~ variable, sum, na.rm = TRUE)

png("plot3.png")
years = c(1999, 2002, 2005, 2008)
pmplot <- ggplot(total, aes(year, Emissions, colour = type)) +
    geom_line() +
    geom_point() +
    labs(x = "year", y = "PM2.5 [tons]",
         title = "Baltimore: Total Emissions by Source Type") +
    scale_x_continuous(breaks = years, labels = as.character(years))

print(pmplot)
dev.off()

