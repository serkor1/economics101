# Define Functions; 
# TODO: 
# FOR ALL VALUES BELOW 0; Create an Index that 
# deletes all values across both 
# curves









server <- function(input, output, session) {
  
  
  # Generate Demand and Supply Functions
  supply <- reactive({
    
    shock <- NULL
    
    if (!is.null(input$side)) {
      
      if (input$side == "s_side"){
        
        shock = input$shock
        
        
      }
      
    }
    
    linear_function(
      shock = shock,
      coeff = as.numeric(input$supply_elasticity),
      type = "supply",
      vat = as.numeric(input$unit_tax),
      lump_sump = as.numeric(input$lumpsump_tax) 
    )
    
    
    
    
  })
  
  
  demand <- reactive({
    
    shock <- NULL
    
    if (!is.null(input$side)) {
      
      if (input$side == "d_side"){
        
        shock = input$shock
        
        
      }
      
    }
    
    linear_function(
      shock = shock,
      coeff = as.numeric(input$demand_elasticity),
      vat = as.numeric(input$unit_tax),
      lump_sump = as.numeric(input$lumpsump_tax),
      type = "demand"
    )
    
    
    
    
  })
  
  
  
  
  
  
  # Baseline Plot
  output$baseline_sd <- renderPlotly(
    equilibrium_plot(
        demand = linear_function(coeff = as.numeric(input$demand_elasticity),type = "demand"),
        supply = linear_function(coeff = as.numeric(input$supply_elasticity), type = "supply"),
        advanced = input$is_adv
      )
    )
  
  
  output$complex_sd <- renderPlotly({
    

    equilibrium_plot(
      demand = demand(),
      supply = supply(),
      advanced = input$is_adv
    )
    
  }
   
  )
  
  
  
  
  # output$baseline_table <- renderTable({
  # 
  #   stat_table(
  #     demand = linear_function(coeff = as.numeric(input$demand_elasticity),type = "demand"),
  #     supply = linear_function(coeff = as.numeric(input$supply_elasticity),type = "supply"),
  #     advanced = input$is_adv
  #   ) %>% mutate(
  #     Measure = str_replace(Measure, pattern = "_", replacement = " ") %>% str_to_title()
  #   )
  # 
  # 
  # },width = "100%",bordered = TRUE, rownames = FALSE)
  # 
  # 
  # 
  # output$complex_table <- renderTable({
  # 
  #   stat_table(
  #     demand = demand(),
  #     supply = supply(),
  #     advanced = input$is_adv
  #   ) %>% mutate(
  #     Measure = str_replace(Measure, pattern = "_", replacement = " ") %>% str_to_title()
  #   )
  # 
  # 
  # },width = "100%",bordered = TRUE, rownames = FALSE)
  
  
}