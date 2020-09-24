#####################
# MANIPULATING DATA #
#       using       #
#     TIDYVERSE     #
#####################
#
#
# Based on: https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Data is available from the following link (we should already have it)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

#---------------------
# Learning Objectives
#---------------------

#    Describe the purpose of the dplyr and tidyr packages.
#    Select certain columns in a data frame with the dplyr function select.
#    Select certain rows in a data frame according to filtering conditions with the dplyr function filter .
#    Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
#    Add new columns to a data frame that are functions of existing columns with mutate.
#    Use the split-apply-combine concept for data analysis.
#    Use summarize, group_by, and count to split a data frame into groups of observations, apply summary statistics for each group, and then combine the results.
#    Describe the concept of a wide and a long table format and for which purpose those formats are useful.
#    Describe what key-value pairs are.
#    Reshape a data frame from long to wide format and back with the pivit_wider and pivit_longer commands from the tidyr package.
#    Export a data frame to a .csv file.
#----------------------

#------------------
# Lets get started!
#------------------
install.packages("tidyverse")
library(tidyverse)
# tidyverse includes dplyr and tidyr

# load the dataset
surveys <- read_csv("data_raw/portal_data_joined.csv")

# check structure
str(surveys)
class(surveys)

#-----------------------------------
# Selecting columns & filtering rows
#-----------------------------------
select(surveys, plot_id, species_id, weight)

# select can be used with a minus sign to return everything but that column
select(surveys, -record_id)
# select is used for columns

# filter for a particular year - use the ==
filter(surveys, year == 1995)
# filter is used for rows

surveys_1995 <- filter(surveys, year == 1995)


#-------
# Pipes
#-------
# pipes are %>%
# shortcut is ctrl + shift + m

surveys2 <-  filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

surveys_sml <- select(filter(surveys, weight < 5), species_id, sex, weight)


# this is a better way to do the above
surveys %>% 
  filter(weight < 5) %>% 
  select(species_id, sex, weight)
# doing it with pipes you don't need to include the "surveys" in each bracket


surveys_sml <- surveys %>% 
  filter(weight < 5) %>% 
  select(species_id, sex, weight)


#-----------
# CHALLENGE
#-----------

# Using pipes, subset the ```surveys``` data to include animals collected before 1995 and 
# retain only the columns ```year```, ```sex```, and ```weight```.

animals_1995 <- surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight)
# the order of columns in select will determine the order in the new dataframe


#--------
# Mutate
#--------
# this can create a new column but keeping the original column

# "weight_kg" is the new column
surveys_weight <- surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg * 2.2)
# can mutuate lots of things in the one block of code

# can pipe this and display the headers
surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg * 2.2) %>% 
  head()


# can filter and then mutate
surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight / 1000) %>% 
  head()


#-----------
# CHALLENGE
#-----------

# Create a new data frame from the ```surveys``` data that meets the following criteria: 
# contains only the ```species_id``` column and a new column called ```hindfoot_cm``` containing 
# the ```hindfoot_length``` values converted to centimeters. In this hindfoot_cm column, 
# there are no ```NA```s and all values are less than 3.

# Hint: think about how the commands should be ordered to produce this data frame!

new_dataframe <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  select(species_id, hindfoot_cm) %>% 
  filter(hindfoot_cm < 3)

new_dataframe <- surveys %>% 
  filter(!is.na(hindfoot_length), hindfoot_length < 30) %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  select(species_id, hindfoot_cm)


#---------------------
# Split-apply-combine
#---------------------

surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE))

# can specify which package to use in the case of conflicts
surveys %>% 
  dplyr::group_by(sex) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE))

summary(surveys)

surveys$sex <- as.factor(surveys$sex)


# can group by multiple things (e.g., sex and species_id)
surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) %>% 
  print(n = 20)

# can do multiple summarise commands and arrange by which ever you choose
surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>%
  arrange(min_weight)

# can arrange descending
surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>%
  arrange(desc(min_weight))


