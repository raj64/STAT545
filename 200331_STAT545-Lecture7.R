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
