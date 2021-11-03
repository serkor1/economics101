# This script stores
# all finished functions


# Calculate Intersections; ####


intersection_function <- function(demand, supply) {
  
  # Original Functions; 
  og_demand <- approxfun(
    x = demand["x"] %>% pull(),
    y = demand["y_initial"] %>% pull(),
    rule = 2
  )
  
  
  og_supply <- approxfun(
    x = supply["x"] %>% pull(),
    y = supply["y_initial"] %>% pull(),
    rule = 2
  )
  
  
  
    
    curve_1_var = "y_initial"
    curve_2_var= "y_initial"
    
    if (ncol(demand) > 3) {
      
      curve_1_var <- "y_intervention"
      
    }
    
    if (ncol(supply) > 3) {
      curve_2_var= "y_intervention"
    }
    
  
  
  
  # Perfect Equilibrium; ####
  x_val <- demand$x
  
  
    demand <- approxfun(
    x = demand["x"] %>% pull(),
    y = demand[curve_1_var] %>% pull(),
    rule = 2
  )
  
    supply <- approxfun(
    x = supply["x"]%>% pull(),
    y = supply[curve_2_var]%>% pull(),
    rule = 2
  )
  
  
  # Calculate Intersections; 
  x_int <- uniroot(
    function(x) demand(x) - supply(x),
    c(min(x_val), max(x_val)))$root
  
  
  
  tibble(
    x_int = x_int,
    y_int = demand(x_int)
  )
  
}




# Supply and Demand Functions; ####


linear_function <- function(shock = NULL, coeff = 2, vat = 0, lump_sump = 0, type = "demand") {
  
  # For all values there is an initial 
  # state which is expressed here
  x <- seq(from = 0, to = 10, length.out = 200)
  
  if (type == "demand") {
    
    y_initial <- -coeff * x + 20
    
  } else {
    
    y_initial <- coeff * x
    
  }
  
  
  
  # Determine if there is some form of taxation
  # we always tax the demand
  if (type == "demand") {
    
      y_intervention <- - (coeff * (1+vat)) * x + 20 - lump_sump

    
  } else {
    
    y_intervention <- y_initial
  
    }
  
  
  
  
  # Add Shock
  if (!is.null(shock)) {
    
    
    if (shock == "pos") {
      
      y_intervention = y_intervention + 5
      
    } else {
      
      y_intervention = y_intervention - 5
    }
    
  }
  
  
  
  # Convert to Tibble;
  data <- tibble(
    x = x,
    y_initial = y_initial,
    y_intervention = y_intervention
  ) %>% filter(
    !across(
      .cols = contains("y")
    ) > 20 | !across(
      .cols = contains("y")
    ) < 0
  )
  
  
  # Check for equality
  condition <- setequal(
    data$y_initial,
    data$y_intervention
  )
  
  
  if (isTRUE(condition)) {
    
    data <- data %>% select(
      "x",
      "y_initial"
    )
    
    
    
  }
  
  return(
    data  %>% mutate(
      type = str_to_title(type)
    )
  )
  
}





# Equilibrium Plots; ####


temp_plot <- function(demand, supply, advanced) {

  # Demand Curve
  demand_curve <- demand
  supply_curve <- supply
  
  
  # Original Intersections;
  # between the initial values
  intersection <- intersection_function(
    demand = demand_curve,
    supply =  supply_curve
  )
  
  # Initialize the base plot
  # so it will fit into the
  # if statements
  
  base_plot <- bind_rows(
    x = demand_curve,
    y = supply_curve
  ) %>% plot_ly(color = ~type,colors = "Blues") %>% add_lines(
    x = ~x,
    y = ~y_initial
  )
  

  if (ncol(demand_curve) > 3 | ncol(supply_curve) > 3) {
    
    
    base_plot <- base_plot %>% add_lines(
      x = ~x,
      y = ~y_intervention,
      line = list(
        dash = "dash"
      )
    ) 
  }
  
  
  base_plot <- base_plot %>% layout(
    xaxis = list(
      title = "Quantity"
    ),
    yaxis = list(
      title = "Price",
      range = c(0,30)
    )
  )
  
  
  
  
  
  if (isTRUE(advanced)) {
    
    
    ribbon_demand <- demand_curve %>% 
      filter(x <= intersection$x_int) %>% 
      mutate(
        type = "Consumer Surplus"
        )
    
    ribbon_supply <- supply_curve %>% 
      filter(x <= intersection$x_int) %>% 
      mutate(
        type = "Producer Surplus"
        )

      # Add Consumer and
      # producer Surplus
      
    if (ncol(demand_curve) > 3 | ncol(supply_curve) > 3) {
      
     data <- bind_rows(
       ribbon_demand,
       ribbon_supply
     ) %>% mutate(
       y_intervention = coalesce(y_intervention,y_initial)
     )
      
      base_plot <- base_plot %>% 
        add_ribbons(
          data = data,
          x = ~x,
          ymin = intersection$y_int,
          ymax = ~y_intervention,
          opacity = 0.5
        )
      

    } else {
      
      base_plot <- base_plot %>% add_ribbons(
        data = bind_rows(
          ribbon_demand,
          ribbon_supply
        ),
        x = ~x,
        ymax = ~ y_initial,
        ymin = intersection$y_int,
        opacity = 0.5
          )
      
      
    }

      


      # Add Tax-revenue

    
    
  }
  
  base_plot
  
 
  
  
}



# Stats table

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




