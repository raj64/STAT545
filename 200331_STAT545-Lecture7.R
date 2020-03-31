## Rachel A. Jones Lipinski
## STAT545 - 7 - Single table dplyr functions
## 31st March '20

## 7.1. Where were we?
## Chapter 6 introduced two very important verbs and an operator:
# filter () enables data to be subset with row logic
# select () enables data to be subset by data-variables or column-wise
# the pipe operator %>%, this feeds the LHS as the first argument to
# the expression on the RHS

## load libraries
library(tidyverse)
library(gapminder)

## 7.3 Create a copy of gapminder
## Create an explicit copy of the tibble - since experiments often involve 
## changing the data and one would not want to damage the original data set,
## an copy is created
## this ensures that there is always a copy of the original, unaltered df

(my_gap <- gapminder)

## let output print to screen, but do not store
my_gap %>% filter(country == "Canada")

## if an output is assigned to an object, this can overwrite an existing object
my_precious <- my_gap %>% filter(country == "Canada")

## 7.4 Use mutate() to add new variables

# mutate defines and inserts new variables into a tibble e.g. recover each 
# countries GDP
my_gap %>%
  mutate(gdp = pop * gdpPercap)
# alas, this results in a column with ridiculously large numbers

# what about comparing GDP per capita to a benchmark country?
# this can be achieved by
# 1. filtering down the rows for Canada
# 2. Creating a new, temporary variable in y_gap
#     i. extract gdpPercap variable from the Canadian data
#     ii. replicate it once per country in the dataset, then it will have the
#         correct length
# 3. divide raw gdpPercap by this Canadian figure
# 4. discard the temporary variable of replicated Canadian gdpPercap

ctib <- my_gap %>%
  filter(country == "Canada")
## this is a semi-dangerous way to add a variable
## join would be better - future lesson
my_gap <- my_gap %>%
  mutate(tmp = rep(ctib$gdpPercap, nlevels(country)),
         gdpPercapRel = gdpPercap / tmp,
         tmp = NULL)

# sanity check this worked by filtering for the Canadian values for gdpPercapRel
# these values should all be 1
my_gap %>%
  filter(country == "Canada") %>%
  select(country, year, gdpPercapRel)

# since Canada is a relatively high GDP country, one should expect the 
# distribution of gdpPercapRel to be located below 1
summary(my_gap$gdpPercapRel)

# 7.5 Use arrange () to row-order data in a principled way
# arrange reorders rows in a df - think of it as akin to sort in Airtable
# this should be used to make tables pretty for humans NOT for data analysis

my_gap %>%
  arrange(year, country)

my_gap %>%
  filter(year == 2007) %>%
  arrange(lifeExp) # data from 2007 sorted by ascending life expectancy

# for descending life expectancy use:
my_gap %>%
  filter(year == 2007) %>%
  arrange(desc(lifeExp))
  
# 7.6 Use rename () to rename variables
my_gap %>%
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)

# 7.7 select() can rename and reposition variables
# select() can be used to rename variables you request to keep
# select() can be used with everything() to hoist a variable up to the front of 
# a tibble

my_gap %>%
  filter(country == "Burundi", year > 1996) %>%
  select(yr = year, lifeExp, gdpPercap) %>%
  select(gdpPercap, everything())

# 7.8 group_by(), summarize()
# 7.8.1 Counting things up
my_gap %>%
  group_by(continent) %>%
  summarize(n = n())
# this provides a 'tidier' output than baseR because the output from step i
# can become the input to step i+1

my_gap %>%
  group_by(continent) %>%
  tally() # the same output as above, but tally is a slicker function

my_gap  %>%
  count(continent) # count will group and count in the same function!

# can also count unique features in a group
my_gap %>%
  group_by(continent) %>%
  summarize(n = n(),
            n_countries = n_distinct(country))

# 7.8.2 General Summarization

# statistically ill-advised, compute average life expectancy by continent
my_gap %>%
  group_by(continent) %>%
  summarize(avg_lifeExp = mean(lifeExp))

# use summarize at to apply the same functions to multiple variables
my_gap %>%
  filter(year %in% c(1952, 2007)) %>%
  group_by(continent, year) %>%
  summarize_at(vars(lifeExp, gdpPercap), list(~mean(.), ~median(.)))

# using min and max
my_gap %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  summarize(min_lifeExp = min(lifeExp), max_lifeExp = max(lifeExp))

# 7.9 Grouped mutate
# Keeping groups and computing within them

# 7.9.1 Computing with group-wise summaries
my_gap %>%
  group_by(country) %>%
  select(country, year, lifeExp) %>%
  mutate(lifeExp_gain = lifeExp - first(lifeExp)) %>%
  filter(year < 1963)
# the first function extracts the first value from a vector

# 7.9.2 Window functions
my_gap %>%
  filter(continent == "Asia") %>% 
  select(year, country, lifeExp) %>%
  group_by(year) %>% # up to this point have created a tibble of the 
  #Asia data containing year, country and lifeExp grouped by year
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>%
  arrange(year) %>%
  print(n = Inf)
# min_rank is a window function - because Asia is grouped by year, min_rank...
# ...will operate within the mini-datasets, for each year
# by including <2 in the filter statement, we will only get the #1 ranked...
# ...country

# 7.10 Putting it all together - is this a good idea?

# which country has the sharpest 5-year drop in life expectancy?

my_gap  %>%
  select(country, year, continent, lifeExp) %>%
  group_by(continent, country) %>%
  ## within country, take (lifeExp in year i) - (lifeExp in year i-1)
  ## positive means lifeExp went up, negative means it went down
  mutate(lifeExp_delta = lifeExp - lag(lifeExp)) %>%
  ## within country, retain the worst lifeExp change = smallest or most negative
  summarize(worst_lifeExp_delta = min(lifeExp_delta, na.rm = TRUE)) %>%
  ## within continent, retain the row with the lowest worst_lifeExp_delta
  top_n(-1, wt = worst_lifeExp_delta) %>%
  arrange(worst_lifeExp_delta)

# comments is it sensible to pipe so many functions into a single step