## Rachel A. Jones Lipinski
## STAT545 - 6 - Introduction to dplyr
## 31st March '20

## 6.1. Introduction

## load libraries

library(tidyverse)
library(gapminder)

gapminder

class(gapminder)

# some functions know about tibbles e.g print(), other functions do not and 
# will return a data frame.
# every tibble is also a data frame

# for a reminder of the problems of using base data frame printing
iris
# iris prints the entire data frame whereas gapminder is a tbl_df

# the iris data set can be converted into a tibble using as_tibble()
as_tibble(iris)
# now only the first 10 rows of the table are printed and each column has been 
# given category - is this the correct terminology?

## 6.2 Avoid creating excerpts of data - clutters the workspaces - slows down 
## computer and invites errors

## 6.3 Filter
## use filter to subset the data by rows

filter (gapminder, lifeExp < 29) 
  # identify all countries with a life expectancy less than 29

filter (gapminder, country == "Rwanda", year > 1979)
  # filter the data for Rwanda from 1979 onwards

filter (gapminder, country %in% c("Rwanda", "Afghanistan"))
  # generate a new tibble with data only from Rwanda and Afghanistan

## Comparing filter and excerpt
filter(gapminder, country == "Canada")

excerpt <- gapminder[241:252, ]
# excerpt creates a new df - how this code is appalling for two reasons
# 1. not self-documenting
# 2. is fragile i.e. if the df is sorted then rows 241-252 could change

## 6.4 Pipe operator
# consider the assignment operator vs the pipe operator

# to see the first three rows of the table using assignment operator
head(gapminder, 3) # think 'get' when using the assignment operator

gapminder %>% head (3) # using the pipe operator 
# think 'then' when using the pipe operator

## 6.5 Using select to subset the data
select(gapminder, year, lifeExp) # generates a tibble 1,704 x 2

## using the pipe operator to select the same information
gapminder %>%
  select(year, lifeExp) %>%
  head (4)
## Think: take gapminder, selec the variables year and lifeExp and 
## then, show the first four rows

# Comparing the pipe operator to base R
gapminder %>%
  filter(country == "Cambodia") %>%
  select(year, lifeExp)

gapminder[gapminder$country == "Cambodia", c("year", "lifeExp")]
# the tibble formed is the same obvs. however IMHO, the pipe operator is cleaner
# and easier to follow

# Resources - end of chapter