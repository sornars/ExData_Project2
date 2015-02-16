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

# Summarize by year
baltimoreYearlyEmissions <- aggregate(baltimoreEmissions$Emissions, list(baltimoreEmissions$year, baltimoreEmissions$type), sum)
data <- baltimoreYearlyEmissions[baltimoreYearlyEmissions$Group.1 == 1999 | baltimoreYearlyEmissions$Group.1 == 2008, ]
names(data)[names(data)=="Group.1"] <- "Year"
names(data)[names(data)=="Group.2"] <- "type"
names(data)[names(data)=="x"] <- "Emissions"

# Plot data
png('plot3.png', width=480, height=480, bg = "transparent")
ggplot(data, aes(factor(Year), Emissions, fill = factor(Year), legend = "year")) + geom_bar(stat = "identity") + facet_grid(facets = .~ type) + scale_x_discrete("Year") + scale_y_continuous("PM2.5 Emissions (tons)") + scale_fill_discrete(guide = guide_legend(title = "Year")) + ggtitle("Annual PM2.5 Emissions in Baltimore City, MD by Type")
dev.off()
