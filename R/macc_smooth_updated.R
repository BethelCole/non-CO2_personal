
macc_smooth_updated = function(macc_df, 
                       sectorSelect=NULL, 
                       sourceSelect=NULL, 
                       yearSelect=2030, 
                       priceMax=100,
                       #priceMin=NULL,
                       versionSelect=2024,
                       legendOFF=TRUE,
                       splitFig=FALSE) {
  
  if(length(sectorSelect)>1) {rlang::abort(message = "This function can only handle one sector at a time")}
  if(length(sourceSelect)>1) {rlang::abort(message = "This function can only handle one source at a time")}
  
  df_filtered = macc_df %>%
    filter(year == yearSelect &
             p <= priceMax &
             versionSelect %in% version)
  
  if(!is.null(sectorSelect)) {
    df_filtered = df_filtered %>%
      filter(sector %in% sectorSelect)
    title = paste(sectorSelect, yearSelect)
  }
  
  if(!is.null(sourceSelect)) {
    df_filtered = df_filtered %>%
      filter(source %in% sourceSelect)
    title = paste(sourceSelect, yearSelect)
  }
  
  df_summarized = df_filtered %>%
    group_by(sector, year, p, tech, tech_long) %>% 
    summarize(q_total = sum(q_total), .groups = "drop")
  
  macc_prepped <- df_summarized %>%
    macc_prep(mac = p, abatement = q_total) %>%
    select(-ymin, -ymax) %>%
    pivot_longer(cols = c("xmax","xmin"), names_to = "x_type", values_to = "x")
  
  fig = macc_prepped %>%
    ggplot() +
    geom_line(aes(x=x,y=p)) +
    scale_fill_discrete(guide = guide_legend()) +
    theme(legend.position="bottom") +
    labs(y = "Price ($/tCO2e)",
         x = "Mitigation (Mt CO2e)",
         title = title)
  
  if(splitFig==TRUE) {

    macc_prepped_upper = macc_prepped %>%
      #mutate(ymin = 0) %>%
      dplyr::filter(p > 0)
    
    title = "Mitigation Above $0 (max $100)"
    
    fig_upper = macc_prepped_upper %>%
      ggplot() +
      geom_line(aes(x=x,y=p)) +
      #facet_grid(year~.) +
      scale_fill_discrete(guide = guide_legend()) +
      theme(legend.position="none") +
      labs(y = "Price ($/tCO2e)",
           x = "Mitigation (Mt CO2e)",
           title = title)
    
    macc_prepped_lower = macc_prepped %>%
      dplyr::filter(p <= 0) %>%
      dplyr::filter(p >= -1000)
    #mutate(ymax = 0)
    #title =  c(sectorSelect, ": Mitigation At or Below $0")
    title = "No Cost Mitigation ($-1000 +)"
    
    fig_lower = macc_prepped_lower %>%
      ggplot() +
      geom_line(aes(x=x,y=p)) +
      #facet_grid(year~.) +
      #xlim(0, 500) +
      #ylim(min(macc_prepped$ymin), 0) +
      scale_fill_discrete(guide = guide_legend()) +
      theme(legend.position="none") +
      labs(y = "Price ($/tCO2e)",
           x = "Mitigation (Mt CO2e)",
           title = title)
    
    # https://stackoverflow.com/questions/59017349/apply-a-function-for-creating-cowplots-on-a-list-of-ggplots-with-4-plots-each-ti
    # https://stackoverflow.com/questions/1249548/side-by-side-plots-with-ggplot2/31223588#31223588
    fig = plot_grid(fig_lower, fig_upper, labels = "AUTO") # from cowplot
    #grid.arrange(fig_upper, fig_lower, ncol=2) # from grid.arrange
    
    if(legendOFF) {fig = fig + theme(legend.position='none')}
  }
    
  return(fig)
}

