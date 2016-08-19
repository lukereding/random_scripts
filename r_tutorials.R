########### data.table tutorial ###########
################################################
#######################################################
## based on https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.pdf

#############################
#### creating data tables #
#########################
require(data.table)

DT = data.table(x=c("b","b","b","a","a"),v=rnorm(5))
CARS = data.table(cars)

# check all data tables in memory
tables()

#############################
#### sorting data tables ##
#########################

## data tables use a key to sort
## you can have more than one key, and a key corresponds to a column of a data table

haskey(DT)
setkey(DT,x)
haskey(DT)
# now we can subset easily with
DT["b"]

# sort by x and v in DT
setkey(DT,x,v)
# now:
DT["b"]
# note that now the v's are sorted from least to greatest; before they weren't

##### subsetting data tables
DT
# get only rows for which x == "b"
DT[x=="b",]
# or just
DT[x=="b"]

# try:
(DT["b",]) # error

# set a key first, then subset:
setkey(DT,x)
DT["b"] # now it works


# make a huge data frame
grpsize = ceiling(1e7/26^2)
DF <- data.frame(x=rep(LETTERS,each=26*grpsize),y=rep(letters,each=grpsize),v=runif(grpsize*26^2),stringsAsFactors=FALSE)
dim(DF)
# convert to data table
DT = as.data.table(DF)
head(DT)
# set the key
setkey(DT,x,y)

# subset
DT[list("R","h")] %>% head
# note that this is way faster than doing DF[DF$x=="R" & DF$y=="h",] with data.frame



###########################################################
# calculating statistics on subsets of a data table ###
###################################################


# using the giant DT from above, suppose we want to compute the sum of all the v's
DT[,sum(v)]
# note that this is not faster than just doing sum(DT$v)

# if we wanted to compute the sum of v for each level of x, instead of using an apply function we can do
DT[,sum(v),by=x]
# note that using by this way IS much faster than doing things the normal R way
#compare:
(system.time(tapply(DT$v,DT$x,sum)))
# to:
(system.time(DT[,sum(v),by=x]))


# to subset based on two different rows and take the sum:
DT[,sum(v),by="x,y"] %>% head




















#######################################
########################################
#########################################
###########################################

# tidyr tutorial

#############################################
###############################################
#################################################


# tidy data has three features:
### each variable is a column
### each observation is a row
### each value is placed in its own cell 


## usually, you're going to want to use gather.
# gather takes a dataframe and makes it tidy
# gather takes three arguments: the data frame, a key, and a value
# example
stocks <- data.frame(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)
stocks
# this is typical for a dataframe, but it isn't tidy
# what are the variables here?
## stock, a categorical variable (X,Y,or Z)
## price, a number drawn from some normal distribution
## time
# we want each of these to be a column

# we can make it tidy like this:
stocks %>% gather(stock,price,-time)

# stock is the name of the key
# price is the name of the value
# the last argument is the columns of the data frame that we want to collapse. Here, it's everything except time, so -time



## let's try some others:
pew <- read.delim(
  file = "http://stat405.had.co.nz/data/pew.txt",
  header = TRUE,
  stringsAsFactors = FALSE,
  check.names = F
)

pew %>% gather(income,count,-religion)

# we can also try selecting certain rows / columns or sorting the rows:


pew %<>% gather(income,count,-religion) %>% data.table
pew
haskey(pew)
setkey(pew, religion,income)
# pew is not sorted automatically

# grab some rows:
pew["Agnostic"]

# how about agnostic and atheists:
pew[list(c("Agnostic", "Atheist"))]

# how about agnostic and atheists making under 10k:
pew[list(c("Agnostic", "Atheist"), "<$10k")] %>% head

# how about the mean counts for each religion:
pew[,sum(count),by=religion]

# how about number of people by each income:
pew[,sum(count),by=income]

# most populous religions:
pew[,sum(count),by=religion] %>% arrange(desc(V1))














### general brain exercises
# from http://wilkelab.org/classes/SDS348/2016_spring/worksheets/class6.html

library(ggplot2)
data("diamonds")

diamonds %>% head
str(diamonds)

#The best cuts of diamonds are “Very Good”, “Premium”, and “Ideal”. Make a table that selects only those diamonds, and find the minimum, median, and maximum price for each cut.
diamonds %<>% data.table
diamonds %>% setkey(cut)
diamonds[,list(min=min(price), median=as.double(median(price)), max=max(price)), by=cut] %>% .[3:5,]

#For each of the different diamond cuts, calculate the mean carat level among the diamonds whose price falls within 10% of the most expensive diamond for that cut.
diamonds %>% group_by(cut) %>% filter(price >= 0.9*max(price)) %>% summarize(mean_carat=mean(carat))

# Make a table that contains the median price for each combination of cut and clarity, and arrange the final table in descending order of median price.
setkey(diamonds,cut,clarity)
diamonds[,list(median.price=as.double(median(price))),by=list(clarity,cut)] %T>% setorder(-median.price) %>% print





# Verify that the sum of total sleep time (column sleep_total) and total awake time (column awake) adds up to 24h for all animals in the msleep dataset.
msleep %<>% data.table
msleep %>% setkey(name)
all(msleep$sleep_total + msleep$awake == 24) # FALSE
msleep[which(msleep$sleep_total + msleep$awake != 24),]

