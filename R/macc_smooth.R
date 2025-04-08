
macc_smooth = function(macc_df, 
                       sectorSelect=NULL, 
                       sourceSelect=NULL, 
                       yearSelect=2030, 
                       priceMax=100,
                       #priceMin=NULL,
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
    macc_prep(mac = p, abatement = q_total) %>%
    select(-ymin, -ymax) %>%
    pivot_longer(cols = c("xmax","xmin"), names_to = "x_type", values_to = "x")
  
  fig = macc_prepped %>%
    ggplot() +
    geom_line(aes(x=x,y=p)) +
    #facet_grid(year~.) +
    #facet_wrap(~year) +
    scale_fill_discrete(guide = guide_legend()) +
    theme(legend.position="bottom") +
    labs(y = "Price ($/tCO2e)",
         x = "Mitigation (Mt CO2e)",
         title = title)
  
  # if(!is.null(sectorSelect)) {
  #   ggsave(paste0("../output/macc_smooth/sectors/",sectorSelect,"_",yearSelect,"_v",versionSelect,".png"), width = 5, height = 5,
  #          create.dir = TRUE)
  #   print(paste("Figure created for",sectorSelect))}
  # if(!is.null(sourceSelect)) {
  #   ggsave(paste0("../output/macc_smooth/sources/",sourceSelect,"_",yearSelect,"_v",versionSelect,".png"), width = 5, height = 5,
  #          create.dir = TRUE)
  #   print(paste("Figure created for",sourceSelect))}
  
  #print(fig)
  return(fig)
}

