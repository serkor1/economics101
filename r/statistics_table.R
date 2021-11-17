
stat_table <- function(supply, demand, advanced) {
  
  
  # Calculate the Intersection between the curves;
  intersections <- intersection_function(
    supply = supply,
    demand = demand
  )
  
  
  
  intersections <- intersection_function(
    supply = supply,
    demand = demand
  )
  
  
  # if the imperfect y intercept
  # is equal to the intercept of 
  # of y_demand and y_supply
  # there is perfect comptetition
  
  
  isEqual <- setequal(
    intersections$y_demand,
    intersections$y_supply
  )
  
  
  if (isTRUE(isEqual)){
    
    
    ps <- (intersections$perfect_yint * intersections$perfect_xint) / 2
    cs <- ( (max(demand$y_initial) - intersections$perfect_yint) * intersections$perfect_xint)/2
    tw <- ps + cs
    c_price  <- intersections$perfect_yint
    s_price <- intersections$perfect_yint
    
    q  <- intersections$perfect_xint
    
    
  } else {
    
    # Determine the existence of 
    # the values. Depending on the shock being on supply side
    # or demand side determines whether the intervention variable exists
    if ("y_intervention" %in% colnames(demand)){
      
      y_demand <- demand$y_intervention
      
      
    } else {
      
      y_demand <- demand$y_initial
      
      
    }
    
    if ("y_intervention" %in% colnames(supply)){
      
      y_supply <- supply$y_intervention
      
      
    } else {
      
      y_supply <- supply$y_initial
      
      
    }
    
    
    
    ps <- (intersections$imperfect_yint * intersections$imperfect_xint) / 2
    cs <- ( (max(y_demand) - intersections$imperfect_yint) * intersections$imperfect_xint)
    tw <- ps + cs
    c_price  <- intersections$imperfect_yint
    s_price <- intersections$imperfect_yint
    
    q  <- intersections$imperfect_xint
    
    
  }
  
  # If the market is taxed,
  # there is a discrepancy between
  # the market price, and the price that 
  # the suppliers are getting
  
  if (mean(demand$taxed) == 1) {
    
    
    tax_revenue <- (intersections$y_demand - intersections$y_supply) * intersections$imperfect_xint
    
    c_price  <- intersections$y_demand
    s_price <- intersections$y_supply
    
    q  <- intersections$imperfect_xint
    
    
    
  } else {
    
    tax_revenue <- 0
    
  }
  
  
  
  stat_table <- tibble(
    consumer_price  = c_price,
    producer_price = s_price,
    quantitiy  = q,
    producer_surplus = ps,
    consumer_surplus = cs,
    total_welfare = tw,
    tax_revenue = tax_revenue
  )
  
  
  if (isFALSE(advanced)) {
    
    stat_table <- stat_table %>% 
      select(
        contains("price"),
        contains("quantitiy")
      )
    
    
  }
  
  
  stat_table %>% pivot_longer(
    cols = everything(),
    names_to = "Measure",
    values_to = "Value"
  ) 
  
  
  
}