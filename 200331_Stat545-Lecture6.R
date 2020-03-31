## Rachel A. Jones Lipinski
## STAT545 - 6 - Introduction to dplyr
## 31st March '20

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

