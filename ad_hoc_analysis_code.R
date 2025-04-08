

# check by source by state

macc_state %>%
  ggplot()

library(tidyverse)
library(ggplot2)
library(ggmacc)

df_summarized = macc_state %>%
  dplyr::filter(year == 2030) %>%
  dplyr::filter(sector == "WASTE") %>%
  group_by(sector, year, p, tech, tech_long) %>% 
  summarize(q_total = sum(q_total), .groups = "drop")

macc_prepped <- df_summarized %>%
  macc_prep(mac = p, abatement = q_total)

fig = macc_prepped %>%
  ggplot() +
  geom_rect(aes(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax, fill = tech_long)) +
  #facet_grid(year~.) +
  facet_wrap(~year) +
  scale_fill_discrete(guide = guide_legend()) +
  theme(legend.position="bottom") +
  labs(y = "Price ($/tCO2e)",
       x = "Mitigation (Mt CO2e)",
       #title = title,
       fill = "Technology") + 
  theme(legend.position='none')