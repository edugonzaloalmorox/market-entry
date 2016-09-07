
library(readxl)
library(plyr)
library(dplyr)
library(stringr)
library(tidyr)

data = read_excel(".../july2016/active.xlsx", sheet = 2, col_names = TRUE, col_types = NULL)

data = plyr::rename(data, c("Location ID"= "Location.ID",                                                                                                                                                                
                            "HSCA start date" = "location.start",                                                                                                                                                           
                            "Location HSCA end date" = "location.end",                                                                                                                                                                                                                                                                   
                            "Registered manager (note; where there is more than one manager at a location, only one is included here for ease of presentation. 
                            The full list is available if required)." = "registered.manager",
                            "Web Address"="web.location",                                                                                                                                                                
                            "Care homes beds" = "Care.homes.beds",                                                                                                                                                           
                            "Location Type/Sector"  = "location.type",
                            "Postal Code" = "Postal.Code",                                                                                                                                                             
                            "Local Authority" = "Local.Authority", 
                            "Provider ID" = "Provider.ID",                                                                                                                                                                
                            "Provider Name" = "Provider.Name",                                                                                                                                                           
                            "Provider HSCA start date" = "provider.start",                                                                                                                                                   
                            "Provider Status"  = "provider.status",                                                                                                                                                          
                            "Provider HSCA End Date"  = "provider.end",                                                                                                                                                   
                            "Provider - Telephone Number" = "provider.phone",                                                                                                                                               
                            "Provider - Web Address" = "provider.web",                                                                                                                                                    
                            "Provider - Street Address" = "provider.address",                                                                                                                                                 
                            "Provider - Address Line 2" = "provider.address2",                                                                                                                                                  
                            "Provider - City"  = "provider.city",                                                                                                                                                          
                            "Provider - Postal Code" = "provider.postal.code",                                                                                                                                                    
                            "Provider Local Authority"  = "provider.local.authority",                                                                                                                                                
                            "Provider - County" = "provider.county",                                                                                                                                                          
                            "Provider Region"  = "provider.region",                                                                                                                                                          
                            "Provider Nominated Individual Name"  = "provider.individual.name"))

data = data %>% filter(Local.Authority != "Unspecified") %>% select(`Location.ID`, `Location Name`, `Postal.Code`,`Location Status`,`Care.homes.beds`,`Local.Authority`,
                                                                    `Provider.ID`, `provider.postal.code`,`Provider.Name`, `provider.status`, `provider.postal.code`, `provider.start`,`location.start`, `location.end`, `provider.end`)


# 1. Do some checkings before carrying out the analysis 
# .....................................................

#           order variables according to market entry and local authority 
#           ------------------------------------------------------------------
#           change the type of variable dynamically 

data = data %>% mutate_each(funs(as.factor), -Care.homes.beds) %>% mutate_each(funs(as.Date),   provider.start, location.start, location.end, provider.start)

data = data %>% mutate(start.loc.month =format(location.start, "%m"),
                       start.loc.year = format(location.start, "%Y"),
                       end.loc.month =format(location.end, "%m"),
                       end.loc.year = format(location.end, "%Y"))

# .......................................................................


# Entry rates 
# --------------

    # calculate the number of care homes for each year 
    # calculate de the entry rates 

# Get the entries and exits for the whole period available (2010 -2016) per month and year


counts.entry <- data %>% group_by(Local.Authority, start.loc.month, start.loc.year) %>% tally %>% arrange(Local.Authority, start.loc.year, start.loc.month) %>% as.data.frame()

counts.exit <- data %>% group_by(Local.Authority, end.loc.month, end.loc.year) %>% tally %>% arrange(Local.Authority, end.loc.year, end.loc.month) %>% as.data.frame()



