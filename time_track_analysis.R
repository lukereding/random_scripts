library(tidyverse)
library(magrittr)

df <- read_csv("~/.time-track.csv", col_names = c("index", "date", "project"))

df %<>%
  mutate(date_formatted = date %>% as.POSIXct(origin = "1970-01-01",tz = "GMT") %>% format(format="%Y-%m-%d"))

source("~/Documents/random_scripts/plotting_functions.R")

cols <- c("#771155", "#AA4488", "#CC99BB", "#114477", "#4477AA", "#77AADD", "#117777", "#44AAAA", "#77CCCC", "#117744", "#44AA77", "#88CCAA", "#777711", "#AAAA44", "#DDDD77", "#774411", "#AA7744", "#DDAA77", "#771122", "#AA4455", "#DD7788")

df %>% 
  filter(! is.na(project)) %>%
  group_by(project) %>%
  tally(sort = T) %>% 
  mutate(hours = n / 4) %>%
  ggplot(aes(x = reorder(project, hours), y = hours)) +
  geom_col()+
  theme_minimal() +
  coord_flip()

df %>%
  mutate(start = date - 900,
         end = date) %>%
  mutate(start_formated = start %>% as.POSIXct(origin = "1970-01-01",tz = "GMT") %>% format(format="%Y-%m-%d"),
         end_formated = end %>% as.POSIXct(origin = "1970-01-01",tz = "GMT") %>% format(format="%Y-%m-%d")) %>%
  mutate(day_start = lubridate::date(start_formated),
         day_end = lubridate::date(end_formated)) %>%
  filter(! is.na(project)) %>%
  group_by(project, day_start) %>%
  tally(sort = T) %>% 
  mutate(hours = n / 4) %>%
  ggplot(aes(x = reorder(project, hours), y = hours)) +
  geom_col()+
  theme_minimal() +
  coord_flip() +
  facet_wrap(~day_start)

# projects every day
df %>%
  mutate(start = date - 900,
         end = date) %>%
  mutate(start_formated = start %>% as.POSIXct(origin = "1970-01-01",tz = "GMT") %>% format(format="%Y-%m-%d"),
         end_formated = end %>% as.POSIXct(origin = "1970-01-01",tz = "GMT") %>% format(format="%Y-%m-%d")) %>%
  mutate(day_start = lubridate::date(start_formated),
         day_end = lubridate::date(end_formated)) %>%
  filter(! is.na(project)) %>%
  group_by(project, day_start) %>%
  tally(sort = T) %>% 
  mutate(hours = n / 4) %>%
  ggplot(aes(x = 1, y = hours)) +
  geom_col(position = "fill", aes(fill = project))+
  theme_minimal() +
  facet_wrap(~day_start) +
  scale_fill_manual(values = sample(cols)) +
  labs(y = "proportion of time")


## hours worked  
df %>%
  group_by(date_formatted) %>%
  count %>%
  mutate(hours = n / 4) %>%
  ggplot(aes(x = date_formatted, y = hours)) +
  geom_col() +
  theme_pubr() +
  rotate_labels()
