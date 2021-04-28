library(tidyverse)
library(patchwork)

# import data:
data <- read_delim(
  file = "household_power_consumption.txt",
  delim = ";",
  na = c("?", ""),
  col_types = cols(
    Date = col_date(format="%d/%m/%Y"),
    Time = col_time(format = "%H:%M:%S"),
    Global_active_power = col_double(),
    Global_reactive_power = col_double(),
    Voltage = col_double(),
    Global_intensity = col_double(),
    Sub_metering_1 = col_double(),
    Sub_metering_2 = col_double(),
    Sub_metering_3 = col_double()
  )
)

# filter to relevant dates:
data <- data %>% 
  filter(Date %in% c("1/2/2007", "2/2/2007"))

# plot data
p1 <- ggplot(data, aes(Global_active_power)) +
  geom_histogram(bins=20, fill="red", color="black") +
  scale_x_continuous("Global Active Power (Kilowatts)", breaks=seq(0,6,2)) +
  scale_y_continuous("Frequency", breaks=seq(0,1200,200)) +
  ggtitle("Global Active Power")

ggsave("plot1.png", p1, width=4.8, height=4.8, dpi=100)