# Make a list of all the domesticated species in the msleep dataset, in alphabetical order. Hint: domesticated species have the entry “domesticated” in the column conservation.
msleep %<>% setkey(conservation); msleep["domesticated"] %T>% setkey(name) %>% .$name

# For the different vore classifications, tally how many species are awake for at least 18 hours
msleep %>% setkey(vore)
msleep %>% group_by(vore) %>% filter(awake>=18) %>% tally

# Using the function top_n(), identify the top-10 least-awake animals, and list them from least awake to most awake. Explain why this analysis gives you 11 results instead of 10.
msleep %>% arrange(awake) %>% head(10)

# Considering only carnivores and herbivores, make a plot of the percent of time each animal is in REM sleep (out of the total sleep time) vs. the animal’s total sleep time
system.time(msleep %<>% setkey(vore))
msleep %<>% setkey(vore)
msleep[c("carni", "herbi")] %>% select(name, sleep_rem, sleep_total, vore) %$% plot(sleep_total, sleep_rem/ sleep_total, pch=16, bty='l', cex=1.3,col=viridis(3)[vore %>% factor %>% as.numeric])


################################
##################################
#########################################
# intro to dplyr

# http://rpubs.com/justmarkham/dplyr-tutorial

library("dplyr")
library(nycflights13)
data(flights)
head(flights)


# in general, you make dataframes into prettier dataframes that can be printed directly to the screen without head()
# we do this using tbl_df()
# for example:

flights<-tbl_df(flights)
flights

flights %>% glimpse

# we can change it back to a normal dataframe using data.frame:

flights %>% data.frame


################################################
### selecting rows based on some condition ######
###################################################

# in base R, you can use subset() or youDataFrame[yourDataFrame$ColumnName == someCondition,]
# with dplyr, use the filter() function instead:

filter(flights, Month==1) # or
filter(flights,Month==1, Diverted==1) # the comma means '&'


# you can also use the %in% operator
filter(flights, UniqueCarrier %in% c("AA", "UA"))


#######################################################
####### selecting columns #############################
#######################################################

# in base R
flights[, c("DepTime", "ArrTime", "FlightNum")]

# with dplyr, use select():
select(flights, DepTime, ArrTime, FlightNum)



########################################################
##### reorder rows ######################################
#########################################################

# use arrange():

flights %>%
  select(UniqueCarrier, DepDelay) %>%
  arrange(DepDelay) 
# arrange(desc(DepDelay)) # if you want to sort in descending order

#############################################################
#### creating new variables ################################
############################################################

# use mutate()

flights <- flights %>% mutate(Speed = Distance/AirTime*60)

# sometimes, for some reason, you'll look at the variable you just created and it'll be the same for each row
# if that's the case, use

flights <- flights %>% rowwise() %>% mutate(Speed = Distance/AirTime*60)

# and now it should work

#############################################################
#### summarizing subsets of your data ######################
######################################################

# use summarise()
flights %>%
  group_by(Dest) %>%
  summarise(avg_delay = mean(ArrDelay, na.rm=TRUE))


# for each carrier, calculate the percentage of flights cancelled or diverted
flights %>%
  group_by(UniqueCarrier) %>%
  summarise_each(funs(mean), Cancelled, Diverted)


# this is pretty useful:
# count the number of times some combinations of events occur:
flights %>%
  group_by(Month, DayofMonth) %>%
  summarise(flight_count = n())
arrange(desc(flight_count))

# n() counts the number of rows in a group

# same thing:
flights %>%
  group_by(Month, DayofMonth) %>%
  tally(sort = TRUE)



##### using tidyr
install.packages("tidyr")
require(tidyr)
library("dplyr")
library(nycflights13)
data(flights)
head(flights)


#########################################
############ wide to long format  ##############
#########################################################

## use gather() to go from wide to long format data
flights %>% gather(key="variable",value="value") %>% head(20)

# or, to only gather some columns

longFlights <- flights %>% gather(key="variable",value="value",day,dep_time,air_time) %>% head(20)


#########################################################
############ merging two variables into one  ###############
#########################################################

# use unite()

longFlights2<- longFlights %>% unite(O_F,origin,flight,sep=".")


#########################################################
############ split one variable into two  ###############
#########################################################

# use separate()

# let's say in our flights dataset that we wanted to separate the first letter of `tailnum` from the the numbers
longFlights2 %>% separate(O_F,c("origin","flight"),sep="\\.",perl=TRUE) %>% head

# I haven't found a way to, for example, split on the second letter of a three-letter character
# would by useful if your entries were something like A.1, B.2, and so on, then you could use sep="\\."


#########################################################
############ long to wide format  ###############
#########################################################

# use spread()

longFlights %>% spread(key=dest,value=distance)




####################
## purrr ##########
###################

seq(0,20) %>% 
map(prop.test, n = 20, p=0.5) %>% 
map_dbl("p.value") %>% 
plot(0:20, ., xlab= "number successes", ylab="p value", type = "l") + 
abline(0.05, 0, lty=2)




















