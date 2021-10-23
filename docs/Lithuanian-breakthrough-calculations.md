COVID-19 in Lithuania: Vaccinations status and incidence, vaccine
effectiveness
================

``` r
infection_comparisons %>%
  group_by(event) %>%
  mutate(pc_cases_7d_mean = zoo::rollmean(count,k=7, fill=0, align="right") ) %>%
  ungroup() %>%
  filter(event %in% c("r0i0", "r0i1", "r1i1", "r1i2", "r2i2", "r2i3", "r3i3")) %>%
  filter(date > ymd("2021-01-7")) %>%
  ggplot(aes(x = date, y=pc_cases_7d_mean, colour=event)) +
  theme_minimal() +
  geom_line(size=1) +
  #scale_fill_brewer(palette = "Set2") +
  scale_colour_viridis_d(name = "Individual\nvaccination\nstatus",
                         breaks = c("r0i0", "r0i1", "r1i1", "r1i2", "r2i2", "r2i3", "r3i3"),
                         labels = c("Unvaccinated or\nless than 14d\nafter 1st dose",
                                    "14d after\n1st dose",
                                    "14+d after\n1st dose",
                                    "14d after\n2nd dose",
                                    "14+d after\n2nd dose",
                                    "14d after\n3rd dose",
                                    "14+d after\n3rd dose")) +
  theme(legend.position = "bottom") +
  scale_y_continuous(sec.axis = sec_axis(~ .)) +
  labs(title="Lithuania - COVID-19 cases by vaccination status",
       subtitle="7 day rolling average",
       y="New cases",
       x="Date",
       caption="Richard Martin-Nielsen | Data: Office of Statistics Portal osp.stat.gov.lt") +
  scale_x_date()
```

![](/lt_covid_calcs/images/cases_graph_contributions-1.png)<!-- -->

``` r
infection_comparisons %>%
  group_by(event) %>%
  mutate(pc_cases_7d_mean = zoo::rollmean(count,k=7, fill=0, align="right") ) %>%
  ungroup() %>%
  filter(event %in% c("partially", "fully")) %>%
  #filter(date > ymd("2020-11-01")) %>%
  ggplot(aes(x = date, y=pc_cases_7d_mean, colour=event)) +
  theme_minimal() +
  geom_line(size=1) +
  #scale_fill_brewer(palette = "Set2") +
  scale_colour_viridis_d(name = "Vaccination status",
                         breaks = c("partially", "fully"),
                         labels = c("Partially", "Fully")) +
  theme(legend.position = "bottom") +
  scale_y_continuous( labels = scales::percent,
                      sec.axis = sec_axis(~ ., labels = scales::percent)) +
  labs(title="Lithuania - COVID-19 cases by vaccination status",
       subtitle="7 day rolling average as fraction of total infections",
       y="New cases",
       x="Date",
       caption="Richard Martin-Nielsen | Data: Office of Statistics Portal osp.stat.gov.lt") +
  scale_x_date()
```

![](/lt_covid_calcs/images/cases_graph_fractions-1.png)<!-- -->

``` r
infection_comparisons %>%
  group_by(event) %>%
  mutate(pc_cases_7d_mean = zoo::rollmean(count,k=7, fill=0, align="right")*1000 ) %>%
  ungroup() %>%
  filter(event %in% c("i_frac_r0", "i_frac_r1", "i_frac_r2", "i_frac_r3")) %>%
  filter(date > ymd("2021-03-01")) %>%
  ggplot(aes(x = date, y=pc_cases_7d_mean, colour=event)) +
  theme_minimal() +
  geom_line(size=1) +
  #scale_fill_brewer(palette = "Set2") +
  scale_colour_viridis_d(name = "Vaccination status (14 days after...)",
                         breaks = c("i_frac_r0", "i_frac_r1", "i_frac_r2", "i_frac_r3"),
                         labels = c("Unvaccinated",
                                    "First dose",
                                    "Second dose",
                                    "Booster")) +
  theme(legend.position = "bottom") +
  scale_y_continuous(sec.axis = sec_axis(~ .)) +
  labs(title="Lithuania - COVID-19 cases by vaccination status",
       subtitle="7 day average cases per 1000 population with that status",
       y="New cases",
       x="Date",
       caption="Richard Martin-Nielsen | Data: Office of Statistics Portal osp.stat.gov.lt") +
  scale_x_date()
```