#-----------
# CHALLENGE
#-----------

# 1. How many animals were caught in each ```plot_type``` surveyed?

num_animals <- surveys %>% 
  group_by(plot_type) %>% 
  summarise(number_of_animals = n())

# 2. Use ```group_by()``` and ```summarize()``` to find the mean, min, and max hindfoot length 
#    for each species (using ```species_id```). Also add the number of observations 
#    (hint: see ```?n```).

hindfoot_info <- surveys %>%
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarise(mean_length = mean(hindfoot_length),
            min_length = min(hindfoot_length), 
            max_length = max(hindfoot_length),
            count = n())


# 3. What was the heaviest animal measured in each year? 
#    Return the columns ```year```, ```genus```, ```species_id```, and ```weight```.

# Need to use mutate to create a new column because summarise makes the rest disappear 
heaviest_year <- surveys %>%
  select(year, genus, species_id, weight) %>%  
  group_by(year) %>% 
  mutate(max_weight = max(weight, na.rm= TRUE)) %>% 
  ungroup()

# Or you can filter by max weight instead
heaviest_year <- surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  filter(weight == max(weight)) %>% 
  select(year, genus, species, weight) %>%
  arrange(year) %>% 
  distinct()



#-----------
# Reshaping
#-----------

surveys_gw <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id, genus) %>% 
  summarise(mean_weight = mean(weight))

#-----------------------
# Pivot wider and longer

# pivot wider
surveys_wide <- surveys_gw %>% 
  pivot_wider(names_from = genus, values_from = mean_weight)

#  pivot longer
surveys_long <- surveys_gw %>% 
  pivot_longer(!plot_id, names_to = "genus", values_to = "mean_weight")

#------------------
# spread and gather

# to go from long to wide format
surveys_spread <- surveys_gw %>% 
  spread(key = genus, value = mean_weight)

# to go from wide to long (minus plot_id to keep that as a varable)
surveys_gather <- surveys_spread %>% 
  gather(key = genus, value = mean_weight, - plot_id)




#-----------
# CHALLENGE
#-----------

# 1. Spread the surveys data frame with year as columns, plot_id as rows, 
#    and the number of genera per plot as the values. You will need to summarize before reshaping, 
#    and use the function n_distinct() to get the number of unique genera within a particular chunk of data. 
#    It’s a powerful function! See ?n_distinct for more.


challenge1 <- surveys %>% 
  group_by(plot_id, year) %>% 
  summarise(num_per_plot = n_distinct(genus)) %>% 
  spread(key = year, value = num_per_plot)




# 2. Now take that data frame and pivot_longer() it again, so each row is a unique plot_id by year combination.

challenge2 <- challenge1 %>% 
  gather(key = year, value = num_per_plot, -plot_id)

# 3. The surveys data set has two measurement columns: hindfoot_length and weight. 
#    This makes it difficult to do things like look at the relationship between mean values of each 
#    measurement per year in different plot types. Let’s walk through a common solution for this type of problem. 
#    First, use pivot_longer() to create a dataset where we have a key column called measurement and a value column that 
#    takes on the value of either hindfoot_length or weight. 
#    Hint: You’ll need to specify which columns are being pivoted.

challenge3 <- surveys %>% 
  gather("measurement", "value", hindfoot_length, weight)

# 4. With this new data set, calculate the average of each measurement in each year for each different plot_type. 
#    Then pivot_wider() them into a data set with a column for hindfoot_length and weight. 
#    Hint: You only need to specify the key and value columns for pivot_wider().

challenge4 <- challenge3 %>% 
  group_by(year, measurement, plot_type) %>% 
  summarise(mean_value = mean(measurement, na.rm=TRUE)) %>% 
  spread(key=measurement, value=mean_value)



#----------------
# Exporting data
#----------------


write_csv(surveys, path = "data_out/surveys.csv")



#------------------------------
# Get and set working directory
#------------------------------

getwd()
setwd("~/FilePath")




