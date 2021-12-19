





ui <- dashboardPage(
  
  # Dashboard Header
  header =  dashboardHeader(
    title = "Supply and Demand",
    tags$li(
      class = "dropdown",
      tags$a(
        img(
          src = "GitHub-Mark-Light-32px.png",
          height = "16px",
          width = "16px"
          ),
      href = "https://github.com/serkor1/economics101",
      class = "my_class",
      "Github",
      target = "_blank"
      )
      )
    ),
  
  sidebar =  dashboardSidebar(
    minified = FALSE,
    
    
    
    
    sidebarMenu(
      id = "tabs",
      menuItem(
        text = "Application Controls",
        icon = icon("cog"),
        startExpanded = TRUE,
        
        
        pickerInput(
          inputId = "Id081",
          label = "Market Type", 
          choices = c("Perfect Competition" = "p_c", "Imperfect Competion" = "imp_c"),
          multiple = FALSE
        ),
        
        
        materialSwitch(
          inputId = "is_adv",
          label = "Advanced", 
          value = FALSE,
          status = "primary"
        ),
        
        materialSwitch(
          inputId = "hide_value",
          label = "Hide Axis Values?", 
          value = FALSE,
          status = "primary"
        ),
        
        br()
      ),
      
      
     
      
      
      
      menuItem(
        tabName = "parent",
        text = "Demand Side",
        icon = icon("cog"),
        startExpanded = TRUE,
        sliderInput(
          inputId = "demand_elasticity",
          value = 2,
          min = 0,
          max = 5,
          animate = FALSE,
          label = "Slope",
          ticks = FALSE,
          step = 0.1
        ),
        
        
        checkboxGroupButtons(
          inputId = "shock_dem",
          label = "Shock",
          choices = c("Positive" = "pos_dem", 
                      "Negative" = "neg_dem"),
          
          selected = NA,
          checkIcon = list(
            yes = tags$i(class = "fa fa-check-square", 
                         style = "color: steelblue"),
            no = tags$i(class = "fa fa-square-o", 
                        style = "color: steelblue"))
        ),
        
        conditionalPanel(
          condition = "input.is_adv",
          menuSubItem(text = "Tax Controls"),
          sliderInput(
            inputId = "lumpsump_tax",
            label = "Unit Tax",
            min = 0,
            max = 10,
            value = 0,
            ticks = FALSE
          ),
          
          sliderInput(
            inputId = "unit_tax",
            label = "Value Added Tax",
            min = 0,
            max = 1,
            value = 0,
            ticks = FALSE
          )
          
        ),
        
        br()
        
        
        
      ),
      
      
      menuItem(
        text = "Supply Side",
        icon = icon("cog"),
        startExpanded = TRUE,
        sliderInput(
          inputId = "supply_elasticity",
          value = 2,
          min = 0,
          max = 5,
          animate = TRUE,
          label = "Slope",
          ticks = FALSE,
          step = 0.1
        ),
        checkboxGroupButtons(
          inputId = "shock_sup",
          label = "Shock",
          selected = NA,
          choices = c("Positive" = "pos_sup", 
                      "Negative" = "neg_sup"),
          checkIcon = list(
            yes = tags$i(class = "fa fa-check-square", 
                         style = "color: steelblue"),
            no = tags$i(class = "fa fa-square-o", 
                        style = "color: steelblue"))
        ),
        
        
        conditionalPanel(
          condition = "input.is_adv",
          
          menuSubItem("Subsidies"),
          
          sliderInput(
            inputId = "unit_sub",
            label = "Unit Subsidy",
            min = 0,
            max = 10,
            value = 0,
            ticks = FALSE
          ),
          
          sliderInput(
            inputId = "vat_sub",
            label = "Value Added Subsidy",
            min = 0,
            max = 1,
            value = 0,
            ticks = FALSE
          ),
          
        ),
        
        br()
      ),
      
      
      menuItem(
        text = "Price Controls",startExpanded = TRUE,
        icon = icon("cog"),
        badgeLabel = "Soon"
      )
    )
  ),
  
  
  body = dashboardBody(
    column(
      width = 12,
      
      
      
      box(
        title = "Perfect Competition",
        width = 6,
        solidHeader = TRUE,
        status = "primary",
        
        plotlyOutput("baseline_sd"),
        
        hr(),
        
        tableOutput("baseline_table")
        
        
      ),
      
      box(
        title = "Perfect Competition with Intervention",
        width = 6,
        solidHeader = TRUE,
        status = "primary",
        plotlyOutput("complex_sd"),
        
        hr(),
        
        tableOutput("complex_table")
      )
    )
    )
)
