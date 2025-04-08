macc_byTech_updated = function(macc_df, 
                       sectorSelect=NULL, 
                       sourceSelect=NULL, 
                       yearSelect=2030, 
                       priceMax=100,
                       versionSelect=2024,
                       legendOFF=TRUE) {
  
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
    macc_prep(mac = p, abatement = q_total) 
  
  # if(min(macc_prepped$mac < -300)) {
  #   macc_prepped <- macc_prepped %>%
  #     mutate(mac = case_when(macc_prepped$mac < -300 ~ .,
  #                            TRUE ~ macc_prepped$mac))
  # }
  
  #yaxis_min = -300
  
  fig = macc_prepped %>%
    ggplot() +
    geom_rect(aes(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax, fill = tech_long)) +
    #facet_grid(year~.) +
    #facet_wrap(~year) +
    scale_fill_discrete(guide = guide_legend()) +
    theme(legend.position="bottom") +
    labs(y = "Price ($/tCO2e)",
         x = "Mitigation (Mt CO2e)",
         title = title,
         fill = "Technology")
  if(legendOFF) {fig = fig + theme(legend.position='none')}
  
  # if(!is.null(sectorSelect)) {
  #   ggsave(paste0("../output/macc_byTech/sectors/",sectorSelect,"_",yearSelect,"_v",versionSelect,".png"), width = 10, height = 10,
  #          create.dir = TRUE)
  #   print(paste("Figure created for",sectorSelect))}
  # if(!is.null(sourceSelect)) {
  #   ggsave(paste0("../output/macc_byTech/sources/",sourceSelect,"_",yearSelect,"_v",versionSelect,".png"), width = 10, height = 10,
  #          create.dir = TRUE)
  #   print(paste("Figure created for",sourceSelect))}
  
  # added from macc_qa_qc_2024_data_chart_fixes.Rmd
  
  if(is.null(sourceSelect) & sectorSelect == "AGRICULTURE") {
    {rlang::inform(message = "Creating split graphs for the Agriculture sector")}
    # macc_prepped_facet = macc_prepped %>%
    #   mutate(above_zero = case_when(p > 0 ~1,
    #                            TRUE ~ 0))
    # 
    # fig = macc_prepped_facet %>%
    #   ggplot() +
    #   geom_rect(aes(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax, fill = tech_long)) +
    #   #facet_grid(year~.) +
    #   facet_wrap(~above_zero) +
    #   scale_fill_discrete(guide = guide_legend()) +
    #   theme(legend.position="bottom") +
    #   labs(y = "Price ($/tCO2e)",
    #        x = "Mitigation (Mt CO2e)",
    #        title = title,
    #        fill = "Technology")
    # 
    # if(legendOFF) {fig = fig + theme(legend.position='none')}
    macc_prepped_upper = macc_prepped %>%
      mutate(ymin = 0)
    title = "Mitigation Above $0"

    fig_upper = macc_prepped_upper %>%
      ggplot() +
      geom_rect(aes(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax, fill = tech_long)) +
      facet_grid(year~.) +
      scale_fill_discrete(guide = guide_legend()) +
      theme(legend.position="none") +
      labs(y = "Price ($/tCO2e)",
           x = "Mitigation (Mt CO2e)",
           title = title,
           fill = "Technology")

  macc_prepped_lower = macc_prepped %>%
    dplyr::filter(ymax == 0) %>%
    dplyr::filter(ymin >= -1000)
  #mutate(ymax = 0)
  #title =  c(sectorSelect, ": Mitigation At or Below $0")
  title = "No Cost Mitigation"

  fig_lower = macc_prepped_lower %>%
    ggplot() +
    geom_rect(aes(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax, fill = tech_long)) +
    facet_grid(year~.) +
    #xlim(0, 500) +
    #ylim(min(macc_prepped$ymin), 0) +
    scale_fill_discrete(guide = guide_legend()) +
    theme(legend.position="none") +
    labs(y = "Price ($/tCO2e)",
         x = "Mitigation (Mt CO2e)",
         title = title,
         fill = "Technology")

  # https://stackoverflow.com/questions/59017349/apply-a-function-for-creating-cowplots-on-a-list-of-ggplots-with-4-plots-each-ti
  fig = plot_grid(fig_lower, fig_upper, labels = "AUTO") # from cowplot
  #grid.arrange(fig_upper, fig_lower, ncol=2) # from grid.arrange
  
  if(legendOFF) {fig = fig + theme(legend.position='none')}
  
}

  return(fig)
  # end added
  

  
} # end of the function