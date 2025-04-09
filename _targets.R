library(targets)
library(tarchetypes) #has tar_render #Load other packages as needed.

source("packages.R")

# Set target options:
tar_option_set(
  packages = c("tibble", "tidyverse", "ggmacc"),
  error = "abridge"
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  # 2019 mitigation data
  #tar_target(macc_2019_report_data, "read_xlsx("../data/MACC_Gas_Tech_Intl with proj and pivot_2019.xlsx", sheet = "Mitigation - Raw Data")")
  
  # 2024 mitigation data
  #tar_target(MACC_01302025, "data/MACC_01302025.csv", format = "file"),
  #tar_target(raw_macc_2024, read_csv(MACC_01302025)),
  
  # state data
  tar_target(MACC_STATE_03262025, "data/MACC_STATE_03262025.csv", format = "file"),
  tar_target(current_data, read_csv(MACC_STATE_03262025)),
  
  #track functions
  #tar_target(tech_function, "R/macc_byTech_updated.R", format = "file"),
  
  # combine the source datasets to create mitigation graphs for gases by source
  # tar_target(lan_file, "data/LAN_01172025.csv", format = "file"),
  # tar_target(col_file, "data/COL_01172025.csv", format = "file"),
  # tar_target(gas_file, "data/GAS_01172025.csv", format = "file"),
  # tar_target(live_file, "data/LIVE_01172025.csv", format = "file"),
  # tar_target(rice_file, "data/RICE_01172025.csv", format = "file"),
  # tar_target(wwr_file, "data/WWR_01172025.csv", format = "file"),
  # 
  # tar_target(lan_data, read_csv(lan_file)), 
  # tar_target(col_data, read_csv(col_file)), 
  # tar_target(gas_data, read_csv(gas_file)),
  # tar_target(live_data, read_csv(live_file)),
  # tar_target(rice_data, read_csv(rice_file)),
  # tar_target(wwr_data, read_csv(wwr_file)),
  # 
  # combine datasets
  # combined_sources <- lan_data %>%
  #   rbind(col_data) %>%
  #   rbind(gas_data) %>%
  #   rbind(live_data) %>%
  #   rbind(rice_data) %>%
  #   rbind(wwr_data), 
  
  # Crosswalks and Maps ----
  
  
  #tar_target(clean_macc_2024, prep_macc_file(raw_macc_2024, 2024)),
  
  # tar_render(pdf_figs,
  #            "docs/macc_curves.Rmd",
  #            output_dir = 'output/',
  #            output_file = paste0("macc_curves_",Sys.Date(),"updated.html"),
  #            params = list(mode = "targets")),
  
  # tar_invalidate(pdf_figs)
  tar_render(pdf_figs,
             "docs/macc_curves_state.Rmd",
             output_dir = 'output/',
             output_file = paste0("macc_curves_state_",Sys.Date(),"_updated.html"),
             params = list(mode = "targets"))
)
