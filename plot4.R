#Downloads file if it does not exist in current directory
if(!file.exists("exdata_data_household_power_consumption.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","exdata_data_household_power_consumption.zip") 
}

#Unzips file if it is not in the current directory
if(!file.exists("household_power_consumption.txt")){
    unzip("exdata_data_household_power_consumption.zip", files = NULL, exdir=".")
}
data <- read.table("household_power_consumption.txt",header = TRUE, sep = ";",na.strings = "?")
data$Date <- as.Date(data$Date,"%d/%m/%Y")
data <- data[data$Date >= as.Date("2007-2-1")&data$Date <= as.Date("2007-2-2"),]
data <- data[complete.cases(data),]
data$dateTime <- paste(data$Date, data$Time)
data <- data[,!(names(data) %in% c("Date","Time"))]
data <- data[c(8,1,2,3,4,5,6,7)]
data$dateTime <- as.POSIXct(data$dateTime)

par(mfrow = c(2,2))
with(data,plot(Global_active_power~dateTime,type = "l", xlab = "",ylab= "Global Active Power"))
with(data,plot(Voltage~dateTime,type = "l",xlab = ""))
with(data,plot(data$Sub_metering_1~data$dateTime,type = "l",col = "black",xlab = "",ylab = "Energy submetering"))
lines(data$dateTime,data$Sub_metering_2,col = "red")
lines(data$dateTime,data$Sub_metering_3,col = "blue")
legend("topright",col = c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty = 1, lwd = 1,bty = "n")
with(data,plot(Global_reactive_power~dateTime,type = "l"))
dev.copy(png,"plot4.png", width=480, height=480)
dev.off()
