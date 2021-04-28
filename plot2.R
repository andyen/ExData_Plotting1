library(tidyverse)
library(patchwork)


# import data:
data <- read_delim(
  file = "household_power_consumption.txt",
  delim = ";",
  na = c("?", ""),
  col_types = cols(
    Date = col_character(),
    Time = col_character(),
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
  filter(Date %in% c("1/2/2007", "2/2/2007")) %>%
  mutate(DateTime = as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))
 

# plot data
p2 <- ggplot(data, aes(DateTime, Global_active_power)) +
  geom_line() +
  scale_x_datetime("", date_breaks = "1 day", date_labels = "%a") +
  scale_y_continuous("Global Active Power (kilowatts)", breaks=seq(0,6,2))
plot(p2)

ggsave("plot2.png", p2, width=4.8, height=4.8, dpi=100)
