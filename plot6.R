# Load external packages
library(ggplot2)

# Download source data and clean up temp files
f <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", f)
unzip(f)
unlink(f)
rm(f)

#Load data
NEI <- readRDS("summarySCC_PM25.rds")
unlink("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
unlink("Source_Classification_Code.rds")

# Focus on Baltimore
baltimoreAndLAEmissions <- NEI[NEI$fips == "24510" | NEI$fips == "06037", ]

# Focus on Vehicles
baltimoreAndLAVehicleEmissions <- merge(SCC[grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE), ], baltimoreAndLAEmissions, by = "SCC")

#Aggregate by year
baltimoreAndLAYearlyVehiclEmissions <- aggregate(baltimoreAndLAVehicleEmissions$Emissions, list(baltimoreAndLAVehicleEmissions$fips, baltimoreAndLAVehicleEmissions$year), sum)
names(baltimoreAndLAYearlyVehiclEmissions)[names(baltimoreAndLAYearlyVehiclEmissions)=="Group.1"] <- "fips"
names(baltimoreAndLAYearlyVehiclEmissions)[names(baltimoreAndLAYearlyVehiclEmissions)=="Group.2"] <- "Year"
names(baltimoreAndLAYearlyVehiclEmissions)[names(baltimoreAndLAYearlyVehiclEmissions)=="x"] <- "Emissions"

# Map fips to county
fips <- c("06037", "24510")
county <- c("Los Angeles", "Baltimore")
baltimoreAndLAYearlyVehiclEmissions <- merge(baltimoreAndLAYearlyVehiclEmissions, data.frame(fips, county), by = "fips")

# Clean up data
baltimoreAndLAYearlyVehiclEmissions$Emissions <- round(baltimoreAndLAYearlyVehiclEmissions$Emissions, 2)

# Plot data
png('plot6.png', width=480, height=480, bg = "transparent")
qplot(factor(Year), Emissions, data = baltimoreAndLAYearlyVehiclEmissions, fill = county) + geom_bar(stat = "identity") + xlab("Year") + ylab("Emissions (tons)") + ggtitle("PM2.5 Emissions from Vehicles in Baltimore City and Los Angeles") + geom_text(aes(label = Emissions, ymax = max(baltimoreAndLAYearlyVehiclEmissions$Emissions)*1.05), size = 3, position = "stack")
dev.off()
