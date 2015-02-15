# Load external packages
library(RColorBrewer)

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

# Summarize by year
yearlyEmissions <- aggregate(NEI$Emissions, list(NEI$year), sum)

# Plot data
png('plot1.png', width=480, height=480, bg = "transparent")
barplot(yearlyEmissions$x/1000, names.arg = yearlyEmissions$Group.1, col = brewer.pal(length(yearlyEmissions$Group.1), "Set1"), xlab = "Year", ylab = "PM2.5 Emissions (kilotons)", main = "Annual PM2.5 Emissions")
dev.off()
