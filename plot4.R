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

# Focus on Coal
coalEmissions <- merge(SCC[grep("Coal", SCC$EI.Sector, ignore.case = TRUE), ], NEI, by = "SCC")

#Aggregate by year
coalYearlyEmissions <- aggregate(coalEmissions$Emissions, list(coalEmissions$year), sum)
names(coalYearlyEmissions)[names(coalYearlyEmissions)=="Group.1"] <- "Year"
names(coalYearlyEmissions)[names(coalYearlyEmissions)=="x"] <- "Emissions"


# Plot data
png('plot4.png', width=480, height=480, bg = "transparent")
ggplot(coalYearlyEmissions, aes(factor(Year), Emissions, fill = factor(Year), legend = "Year")) + geom_bar(stat = "identity") + scale_x_discrete("Year") + scale_y_continuous("PM2.5 Emissions (tons)") + scale_fill_discrete(guide = guide_legend(title = "Year")) + ggtitle("Annual PM2.5 Emissions from Coal Source in the US")
dev.off()
