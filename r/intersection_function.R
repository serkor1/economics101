
intersection_function <- function(demand, supply) {
  
  x_val <- demand$x
  
  # Perfect Competition Functions; ####
  # these are used to calculate intersections between 
  # different lines in case of interventions
  perfect_demand <- approxfun(
    x = demand["x"] %>% pull(),
    y = demand["y_initial"] %>% pull(),
    rule = 2
  )
  
  
  perfect_supply <- approxfun(
    x = supply["x"] %>% pull(),
    y = supply["y_initial"] %>% pull(),
    rule = 2
  )
  
  
  perfect_xint <- uniroot(
    function(x) perfect_demand(x) - perfect_supply(x),
    c(min(x_val), max(x_val)))$root
  
  
  
  
  
  
  
  
  # Imperfect Competition; ####
  # that starts with y_initial.
  # if the number of colums are above
  # 3, then there is an intervention
  demand_var <-  "y_initial"
  supply_var <-  "y_initial"
  
  if (ncol(demand) > 4) {
    
    demand_var <- "y_intervention"
    
  }
  
  if (ncol(supply) > 4) {
    supply_var= "y_intervention"
  }
  
  
  
  
  imperfect_xint <- demand$x
  
  
  imperfect_demand <- approxfun(
    x = demand["x"] %>% pull(),
    y = demand[demand_var] %>% pull(),
    rule = 2
  )
  
  imperfect_supply <- approxfun(
    x = supply["x"]%>% pull(),
    y = supply[supply_var]%>% pull(),
    rule = 2
  )
  
  
  # Calculate Intersections; 
  imperfect_xint <- uniroot(
    function(x) imperfect_demand(x) - imperfect_supply(x),
    c(min(imperfect_xint), max(imperfect_xint)))$root
  
  
  
  tibble(
    perfect_xint = perfect_xint,
    perfect_yint = perfect_supply(perfect_xint),
    imperfect_xint = imperfect_xint,
    imperfect_yint = imperfect_demand(imperfect_xint),
    y_demand = perfect_demand(imperfect_xint),
    y_supply = perfect_supply(imperfect_xint)
    
  )
  
}
