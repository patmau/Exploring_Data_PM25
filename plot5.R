library(reshape2)

pm <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

## get SCC (Source Classification Code) for motor vehicles
## assume these correspond to SCCs where the "EI.Sector" column
## is "Mobile - On-Road ... Vehicles"
motVehicle <- grep("^Mobile - On-Road.*Vehicles$", scc$EI.Sector)
motCode <- scc[motVehicle, "SCC"]

mot <- subset(pm, pm$SCC %in% motCode & pm$fips == "24510")

melted <- melt(mot, id.vars = "year", measure.vars = "Emissions")
total <- dcast(melted, year ~ variable, sum, na.rm = TRUE)

png("plot5.png")
plot(total$year, total$Emissions,
     type = "b",
     main = "Emissions from Motor Vehicles in Baltimore",
     xlab = "year",
     xaxt = "n",
     ylab = "PM2.5 [tons]"
)
axis(1, at = total$year)

dev.off()

