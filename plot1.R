library(reshape2)

pm <- readRDS("summarySCC_PM25.rds")

years <- c(1999, 2002, 2005, 2008)

melted <- melt(pm, id.vars = "year", measure.vars = "Emissions")
total <- dcast(melted, year ~ variable, sum, na.rm = TRUE)

png("plot1.png")
plot(total$year, total$Emissions,
     type = "b",
     main = "Total Measured Emissions",
     xlab = "year",
     xaxt = "n",
     ylab = "PM2.5 [tons]"
     )
axis(1, at = total$year)

dev.off()

