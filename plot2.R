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
baltimoreYearlyEmissions <- aggregate(baltimoreEmissions$Emissions, list(baltimoreEmissions$year), sum)
data <- baltimoreYearlyEmissions[baltimoreYearlyEmissions$Group.1 == 1999 | baltimoreYearlyEmissions$Group.1 == 2008, ]

# Plot data
png('plot2.png', width=480, height=480, bg = "transparent")
barplot(data$x/1000, names.arg = data$Group.1, col = c("red", "blue"), xlab = "Year", ylab = "PM2.5 Emissions (kilotons)", main = "Annual PM2.5 Emissions in Baltimore City, MD")
dev.off()
