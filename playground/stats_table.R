# This Script calculates all the necessary
# values from the Supply and Demand functions;
# CS
# PS
# DWL
# Tax Revenue

source("scripts/functions.R")




supply <- supply_function()
demand <- demand_function()


stat_table <- function(supply, demand) {
  
  
  # Calculate the Intersection between the curves;
  intersections <- intersection_function(
    curve_1 = supply,
    curve_2 = demand
  )
  
  
  # Calculate PS and CS
  cs <- ( intersections$y_int * intersections$x_int ) / 2
  ps <- (( max(demand$y) - intersections$y_int) * intersections$x_int) / 2
  tw <-  cs + ps
  price <- intersections$y_int
  quantity <- intersections$x_int
  
  
  
  # Stats;
  stat_table <- tibble(
    price,
    quantity,
    cs,
    ps,
    tw
  ) %>% pivot_longer(
    cols = everything(),
    names_to = "Measure",
    values_to = "Value"
  ) 
  
  
  
  
  
  
  
  stat_table
  
  
  
}





equilibrium_plot(
  demand,
  supply
) 


