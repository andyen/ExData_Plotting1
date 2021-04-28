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


# Plot Global Active Power vs Datetime
p1 <- data %>% 
  ggplot(aes(DateTime, Global_active_power)) +
  geom_line() +
  scale_y_continuous("Global Active Power", breaks=seq(0,6,2))


# Plot Voltage vs DateTime
p2 <- data %>% 
  ggplot(aes(DateTime, Voltage)) +
  geom_line() +
  scale_y_continuous("Voltage (V)", breaks=seq(234,246,4))


# Plot Energy sub metering vs DateTime
p3 <- data %>% 
  pivot_longer(
    c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    names_to = "sub_metering_key",
    values_to = "sub_metering_value"
  ) %>% 
  ggplot(aes(DateTime, sub_metering_value, color=sub_metering_key)) +
  geom_line() +
  scale_y_continuous("Energy sub metering", breaks=seq(0,30,10)) +
  labs(color=NULL) +
  theme(legend.position = c(.95, .95), legend.justification = c("right", "top"))

# Plot Global reactive power vs DateTime
p4 <- data %>% 
  ggplot(aes(DateTime, Global_reactive_power)) +
  geom_line() +
  scale_y_continuous("Global reactive power", breaks=seq(0,0.5,0.1))


# Set locale to English for uniform datetime labels.
Sys.setlocale(category = "LC_ALL", locale = "english")

p <- (p1 | p2) / (p3 | p4) &
  scale_x_datetime("", date_breaks = "1 day", date_labels = "%a")

# save final plot
ggsave("plot4.png", p, width=480/70, height=480/70, dpi=70)
