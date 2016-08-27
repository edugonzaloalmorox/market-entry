# Demographics: job seekers, care allowance
# .....................................................................


bene_pop = read.csv("benefits_pop.csv", sep = ",", header = TRUE)


          # - I calculate means on a yearly basis for each local authority for job_seekers and carers 
          # - I create linking variables
          # - I link to the dataframe with the rest of information  
          
          # check LA that are not common and drop them (Isle Scily and City of London)
          # -----------------------------------------------------------
          ld = unique(data$Local.Authority)
          lc = unique(bene_pop$LA)
          
          no.la =  setdiff(lc, ld)
          
          # clean up
          bene_pop =  bene_pop %>%  filter(!(LA %in% no.la))
          
          bene_pop$LA= droplevels(bene_pop$LA)
          
          rm(ld, lc, no.la)
          # -----------------------------------------------------------
          
          
          # create mean variables of job seekers, and people with care allowances. 
          
                
                  bene_pop$job_seek = as.numeric(bene_pop$job_seek)
                  bene_pop$carers= as.numeric(bene_pop$carers) 
                
                  bene_pop = bene_pop %>% 
                    group_by(LA, year) %>% 
                    mutate(m.job.seek= mean(job_seek, na.rm = TRUE), m.carer= mean(carers, na.rm = TRUE)) 
                
                
                
                  bene_pop$la.year = as.factor(bene_pop$la.year)
                
                  bene_pop = as.data.frame(bene_pop %>% select(LA, month.year, job_seek:m.carer))
                
                  write.csv(bene_pop, "bene_pop.csv", row.names = FALSE)
          
          # linking variables 
          
          # Create 'year' linking varible and clean up. I will use this for linking with the other data
          
                  bene_pop = bene_pop %>% separate(month.year, into = c("month", "start.loc.year"))
                  bene_pop$year = as.factor(with(bene_pop, paste0("20", start.loc.year)))
                  bene_pop_yearly = bene_pop%>% select(LA, year, population:m.carer) 
          
          #select unique rows and rename 'LA' -  I use LA (with year) for linking 
                  
                  bene_pop_yearly = bene_pop_yearly %>% distinct() %>% as.data.frame()
                  bene_pop_yearly = plyr:: rename(bene_pop_yearly, c("LA" = "Local.Authority"))
                  
          #the dataset has to be 750 rows (150 Local Authorities by 5 years) - see checks
          
          # checks before saving
          #------------------------------------------------------------------------
          # get the counts of the pairs Local Authority  and year --> there should be 1 per pair
            check = bene_pop_yearly %>% count(Local.Authority, sort = TRUE)
            check %>% filter(n != 5)
            rm(check)
          # -------------------------------------------------------------------------
          
          write.csv(bene_pop_yearly, "bene_pop_yearly.csv", row.names = FALSE) # this file gets the yearly information with regards to population and the average job seekers and carers
          
          # Link datasets by Local Authority and Year 
          ###########################################
          
          #checks on the levels 
          # --------------------------------
          loc.data = unique(data$Local.Authority)
          loc.ben = unique(bene_pop_yearly$LA)
          
          common = base:: intersect(loc.data, loc.ben)
          
          rm(loc.ben, loc,data, common)
          # ---------------------------------
          
                  prueba = data %>% select(-population, -old_population, -m.job.seek, -m.carer)
                  
                  prueba = inner_join(prueba, bene_pop_yearly, c('Local.Authority', 'year') )
                  
                  prueba %>% filter(is.na(m.carer))
                  
                  prueba =  prueba %>% select(-month.year)
                  
                  
                  prueba = left_join(data, bene_pop_yearly, c('Local.Authority', "year" = "year") )
                  
                  write.csv(prueba, "geodata_pop.csv", row.names = FALSE)