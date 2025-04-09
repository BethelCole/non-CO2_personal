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
