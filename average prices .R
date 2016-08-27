# filter by variables 
# get the monthly average of prices per postal code 


library(stringr)
library(plyr)
library(dplyr)

# split the code  -  create a postcode at the level of the postcode sector (outward code and first element of inward code)
houses_analysis$code= as.character(houses_analysis$code)

postcode = str_split_fixed(houses_analysis$code, " ", 2)

postcode = as.data.frame(postcode)
colnames(postcode) = c("outward", "inward")

finward = str_sub(postcode$inward, start = 1, end = 1)

postcode$pc_sector =  with(postcode, paste(outward, finward, sep = " "))

postcode$code = with(postcode, paste(outward, inward, sep = " "))

p.c.sector = postcode %>%
  select(code, pc_sector)
 
houses_analysis[["pc_sector"]] <-postcode$pc_sector

rm(postcode, p.c.sector) #clean up

houses_analysis$pc_sector <- as.factor(houses_analysis$pc_sector )

houses_clean = houses_analysis %>% filter(pc_sector != " ") # remove observations that do not have postal code


# get the price average according to postsector



houses_clean$date.3 = with(houses_clean, paste(month, year, sep="/"))
houses_clean$date.3 = as.factor(houses_clean$date.3)
houses_clean$date.3 = with(houses_clean, ordered(date.3, levels = c("Jun/2010", "Jul/2010",
                                              "Aug/2010", "Sep/2010", "Oct/2010", "Nov/2010", "Dec/2010", "Jan/2011", "Feb/2011",
                                              "Mar/2011","Apr/2011", "May/2011", "Jun/2011", "Jul/2011", "Aug/2011", "Sep/2011",
                                              "Oct/2011", "Nov/2011", "Dec/2011" ,"Jan/2012", "Feb/2012" ,"Mar/2012" ,"Apr/2012",
                                              "May/2012", "Jun/2012", "Jul/2012", "Aug/2012", "Sep/2012", "Oct/2012", "Nov/2012",
                                              "Dec/2012", "Jan/2013", "Feb/2013", "Mar/2013", "Apr/2013", "May/2013",
                                              "Jun/2013", "Jul/2013", "Aug/2013", "Sep/2013", "Oct/2013", "Nov/2013", 
                                              "Dec/2013", "Jan/2014",
                                              "Feb/2014", "Mar/2014", "Apr/2014", "May/2014", "Jun/2014", "Jul/2014" ,"Aug/2014",
                                              "Sep/2014", "Oct/2014", "Nov/2014", "Dec/2014", "Jan/2015", "Feb/2015", "Mar/2015",
                                              "Apr/2015","May/2015", "Jun/2015" ,"Jul/2015" ,"Aug/2015", "Sep/2015", "Oct/2015",
                                              "Nov/2015", "Dec/2015", "Jan/2016", "Feb/2016", "Mar/2016")))

with(houses_clean, table(date.3))



monthly <- ddply(houses_clean,
                        .(date.3, pc_sector), 
                        summarize, mean.price=mean(price))


write.csv(monthly, "monthly_prices_postsector_jun2010_march.csv") 