![](/lt_covid_calcs/images/cases_by_status_proportional-1.png)<!-- -->

``` r
infection_comparisons %>%
  group_by(event) %>%
  mutate(pc_cases_7d_mean = zoo::rollmean(count,k=7, fill=0, align="right") ) %>%
  ungroup() %>%
  filter(event %in% c("ve_vs_r0_r1", "ve_vs_r0_r2", "ve_vs_r0_r3")) %>%
  filter(date > ymd("2021-03-01")) %>%
  filter(pc_cases_7d_mean<1) %>%
  ggplot(aes(x = date, y=pc_cases_7d_mean, colour=event)) +
  theme_minimal() +
  geom_line(size=1) +
  #scale_fill_brewer(palette = "Set2") +
  scale_colour_viridis_d(name = "Vaccination status (14 days after...)",
                         breaks = c("ve_vs_r0_r1", "ve_vs_r0_r2", "ve_vs_r0_r3"),
                         labels = c("First dose",
                                    "Second dose",
                                    "Booster")) +
  theme(legend.position = "bottom") +
  scale_y_continuous(
    sec.axis = sec_axis(
      ~ .,
      breaks = seq(from = 0, to = 1, by = 0.1),
      labels = scales::percent),
    limits = c(0,1),
    breaks = seq(from = 0, to = 1, by = 0.1),
    #limits = c(0,15),
    labels = scales::percent,
    oob = scales::oob_censor) +
  labs(title="Lithuania - COVID-19 vaccine effectiveness by vaccination status",
       subtitle="7 day mean compared with unvaccinated",
       y="Incidence within population relative to unvaccinated",
       x="Date",
       caption="Richard Martin-Nielsen | Data: Office of Statistics Portal osp.stat.gov.lt") +
  scale_x_date()
```

![](/lt_covid_calcs/images/vaccine_effectiveness_7d-1.png)<!-- -->

``` r
infection_comparisons %>%
  group_by(event) %>%
  mutate(pc_cases_14d_mean = zoo::rollmean(count,k=14, fill=0, align="right") ) %>%
  ungroup() %>%
  filter(event %in% c("ve_vs_r0_r1", "ve_vs_r0_r2", "ve_vs_r0_r3")) %>%
  filter(date > ymd("2021-03-01")) %>%
  filter(pc_cases_14d_mean<1) %>%
  ggplot(aes(x = date, y=pc_cases_14d_mean, colour=event)) +
  theme_minimal() +
  geom_line(size=1) +
  #scale_fill_brewer(palette = "Set2") +
  scale_colour_viridis_d(name = "Vaccination status (14 days after...)",
                         breaks = c("ve_vs_r0_r1", "ve_vs_r0_r2", "ve_vs_r0_r3"),
                         labels = c("First dose",
                                    "Second dose",
                                    "Booster")) +
  theme(legend.position = "bottom") +
  scale_y_continuous(
    sec.axis = sec_axis(
      ~ .,
      breaks = seq(from = 0, to = 1, by = 0.1),
      labels = scales::percent),
    limits = c(0,1),
    breaks = seq(from = 0, to = 1, by = 0.1),
    #limits = c(0,15),
    labels = scales::percent,
    oob = scales::oob_censor) +
  labs(title="Lithuania - COVID-19 vaccine effectiveness by vaccination status",
       subtitle="14 day mean",
       y="Vaccine effectiveness",
       x="Date",
       caption="Richard Martin-Nielsen | Data: Office of Statistics Portal osp.stat.gov.lt") +
  scale_x_date()
```

![](/lt_covid_calcs/images/vaccine_effectiveness_14d-1.png)<!-- -->
