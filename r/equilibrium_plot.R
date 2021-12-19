

equilibrium_plot <- function(demand, supply, advanced = NULL, hide_tick = FALSE) {
  
  # Store the functions as
  # data, with intervention if it exists
  plot_data <- bind_rows(
    demand,
    supply
  ) %>% mutate(
    across(
      .cols = contains("y_intervention"),
      .fns = ~ coalesce(., y_initial)
    ),
    taxed = as.numeric(mean(taxed) > 0)
  )
  
  
  intersections <- intersection_function(
    demand = demand,
    supply = supply
  )
  
  
  
  # Create a Baseplot
  # accordingly
  base_plot <- plot_data %>% plot_ly(
    color = ~type,
    colors = "Blues"
  ) %>% add_lines(
    x = ~x,
    y = ~y_initial
  ) 
  
  
  # Equilibrium Segments
  # If there is an intervention variable
  # then that is the equilirium
  condition <- colnames(plot_data) %>%
    str_detect(pattern = "y_intervention") %>% sum()
  
  
  
  
  # If it is not advanced
  # it should only add segments and exclude 
  # CS, PS and DWL
  
  
  
  
  # Add additional intervention lines
  # and equilibrium segments
  if (condition != 0) {
    
    # Add additional Lines
    # from the intervention
    # and the equilibrium segments
    base_plot <- base_plot %>% add_lines(
      x = ~x,
      y = ~y_intervention,
      line = list(
        dash = "dash"
      )
    ) %>% add_segments(
      x = 0,
      xend = intersections$imperfect_xint,
      y = intersections$imperfect_yint,
      yend = intersections$imperfect_yint,
      line = list(
        dash = "dot",
        color = "gray"
      ),
      opacity = 0.7, showlegend = FALSE
    ) %>% 
      add_segments(
        x = intersections$imperfect_xint,
        xend = intersections$imperfect_xint,
        y = 0,
        yend = intersections$imperfect_yint,
        line = list(
          dash = "dot",
          color = "gray"
        ),
        opacity = 0.7, showlegend = FALSE
      ) 
    

    
    
    
    
  } else {
    
    
    base_plot <- base_plot %>% add_segments(
      x = 0,
      xend = intersections$perfect_xint,
      y = intersections$perfect_yint,
      yend = intersections$perfect_yint,
      line = list(
        color = "gray",
        dash = "dot"
      ),
      opacity = 0.2, showlegend = FALSE
    ) %>% 
      add_segments(
        x = intersections$perfect_xint,
        xend = intersections$perfect_xint,
        y = 0,
        yend = intersections$perfect_yint,
        line = list(
          color = "gray",
          dash = "dot"
        ),
        opacity = 0.2, showlegend = FALSE
      )
    
    
    
  }
  
  
  
  
  if (advanced) {
    
    # Add Consumer, Producer and tax
    # revenue if needed be.
    if (sum(plot_data$taxed) > 0) {
      
      base_plot <- base_plot %>% add_ribbons(
        data = plot_data %>% filter(x <= intersections$imperfect_xint),
        x = ~x,
        ymin = intersections$y_supply,
        ymax = intersections$y_demand,
        name = "Tax Revenue",
        inherit = FALSE,
        fillcolor = "lightgreen",
        opacity = 0.5,
        line = list(color = "transparent")
      )  %>% add_ribbons(
        data = plot_data %>% filter(x <= intersections$imperfect_xint & type == "Demand") %>% mutate(type = "Consumer Surplus"),
        x = ~x,
        ymin = intersections$y_demand,
        ymax = ~y_initial,
        line = list(color="transparent")
      ) %>% add_ribbons(
        data = plot_data %>% filter(x <= intersections$imperfect_xint & type == "Supply")%>% mutate(type = "Producer Surplus"),
        x = ~x,
        ymax = intersections$y_supply,
        ymin = ~y_initial,
        line = list(color="transparent")
      ) %>% add_segments(
        x = 0,
        xend = intersections$imperfect_xint,
        y = intersections$y_demand,
        yend = intersections$y_demand,
        line = list(
          dash = "dot",
          color = "gray"
        ),
        opacity = 0.7, showlegend = FALSE
      ) %>% add_segments(
        x = intersections$imperfect_xint,
        xend = intersections$imperfect_xint,
        y = 0,
        yend = intersections$y_demand,
        line = list(
          dash = "dot",
          color = "gray"
        ),
        opacity = 0.7, showlegend = FALSE
      )
      
      
      
    } else {
      
      base_plot <- base_plot %>%  add_ribbons(
        data = plot_data %>% filter(x <= intersections$imperfect_xint) %>% 
          mutate(type = if_else(type == "Demand", "Consumer Surplus", "Producer Surplus")),
        x = ~x,
        ymax = ~ y_initial,
        ymin = intersections$perfect_yint,
        opacity = 0.5,
        line = list(color="transparent")
      )
      
      
    }
    
  }
  
  
  
  
  
  
  return(
    base_plot %>% layout(
      xaxis = list(
        title = "Quantity",
        showticklabels = isFALSE(hide_tick)
      ),
      yaxis = list(
        title = "Price",
        range = c(0,30),
        showticklabels = isFALSE(hide_tick)
      )
    )
  )
  
  
  
}