#   _____ _             _   _                        _ _   _       _____        _        
#  / ____| |           | | (_)                      (_| | | |     |  __ \      | |       
# | (___ | |_ __ _ _ __| |_ _ _ __   __ _  __      ___| |_| |__   | |  | | __ _| |_ __ _ 
#  \___ \| __/ _` | '__| __| | '_ \ / _` | \ \ /\ / | | __| '_ \  | |  | |/ _` | __/ _` |
#  ____) | || (_| | |  | |_| | | | | (_| |  \ V  V /| | |_| | | | | |__| | (_| | || (_| |
# |_____/ \__\__,_|_|   \__|_|_| |_|\__, |   \_/\_/ |_|\__|_| |_| |_____/ \__,_|\__\__,_|
#                                    __/ |                                               
#                                   |___/                                                
#
# Based on: https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html



# Lets download some data (make sure the data folder exists)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")     #destination file

# now we will read this "csv" into an R object called "surveys"
surveys <- read.csv("data_raw/portal_data_joined.csv")

# and take a look at it
View(surveys)    # Needs a capital letter because View is only for R Studio
head(surveys)
head(surveys,2)
tail(surveys)

# BTW, we assumed our data was comma separated, however this might not
# always be the case. So we may been to tell read.csv more about our file.



# So what kind of an R object is "surveys" ?
class(surveys)


# ok - so what are dataframes ?
# a series of vectors 
str(surveys)   # tells you what type each variable is
dim(surveys)   #tells you number of rows and columns


names(surveys) #Gives you the names of all columns
row.names(surveys)

# --------
# Exercise
# --------
#
# What is the class of the object surveys?
#
# Answer: Dataframe


# How many rows and how many columns are in this survey ?
#
# Answer: 13
ncol(surveys)
str(surveys)
# What's the average weight of survey animals
#
#
# Answer: 42.67
mean(surveys$weight, na.rm = TRUE)
summary(surveys)

# Are there more Birds than Rodents ?
summary(surveys)

sum(surveys$taxa == "Rodent")
#
# Answer:


# 
# Topic: Sub-setting
#

# first element in the first column of the data frame (as a vector)
surveys[1,1]

# first element in the 6th column (as a vector)
surveys[1,6]

# first column of the data frame (as a vector)
surveys[,1]

# first column of the data frame (as a data frame)
surveys[1]          # only use one number
head(surveys[1])

# first row (as a data frame)
surveys[1, ]   #This can't be a vector because the data-types are different across columns

# first three elements in the 7th column (as a vector)
surveys[1:3, 7]

# the 3rd row of the data frame (as a data.frame)
surveys[3, ]

# equivalent to head(surveys)
head(surveys)
surveys[1:6, ]

# looking at the 1:6 more closely
1:6
surveys[c(1,2,3,4,5,6), ]


# we also use other objects to specify the range
rows <- 6
surveys[1:rows, 3]


#
# Challenge: Using slicing, see if you can produce the same result as:
#
  tail(surveys)
#
# i.e., print just last 6 rows of the surveys dataframe
#
# Solution:
surveys[34781:34786, ]

surveys[(nrow(surveys)-5):nrow(surveys),]

end <- nrow(surveys)
surveys[(end -5):end),]


# We can omit (leave out) columns using '-'
surveys[-1]               #Remove column 1
surveys[c(-1, -2, -3)]    #Remove columns 1, 2, and 3
surveys[c(-1:-6)]
surveys[ -(1:3)]


# column "names" can be used in place of the column numbers
head(surveys)
surveys[c("month", "year")]

#
# Topic: Factors (for categorical data)
#

gender <- c("male", "female", "female")
View(gender)

gender <- factor(c("male", "female", "female"))
gender
class(gender)
levels(gender)
nlevels(gender)

# factors have an order
temperature <- factor(c("hot", "cold", "hot", "warm"))
# this will code them in alphabetical order
temperature[1]
levels(temperature)
temperature <- factor(c("hot", "cold", "hot", "warm"), 
                      levels = c("cold", "warm", "hot"))  
# this will code them in a certain order
levels(temperature)


# Converting factors
as.numeric(temperature)
as.character(temperature)

# can be tricky if the levels are numbers
year <- factor(c(1990, 1992, 1993, 1995, 1996, 1995))
year

as.numeric(year)
as.character(year)
as.numeric(as.character(year))

# so does our survey data have any factors

str(surveys)

levels(surveys$taxa)
surveys$taxa
#
# Topic:  Dealing with Dates
#

# R has a whole library for dealing with dates ...
library(lubridate)

my_date <- ymd("2015-01-01")
class(my_date)

# R can concatenated things together using paste()
paste("abc", "123")
paste("abc", "123", sep="-")
paste("2015", "01", "26", sep="-")
my_date <- ymd( paste("2015", "01", "26", sep="-"))
class(my_date)


# 'sep' indicates the character to use to separate each component


# paste() also works for entire columns
surveys$date <- ymd(paste(surveys$year, 
                          surveys$month, 
                          surveys$day, 
                          sep = "-"))

surveys$date


# let's save the dates in a new column of our dataframe surveys$date 


# and ask summary() to summarise 
summary(surveys)

# but what about the "Warning: 129 failed to parse"
# some data couldn't be converted

summary(surveys$date)


missing <-surveys[is.na(surveys$date), "date"]
missing

missing <-surveys[is.na(surveys$date), c("date", "year", "month", "day")]
missing

#all these missing dates are from months which don't have 31 days