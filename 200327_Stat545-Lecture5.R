# Rachel A. Jones Lipinski
# Stat545 Class - Lecture 5 Basic care and feeding of data in R
# 27th March '20

library (gapminder)

str(gapminder)

library(tidyverse)

class(gapminder)

gapminder

head(gapminder)
tail(gapminder)
as_tibble(iris)

# Ways to query a dataframe
names(gapminder) # names of the columns
ncol(gapminder) # number of columns in the dataframe
length(gapminder) # ? what does length mean in the context of a df?
dim(gapminder) # states the number of rows, then columns of the dataframe
nrow(gapminder) # number of rows of the dataframe

# use summary to obtain a statistical overview
summary(gapminder)

plot(lifeExp ~ year, gapminder) # use base R graphics to plot a basic figure

plot(lifeExp ~ gdpPercap, gapminder)

plot(lifeExp ~ log(gdpPercap), gapminder)

str(gapminder)

# A df is a special case of a list and is superior to a matrix because it can
# hold vectors of different flavours.

# look at specific variables in a df
head(gapminder$lifeExp)
summary(gapminder$lifeExp)
hist(gapminder$lifeExp)

summary(gapminder$year)
table(gapminder$year)

class(gapminder$continent)
summary(gapminder$continent)
levels(gapminder$continent)
nlevels(gapminder$continent)

# looking under the hood
str(gapminder$continent)

table(gapminder$continent)
barplot(table(gapminder$continent))

## ggplot is included in the tidyverse and can be used to make pretty plots

p <- ggplot(filter(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp))
p <- p + scale_x_log10() # log the x axis the right way

p + geom_point() # plots the data as a scatterplot
p + geom_point(aes(color = continent)) # map continent to colour
p + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 3, se = FALSE)
#> `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) +
  geom_smooth(lwd = 1.5, se = FALSE)
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
