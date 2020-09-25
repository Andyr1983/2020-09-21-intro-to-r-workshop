# ggplot

# ggplot really needs long format data

#-------------------------------
# install pakage and import data
#-------------------------------

library("tidyverse")

surveys_complete <- read_csv("data_raw/surveys_complete.csv")


#-------------
# create plots
#-------------

# not enough information
ggplot(data = surveys_complete)

# mapping is telling it what is going on the axes
ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length))

# geom_point is telling it what type of graph
ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()

# then we can assign this to an object
surveys_plot <- ggplot(data = surveys_complete, 
                        mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(colour = "red") +
  geom_smooth()
surveys_plot

# three steps: 1. which data, 2. apply mapping, 3. apply geoms


# any aesthetic that is applied in the global mapping will be applied to the whole graph
# any aesthetic applied to geom is only seen by that geom
surveys_plot <- ggplot(data = surveys_complete, 
                       mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(aes(group = plot_id)) +
  geom_smooth(aes(group = plot_id))
surveys_plot

#-----------------
# challenges 1 & 2

# challenge 1
challenge1 <- ggplot(data = surveys_complete, 
                       mapping = aes(x = hindfoot_length, y = weight)) +
  geom_point(aes(colour = plot_id)) +
  geom_smooth(aes(group = plot_id))
challenge1

# challenge 2
challenge2 <-  ggplot(data = surveys_complete,
                      mapping = aes(weight)) +
  geom_histogram()
challenge2

#------------------
# alpha and colours

# if using something outside dataset to colour things, it can go outside aes bracket
ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, colour = "blue")

# if using something from your dataset to colour things, it needs to go in the aes bracket
ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, aes(colour = species_id))

# could also put the colour in the mapping aes
ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length, colour = species_id)) +
  geom_point(alpha = 0.1)

#-------------
# challenge 3

# challenge 3
challenge3 <- ggplot(data = surveys_complete,
                     mapping = aes(x = species_id, y = weight))+
  geom_jitter(alpha = 0.2, aes(colour = plot_type))
challenge3


#----------
# boxplots
ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = weight))+
  geom_boxplot()

ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = weight))+
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, colour = "tomato")


# challenge 4
challenge4 <- ggplot(data = surveys_complete,
                     mapping = aes(x = species_id, y = weight))+
  geom_jitter(alpha = 0.1, colour = "tomato") +
  geom_boxplot(alpha = 0)
challenge4

ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = weight))+
  geom_jitter(alpha = 0.1, colour = "tomato") +
  geom_boxplot(alpha = 0)

# challenge 5
ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = weight))+
  geom_jitter(alpha = 0.1, colour = "tomato") +
  geom_violin()



# challenge 6
class(surveys_complete$plot_id)

ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = hindfoot_length))+
  geom_jitter(alpha = 0.3, aes(colour = plot_id))+
  geom_boxplot(alpha = 0)

# to change plot_id to a factor you need to assign it
surveys_complete$plot_id <- as.factor(surveys_complete$plot_id)

ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = hindfoot_length))+
  geom_jitter(alpha = 0.3, aes(colour = plot_id))+
  geom_boxplot(alpha = 0)


# challenge 7
ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, aes(colour = plot_id))+
  scale_y_log10()


# plotting time series data
yearly_counts <- surveys_complete %>% 
  count(year, genus)

ggplot(data = yearly_counts,
       mapping = aes(x = year, y = n)) +
  geom_line()


# challenge 8
ggplot(data = yearly_counts,
       mapping = aes(x = year, y = n, group = genus)) +
  geom_line(aes(colour = genus))
             