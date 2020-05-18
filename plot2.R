library(reshape2)

pm <- readRDS("summarySCC_PM25.rds")

bm <- subset(pm, pm$fips == "24510")

melted <- melt(bm, id.vars = "year", measure.vars = "Emissions")
total <- dcast(melted, year ~ variable, sum, na.rm = TRUE)

png("plot2.png")
plot(total$year, total$Emissions,
     type = "b",
     main = "Total Measured Emissions, Baltimore City",
     xlab = "year",
     xaxt = "n",
     ylab = "PM2.5 [tons]"
)
axis(1, at = total$year)

dev.off()

