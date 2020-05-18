library(reshape2)

pm <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

## get SCC (Source Classification Code) for Coal Combustion
## assume these correspond to SCCs where the "EI.Sector" column
## starts with "Fuel Comb" and ends with "Coal"
coalBurn <- grep("^Fuel Comb.*Coal$", scc$EI.Sector)
coalBurnCodes <- scc[coalBurn, "SCC"]

coal <- subset(pm, pm$SCC %in% coalBurnCodes)

melted <- melt(coal, id.vars = "year", measure.vars = "Emissions")
total <- dcast(melted, year ~ variable, sum, na.rm = TRUE)

png("plot4.png")
plot(total$year, total$Emissions,
     type = "b",
     main = "Emissions from Coal Combustion",
     xlab = "year",
     xaxt = "n",
     ylab = "PM2.5 [tons]"
)
axis(1, at = total$year)

dev.off()

