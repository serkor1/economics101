# Define Functions; 
# TODO: 
# FOR ALL VALUES BELOW 0; Create an Index that 
# deletes all values across both 
# curves









server <- function(input, output, session) {
  
  # Generate Demand and Supply Functions; ####
  supply <- reactive({
    
    message("Supply Function Activated!")
    
    
    linear_function(
      shock = input$shock_sup,
      coeff = as.numeric(input$supply_elasticity),
      type = "supply",
      vat = as.numeric(input$vat_sub),
      lump_sump = as.numeric(input$unit_sub) 
    )
    
    
    
    
  })
  
  
  demand <- reactive({
    
    
    
    linear_function(
      shock = input$shock_dem,
      coeff = as.numeric(input$demand_elasticity),
      vat = as.numeric(input$unit_tax),
      lump_sump = as.numeric(input$lumpsump_tax),
      type = "demand"
    )
    
    
    
    
  })
  
  # Generate Price Controls options based on the intersection; ####
  intersection <- reactive({
    
    intersection_function(
      demand = demand(),
      supply = supply()
    )$imperfect_yint
    
  })
  
  
  
  
  
  
  
  
  
  
  # Baseline Plot; ####
  output$baseline_sd <- renderPlotly(
    equilibrium_plot(
        demand = linear_function(coeff = as.numeric(input$demand_elasticity),type = "demand"),
        supply = linear_function(coeff = as.numeric(input$supply_elasticity), type = "supply"),
        advanced = input$is_adv,
        hide_tick = input$hide_value
      )
    )
  
  # Actual Plot; ####
  output$complex_sd <- renderPlotly({
    

    equilibrium_plot(
      demand = demand(),
      supply = supply(),
      advanced = input$is_adv,
      hide_tick = input$hide_value
    )
    
  }
   
  )
  
  
  
  # Baseline Table; ####
  output$baseline_table <- renderTable({

    stat_table(
      demand = linear_function(coeff = as.numeric(input$demand_elasticity),type = "demand"),
      supply = linear_function(coeff = as.numeric(input$supply_elasticity),type = "supply"),
      advanced = input$is_adv
    ) %>% mutate(
      Measure = str_replace(Measure, pattern = "_", replacement = " ") %>% str_to_title()
    )


  },width = "100%",bordered = TRUE, rownames = FALSE)


  # Actual Table; ####
  output$complex_table <- renderTable({

    stat_table(
      demand = demand(),
      supply = supply(),
      advanced = input$is_adv
    ) %>% mutate(
      Measure = str_replace(Measure, pattern = "_", replacement = " ") %>% str_to_title()
    )


  },width = "100%",bordered = TRUE, rownames = FALSE)
  
  
}