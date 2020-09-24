# ggplot

library("tidyverse")
install.packages(tidyverse)


surveys_complete <- read_csv("data_raw/surveys_complete.csv")

ggplot(data = surveys_complete)

ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length))

ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()

surveys_plot <- ggplot(data = surveys_complete, 
                        mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()