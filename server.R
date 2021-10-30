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
    
    supply_function(
      shock = shock,
      coeff = as.numeric(input$supply_elasticity)
    )
    
    
    
    
  })
  
  
  demand <- reactive({
    
    shock <- NULL
    
    if (!is.null(input$side)) {
      
      if (input$side == "d_side"){
        
        shock = input$shock
        
        
      }
      
    }
    
    demand_function(
      shock = shock,
      coeff = as.numeric(input$demand_elasticity)
    )
    
    
    
    
  })
  
  
  
  
  
  
  # Baseline Plot
  output$baseline_sd <- renderPlotly(
      equilibrium_plot(
        demand = demand_function(coeff = as.numeric(input$demand_elasticity)),
        supply = supply_function(coeff = as.numeric(input$supply_elasticity))
      )
    )
  
  
  output$complex_sd <- renderPlotly({
    

    equilibrium_plot(
      demand = demand(),
      supply = supply()
    )
    
  }
   
  )
  
  
  
  
  output$baseline_table <- renderTable({
    
    stat_table(
      demand = demand_function(coeff = as.numeric(input$demand_elasticity)),
      supply = supply_function(coeff = as.numeric(input$supply_elasticity))
    ) %>% mutate(
      Measure = str_replace(Measure, pattern = "_", replacement = " ") %>% str_to_title()
    )
    
    
  },width = "100%",bordered = TRUE, rownames = FALSE)
  
  
}