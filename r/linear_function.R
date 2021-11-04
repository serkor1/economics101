
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
      type = str_to_title(type),
      taxed = as.numeric(vat > 0 | lump_sump >0)
    )
  )
  
}


