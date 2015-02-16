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
baltimoreEmissions <- NEI[NEI$fips == 24510, ]

# Focus on Vehicles
baltimoreVehicleEmissions <- merge(SCC[grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE), ], baltimoreEmissions, by = "SCC")

#Aggregate by year
baltimoreYearlyVehiclEmissions <- aggregate(baltimoreVehicleEmissions$Emissions, list(baltimoreVehicleEmissions$year), sum)
names(baltimoreYearlyVehiclEmissions)[names(baltimoreYearlyVehiclEmissions)=="Group.1"] <- "Year"
names(baltimoreYearlyVehiclEmissions)[names(baltimoreYearlyVehiclEmissions)=="x"] <- "Emissions"

# Plot data
png('plot5.png', width=480, height=480, bg = "transparent")
ggplot(baltimoreYearlyVehiclEmissions, aes(factor(Year), Emissions, fill = factor(Year), legend = "Year")) + geom_bar(stat = "identity") + scale_x_discrete("Year") + scale_y_continuous("PM2.5 Emissions (tons)") + scale_fill_discrete(guide = guide_legend(title = "Year")) + ggtitle("Annual PM2.5 Emissions in Baltimore City, MD from Vehicles")
dev.off()
