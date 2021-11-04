



ui <- dashboardPage(
  dashboardHeader(
    title = "Interactive Economics V1.0"),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      
      menuItem(
        text = "Supply and Demand", tabName = "supdem", icon = icon("dashboard")
      ),
      
      
      
      
      sliderInput(
        inputId = "demand_elasticity",
        value = 2,
        min = 0.1,
        max = 5,
        animate = TRUE,
        label = "Demand Elasticity",ticks = FALSE,
        step = 0.1
      ),
      
      sliderInput(
        inputId = "supply_elasticity",
        value = 2,
        min = 0.1,
        max = 5,
        animate = TRUE,
        label = "Supply Elasticity",ticks = FALSE,
        step = 0.1
      ),
      
      
      # This user input determines whether
      # the program outputs ALL measures
      # like CS/PS/DWL and Total Welfare
      # NOTE: This is false by default.
      
      checkboxInput(
        inputId = "is_adv",
        value = FALSE,
        label = "Advanced"
      ),
      
      
      checkboxGroupInput(
        inputId = "side",
        label   = "Choose Side:",
        choices = c(
          "Demand-side" = "d_side",
          "Supply-side"  = "s_side"
        ),inline = FALSE
      ),
      
      
      # Taxation
      # TODO: Change these
      # to sliders.
      sliderInput(
        inputId = "lumpsump_tax",
        label = "Lump Sump",
        min = 0,
        max = 10,
        value = 0,ticks = FALSE
      ),
      
      sliderInput(
        inputId = "unit_tax",
        label = "VAT",
        min = 0,
        max = 1,
        value = 0,ticks = FALSE
      ),
      
      # Shock
      checkboxGroupInput(
        inputId = "shock",
        label   = "Shock:",
        choices = c(
          "Positive" = "pos",
          "Negative"  = "neg"
        )
      )
    )
  ),
  
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "supdem",
        
        column(
          width = 12,
          box(
            title = "Information",
            width = 12,
            solidHeader = TRUE,
            collapsible = TRUE,
            collapsed = TRUE,status = "warning",
            
            p(
              "This is an interactive webapplication built under the GPL 2 license. Bugs, suggestions and errors can be submitted at the",
              a(href = "https://github.com/serkor1/economics101", "Github Repository."),
              "If you are a Student, or teacher, at Niels Brock please contact me by mail."
            )
            
            
          )
          
        ),
        
        
        
        column(
          width = 12,
          
        
          
          box(
            title = "Perfect Competition",
            width = 6,
            solidHeader = TRUE,
            status = "primary",
            
            plotlyOutput(
              "baseline_sd"
            ),
            
            hr(),
            
            tableOutput(
              "baseline_table"
            )
            
            
          ),
          
          box(
            title = "Perfect Competition with Intervention",
            width = 6,
            solidHeader = TRUE,
            status = "primary",
            plotlyOutput(
              "complex_sd"
            ),
            
            hr(),
            
            tableOutput(
              "complex_table"
            )
          )
        )
        
  
        
        
      )
    )
  )
)