# rename n and clean NA in those inactive -  they are referred to the active  
      
      # entries
      counts.entry = plyr:: rename(counts.entry, c("n" = "entry", "start.loc.month" = "month", "start.loc.year" = "year"))

      # exits 
      counts.exit = plyr:: rename(counts.exit, c("n" = "exit",  "end.loc.month" = "month", "end.loc.year" = "year"))
      
      # drop NAs  
      counts.exit = counts.exit %>% filter(!is.na(month))

      # gets the counts for entries and exists per LA each month and year 
      
      counts.entry = counts.entry %>% mutate_each(funs(as.factor), month, year)
      counts.exit = counts.exit %>% mutate_each(funs(as.factor), year)
      
      
      counts = full_join(counts.exit, counts.entry, by = c("Local.Authority", "year", "month")) 
      
      counts = counts %>% arrange(Local.Authority, year, month) %>% 
        select(Local.Authority, month, year, entry, exit) %>% as.data.frame()
      
      # transform  NA in exits into 0 - meaning: there are not exits that month of that year
    
      counts = counts %>%
        mutate_each(funs(as.factor), Local.Authority) %>%
        mutate_each(funs(as.factor), month, year) %>%
        mutate_each(funs(as.numeric), entry, exit) %>%
        mutate(exit = ifelse(is.na(exit), 0, exit),
               entry = ifelse(is.na(entry), 0, entry),
               net = entry - exit) %>% as.data.frame() # net represents the net flow of entries and exits
      
 #  Build the sample from march 2011 onwards. 
      
        # get the total observations till march 2011
        meses = c("01", "02")
      
      inicio = counts %>%
        group_by(Local.Authority) %>%
        filter(month %in% meses & year== "2011" | year == "2010" ) %>%
        mutate(initial.homes = cumsum(net)) %>% as.data.frame
      
       # extract the last row of each.local.authority
          # - before reflects the number of active care homes till March 2011 for each local authority
                  before = inicio %>% 
                    group_by(Local.Authority) %>%
                    filter(row_number()==n()) %>%
                    mutate(month = ifelse(month != "01", "01", "01"))%>% 
                    select(-entry, -exit, -net)
                  
                  before = before %>% filter(Local.Authority != "Isles of Scilly")
      
        # merge with the observations from march onwards 
        
          counts = full_join(counts, before, by = c("Local.Authority", "year", "month"))
      
        
        # IMPORTANT: check that all the LA have an observation in the month. Otherwise variables are going
        # to be corrupted 
        
        # check months that have all the Local Authorities
        # _________________________________________________
        check = prueba %>% filter(month == "01" & year == "2011") 
        with(data, levels(Local.Authority))
        
        # 150 observations = 150 Local Authorities
        rm(check)
        #__________________________________________________

        # get rid of observations for those years that are not necessary for the analysis in prueba 
        
        
          anos = c("2012", "2013", "2014", "2015", "2016") # years that I want to select 
          counts = counts %>% filter(month != "02" & year == "2011" | year %in% anos) 
            
          
          counts$year = as.numeric(counts$year)
          
          # relabel the year  of the initial homes - I assume they belong to a different period
          counts = counts %>% 
            mutate(var = ifelse(!is.na(initial.homes), 2010, year)) %>%
            select(Local.Authority, month, year = var, entry, exit, net, initial.homes)
        
          
          # insert the `net`  into the `initial.homes`
          counts = counts %>%  mutate(initial.homes = ifelse(is.na(initial.homes), net, initial.homes))
           
         counts = counts %>% group_by(Local.Authority) %>% 
            mutate(homes = cumsum(initial.homes))
           
          #extract the cumulative homes and entries (the total (e.g. net)) number of care homes and entries per year 
         cum.counts = counts %>% group_by(Local.Authority, year) %>%
            mutate(cum.entries = cumsum(entry)) %>%
            filter(row_number()==n()) %>% 
            select(-month, -entry, -exit, -net, -initial.homes) %>% 
           as.data.frame()
          
         cum.counts = cum.counts %>% mutate_each(funs(as.numeric), homes, cum.entries)
         
        ex=  cum.counts %>% group_by(Local.Authority) %>% 
                                      
           mutate(entry.rate= cum.entries/lag(homes), 
                  entry.rate2 = entry.rate*100)



