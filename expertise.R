# Expertise 

# calculation of expert and expert2 - number of care homes that belong to an experienced provided
# --------------------------------------------------------------------------

          # create a cross table for checking the frequencies between providers and LAs
          # aim: get number markets where providers operate. It can be 0, 1 or >1 - I´m interested in the last group (>1)
          # use: initial data register (data)

          exper =  data.frame(with(data, table(Local.Authority, Provider.ID)))
          
          exper.to = exper %>% filter(Freq != 0) # select those provider.ids where there is activity
          exper.to = exper.to %>% group_by(Provider.ID) %>% 
            dplyr::mutate(oper.markets =n()) %>%# create a variable that counts the number of markets where the provider operates
            arrange(Provider.ID) %>%
            as.data.frame(exper.to) 
          
          with(exper.to, summary(oper.markets))#summary stats (getting some number about the operating markets)
          
          # get those IDs where there is one more than one market
          
          market.s = exper.to %>% filter(oper.markets > 1) %>% select(Provider.ID, oper.markets) %>% as.data.frame()
          
          experienced = droplevels(market.s$Provider.ID) #ID providers operating in more than one market
          
          market.s.b = exper.to %>% filter(oper.markets > 10) %>% select(Provider.ID, oper.markets) %>% as.data.frame()
          experienced2 = droplevels(market.s.b$Provider.ID) 
          
          
          #create variable experience
          
          prueba = data %>% group_by(Local.Authority, start.loc.year, Provider.ID) %>%
            mutate(expert_new= ifelse( Provider.ID %in% experienced, 1, 0), expert2_new= ifelse( Provider.ID %in% experienced2, 1, 0)) %>%
            mutate_each(funs(as.factor), expert_new, expert2_new) %>% 
            as.data.frame()
          
          
          # create variable total.expert(total number of experts in the market)
          
          t = prueba  %>% 
            mutate_each(funs(as.factor), end.loc.year, start.loc.year) %>%
            select(Local.Authority, start.loc.year, end.loc.year, expert_new)
          
          t  = t %>% arrange(Local.Authority,start.loc.year, end.loc.year)
          
          # select only experts 
          test = t%>% filter(expert_new == "1") %>% select(-end.loc.year)
          test.1 = t%>% filter(expert_new == "1") %>% select(-start.loc.year)
          
      #count expert (those that operate in more than 1 market)  
      #......................................................
          
          expertos.active =test %>%
            group_by(Local.Authority, start.loc.year, expert_new) %>%
            tally 
          
          
          expertos.active = expertos.active %>% dplyr::rename(experts.active = n) %>%
            select(-expert_new)
          
          
          expertos.inactive = test.1 %>%
            group_by(Local.Authority, end.loc.year, expert_new) %>%
            tally 
          # clean NA - they are referred to the cases that are active and rename and rename n
          expertos.inactive = expertos.inactive %>%
            filter(!is.na(end.loc.year)) %>%
            dplyr::rename(experts.inactive = n) %>%
            select(-expert_new)
          
          
          # includes active and inactive expertos. Idea: see how many active and inactive there are EACH year 
          expertos = left_join(expertos.active, expertos.inactive, by = c("Local.Authority" = "Local.Authority", "start.loc.year" = "end.loc.year")) 
          
          expertos = as.data.frame(expertos)
          # create the number of net experts 
          
          expertos = expertos %>% dplyr::mutate( experts.active = ifelse(is.na(experts.active), 0, experts.active),
                                                 experts.inactive = ifelse(is.na(experts.inactive), 0, experts.inactive), 
                                                 experts.net = experts.active - experts.inactive) 
          
          
          expertos = expertos %>% group_by(Local.Authority) %>% 
            mutate(net.2 = cumsum(experts.net)) %>% 
            select(Local.Authority, start.loc.year, total.experts = net.2) %>% as.data.frame()
          

# create the variable total.expert2 (number of expert2 in the market; those that operate in more than 10 markets) 

            t = prueba  %>% 
              mutate_each(funs(as.factor), end.loc.year, start.loc.year) %>%
              select(Local.Authority, start.loc.year, end.loc.year, expert2_new)
            
            t  = t %>% arrange(Local.Authority,start.loc.year, end.loc.year)
            
            # select only experts 
            test = t%>% filter(expert2_new == "1") %>% select(-end.loc.year)
            test.1 = t%>% filter(expert2_new == "1") %>% select(-start.loc.year)
            
            
            # count them 
            
            expertos.active =test %>%
              group_by(Local.Authority, start.loc.year, expert2_new) %>%
              tally 
            
            
            expertos.active = expertos.active %>% dplyr::rename(experts.active = n) %>%
              select(-expert2_new)
            
            #rename "n"
            expertos.inactive = test.1 %>%
              group_by(Local.Authority, end.loc.year, expert2_new) %>%
              tally 
            # clean NA - they are referred to the cases that are active and rename
            expertos.inactive = expertos.inactive %>%
              filter(!is.na(end.loc.year)) %>%
              dplyr::rename(experts.inactive = n) %>%
              select(-expert2_new)
            
            
            # includes active and inactive expertos. Idea: see how many active and inactive there are EACH year 
            expertos2 = left_join(expertos.active, expertos.inactive, by = c("Local.Authority" = "Local.Authority", "start.loc.year" = "end.loc.year")) 
            
            expertos2 = as.data.frame(expertos2)
            
            # create the number of net experts 
            
            expertos2 = expertos2 %>% dplyr::mutate( experts.active = ifelse(is.na(experts.active), 0, experts.active),
                                                     experts.inactive = ifelse(is.na(experts.inactive), 0, experts.inactive), 
                                                     experts.net = experts.active - experts.inactive) 
            
            
            expertos2 = expertos2 %>% group_by(Local.Authority) %>% 
              mutate(net.2 = cumsum(experts.net)) %>% 
              select(Local.Authority, start.loc.year, total.experts2 = net.2) %>% as.data.frame()


        expertise = full_join(expertos, expertos2, by = c("Local.Authority", "start.loc.year"))
        
        expertise = expertise %>% dplyr::mutate(total.experts2 = if_else(is.na(total.experts2), 0, total.experts2))
        
#link with data from march onwards
        new.data = left_join(new.data, expertise, by = c("Local.Authority", "start.loc.year"))
        
        write.csv(new.data, "geodata.market.csv", row.names = FALSE)

