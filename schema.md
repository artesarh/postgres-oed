                          Portfolios
                               | 1:N
                             Accounts
                               | 1:N
                           Policies
                             | 1:1
                      StepFunctions
                             | 1:N
                            Steps
                           |
                   -------|--------|------|-------
                   |                 |      |
                FlexiAcc    PolicyFinancials  LocationCondition
                   |                 |      |    
                   -------|--------|------|-------
                                |      1:N       |     1:N      
                             Locations <----- Conditions 
                               |       N:1
                             FlexiLoc
                               |
                           WorkersComp
                               |
                         LocationDetails                                
                           
                          /-----------\
                          |             |
                    ReinsuranceInfo  ReinsuranceScope