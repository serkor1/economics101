
stat_table <- function(supply, demand, advanced) {
  
  
  # Calculate the Intersection between the curves;
  intersections <- intersection_function(
    supply = supply,
    demand = demand
  )
  
  
  # Calculate PS and CS
  producer_surplus <- ( intersections$y_int * intersections$x_int ) / 2
  consumer_surplus <- (( max(demand$y_initial) - intersections$y_int) * intersections$x_int) / 2
  total_welfare <-  consumer_surplus + producer_surplus
  price <- intersections$y_int
  quantity <- intersections$x_int
  
  
  
  
  
  
  # Stats;
  stat_table <- tibble(
    price,
    quantity,
    consumer_surplus,
    producer_surplus,
    total_welfare
  )
  
  
  
  if (isFALSE(advanced)) {
    
    
    stat_table <- stat_table %>% 
      select(
        "price", "quantity"
      )
    
  }
  
  
  
  stat_table  %>% pivot_longer(
    cols = everything(),
    names_to = "Measure",
    values_to = "Value"
  ) 
  
  
  
}