COVID-19 in Lithuania: Age cohort graphs
================

<summary>

``` r
lt_natl_ve_data <- tibble(lt_vacc_eff_data) %>%
  #select(-object_id) %>%
  group_by(date, sex, age_gr) %>%
  summarise(across(matches('[icr]\\d[icr]\\d$'), ~ sum(.x, na.rm=TRUE))) %>%
  ungroup()

lt_pop <- 2795680

# library(covidregionaldata)
# get_regional_data("Lithuania") %>% select(cases_new,date) %>% filter(date < ymd("2021-01-01")) %>% summarise(cases=sum(cases_new))
cases_in_2020 <- 147984

r0_init <- lt_pop - cases_in_2020

infection_comparisons <- lt_natl_ve_data %>%
  # select(date, age_gr, sex,
  #        r0i0, r1i1, r2i2, r3i3, # infection events
  #        r1r2, r2r3  # vaccination transitions
  #        ) %>%
  #filter(date == "2021-10-18") %>%
  group_by(date) %>%
  #select(-date)%>%
  summarise(across(matches('[icr]\\d[icr]\\d$'), ~ sum(.x, na.rm=TRUE))) %>%
  mutate(partially = (r1i1+r1i2) / (r0i0+r0i1+r1i1+r1i2+r2i2+r2i3+r3i3),
         fully = (r2i2+r2i3+r3i3) / (r0i0+r0i1+r1i1+r1i2+r2i2+r2i3+r3i3)) %>%
  ungroup() %>%
  # calculate populations in each category
  mutate(
    censored = r0c0+r0c1+r1c1+r1c2+r2c2+r2c3+r3c3, # per day
    infected = r0i0+r0i1+r1i1+r1i2+r2i2+r2i3+r3i3, # per day
    r_pop = r0_init - cumsum(censored + infected),
    r_pop_r1 = cumsum(r0r1-r1r2-r1i1-r1c1-r1i2-r1c2),
    r_pop_r2 = cumsum(r1r2-r2r3-r2i2-r2c2-r2i3-r2c3),
    r_pop_r3 = cumsum(r2r3-r3c3-r3i3),
    r_pop_r0 = r0_init - r_pop_r1 - r_pop_r2 - r_pop_r3) %>%
  # fractions of each population infected
  mutate(
    i_frac_r0 = (r0i0+r0i1) / r_pop_r0,
    i_frac_r1 = (r1i1+r1i2) / r_pop_r1,
    i_frac_r2 = (r2i2+r2i3) / r_pop_r2,
    i_frac_r3 = (r3i3) / r_pop_r3
  ) %>%
  mutate(
    ve_vs_r0_r1 =  (i_frac_r0 - i_frac_r1)/i_frac_r0,
    ve_vs_r0_r2 = (i_frac_r0 - i_frac_r2)/i_frac_r0, #i_frac_r2 / i_frac_r0,
    ve_vs_r0_r3 = if_else(r_pop_r3 != 0,(i_frac_r0 - i_frac_r3)/i_frac_r0, NA_real_)
  ) %>%
  pivot_longer(
    cols = !c("date"),
    values_to = "count",
    names_to = "event")
```

</summary>

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

![](/covidregionaldatagraphs/images-cases_graph_contributions-1.png)<!-- -->

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

![](/covidregionaldatagraphs/images-cases_graph_fractions-1.png)<!-- -->

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

![](/covidregionaldatagraphs/images-cases_by_status_proportional-1.png)<!-- -->

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

![](/covidregionaldatagraphs/images-vaccine_effectiveness_7d-1.png)<!-- -->

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

![](/covidregionaldatagraphs/images-vaccine_effectiveness_14d-1.png)<!-- -->
