macc_bySource_gas = function(combined_df, 
                           #sectorSelect=NULL, 
                           #sourceSelect=NULL, 
                           yearSelect=2030, 
                           priceMin = -400,
                           priceMax=100,
                           versionSelect=2024,
                           gasSelect = ch4,
                           legendOFF=TRUE) {
  
  #  if(length(sectorSelect)>1) {rlang::abort(message = "This function can only handle one sector at a time")}
  #  if(length(sourceSelect)>1) {rlang::abort(message = "This function can only handle one source at a time")}
  
  df_filtered = combined_df %>%
    filter(year == yearSelect &
             p > priceMin & p <= priceMax) #& # priceMax &
  #versionSelect == 2024) # %in% version)
  
  # if(!is.null(sectorSelect)) {
  #   df_filtered = df_filtered %>%
  #     filter(sector %in% sectorSelect)
  #   title = sectorSelect
  # }
  
  # if(!is.null(sourceSelect)) {
  #   df_filtered = df_filtered %>%
  #     filter(source %in% sourceSelect)
  #   title = sourceSelect
  # }
  
  if(gasSelect == "ch4"){
    title = "Methane"
    df_summarized = df_filtered %>%
      group_by(sector, source, year, p) %>% # , tech, tech_long
      summarize(q_ch4 = sum(q_ch4), .groups = "drop")
    
    macc_prepped <- df_summarized %>%
      macc_prep(mac = p, abatement = q_ch4)
    
  } else if(gasSelect == "n2o"){
    title = "Nitrous Oxide"
    df_summarized = df_filtered %>%
      group_by(sector, source, year, p) %>% # , tech, tech_long
      summarize(q_n2o = sum(q_n2o), .groups = "drop")
    
    macc_prepped <- df_summarized %>%
      macc_prep(mac = p, abatement = q_n2o)
  }
  
  
  fig = macc_prepped %>%
    ggplot() +
    geom_rect(aes(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax, fill = source)) +
    facet_grid(year~.) +
    scale_fill_discrete(guide = guide_legend()) +
    theme(legend.position="bottom") +
    labs(y = "Price ($/tCO2e)",
         x = "Mitigation (Mt CO2e)",
         title = title,
         fill = "Source")
  
  if(legendOFF) {fig = fig + theme(legend.position='none')}
  
  # if(!is.null(sectorSelect)) {
  #   ggsave(paste0("output/macc_byTech/sectors/",sectorSelect,"_",yearSelect,"_v",versionSelect,"_ch4.png"), width = 10, height = 10,
  #          create.dir = TRUE)
  #   print(paste("Figure created for",sectorSelect,"- methane"))}
  # if(!is.null(sourceSelect)) {
  #   ggsave(paste0("output/macc_byTech/sources/",sourceSelect,"_",yearSelect,"_v",versionSelect,"_ch4.png"), width = 10, height = 10,
  #          create.dir = TRUE)
  #   print(paste("Figure created for",sourceSelect,"- methane"))}
  
  ggsave(paste0("output/macc_bySource/gases/",yearSelect,"_v",versionSelect,"_",gasSelect,".jpg"), width = 10, height = 10,
         create.dir = TRUE)
  print(paste("Figure created for methane"))
  
 # print(fig)
  return(fig)
  
}