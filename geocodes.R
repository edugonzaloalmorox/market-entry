
# Geocode UK postal codes 
# -----------------------

# - I associate postal codes with coordinates and LSOA codes 
# - I use LSOA codes for linking variables from the census at postal code level

coords = read.csv("coord.csv", sep = ",", header = TRUE)
names(coords)[2] <- "Postal.Code"

# create an alternative variable for linking data from both datasets - pc (drops the white space in the postcode)

data_clean$pc = gsub("\\s", "", data_clean$Postal.Code)

data_clean = data_clean %>% select(Location.ID, `Location Name`,pc, Postal.Code:end.loc.year)


# checks
#__________________________________________________________________________ 
check = data_clean %>% filter(grepl("\\s", pc)) 
check.1 = coords %>% filter(grepl("\\s", pc))
# need to have 0 observations
rm(check, check.1)
#__________________________________________________________________________ 


# merge information in data_clean and coords

geodata = left_join(data_clean, coords, by = c('Postal.Code' = 'Postal.code', 'pc' ='pc'))
geodata = left_join(geodata, coords, by = c('pc' ='pc'))

# check whether there are still observations that have NA in their coordinates
check = geodata %>% filter(is.na(lat.y))


# reorder variables 

geodata = geodata %>% select(Location.ID:end.loc.year, Postal.code:msoa11.y) 
geodata = geodata %>% select(Postal.Code, pc, Postal.code, Location.ID:msoa11.y, -Postal.code)

coordenadas <-  c("lat.y", "long.y", "lsoa11.y", "msoa11.y")


colnames(geodata) <-  c("Postal.Code" , "pc" , "Location.ID", "Location.Name" ,        
                        "Location Status", "Care.homes.beds", "Local.Authority" ,  "Provider.ID",         
                        "provider.postal.code","Provider.Name", "provider.status" ,     "provider.start",      
                        "location.start","location.end","provider.end","start.loc.month",    
                        "start.loc.year", "end.loc.month" ,"end.loc.year",       
                        "lat","long","lsoa11","msoa11") 


write.csv(data, "geodata.csv", row.names = FALSE) # geocoded dataset 