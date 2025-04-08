prep_macc_file <- function(df,
                           versionSelect = 2024) {
  # Read in country code mapping
  country_map = read_csv("data/country_map.csv") %>%
    rename(country_code = r)
  
  if(versionSelect == 2024){
    # Read in global MACC data
    macc_df = df %>%
      mutate(version = versionSelect) %>%
      left_join(country_map, by="country") %>%
      dplyr::select(-country_code.y) %>%
      rename(country_code = country_code.x)
  } else {
    macc_df = df %>%
      mutate(version = versionSelect) %>%
      rename(country_code = country) %>%
      select(-q_dsoc) %>% 
      left_join(country_map, by = "country_code") #%>%
      #select(names(macc_2024))
  }
}