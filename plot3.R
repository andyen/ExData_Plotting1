library(tidyverse)
library(patchwork)

# Set locale to English for uniform datetime labels.
Sys.setlocale(category = "LC_ALL", locale = "english")

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
p3 <- data %>% 
  pivot_longer(
    c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    names_to = "sub_metering_key",
    values_to = "sub_metering_value"
  ) %>% 
  ggplot(aes(DateTime, sub_metering_value, color=sub_metering_key)) +
  geom_line() +
  scale_y_continuous("Energy sub metering", breaks=seq(0,30,10)) +
  theme(legend.position = c(.95, .95), legend.justification = c("right", "top")) +
  scale_x_datetime("", date_breaks = "1 day", date_labels = "%a") +
  labs(color=NULL)
plot(p3)

ggsave("plot3.png", p3, width=4.8, height=4.8, dpi=100)
