COVID-19 in Lithuania: Age cohort graphs
================

These charts are drawn using data published by the [Official Statistics
Portal](https://osp.stat.gov.lt/pradinis) (OSP) on their [COVID-19 open
data](https://experience.arcgis.com/experience/cab84dcfe0464c2a8050a78f817924ca/page/page_5/)
site, along with the [annual population counts for Lithuanian
municipalities](https://osp.stat.gov.lt/en_GB/gyventojai1), also
published by the OSP.

Because the age cohorts given in the two sources do not align, when
calculating COVID rates relative to age cohorts, a smaller number of
larger cohorts is used.

<summary>

``` r
age_bands_municipalities <- tibble(lt_aggregate) %>%
#  select(-object_id) %>%
  mutate(date = as_date(date)) %>%
  group_by(municipality_name, date, age_gr) %>%
  summarise(across(where(is.numeric), ~ sum(.x, na.rm=TRUE))) %>%
  ungroup()

age_bands <- age_bands_municipalities %>%
  group_by(date, age_gr) %>%
  summarise(across(where(is.numeric), ~ sum(.x, na.rm=TRUE)))

natl_age_data <-  lt_age_sex_data %>%
  filter( location == "Total" ) %>%
  select(-location) %>%
  pivot_longer(
    cols = !"total",
    values_to = "count",
    names_to = "age_range") %>%
  mutate_if(is.character, str_remove_all, pattern = "\\d+[^\\d]") %>%
  mutate(age_range = as.numeric(age_range)) %>%
  mutate(age_range = replace_na(age_range, 85)) %>%
  mutate(cohort = cut(age_range,
                      c(0, 9, 19, 29, 39, 49, 59, 69, 79, 89 ),
                      c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+"),
                      include.lowest = TRUE)) %>%
  select(-age_range,-total) %>%
  group_by(cohort) %>%
  summarise(count = sum(count))

lt_age_data <- lt_age_sex_data %>%
  filter(grepl("mun.$", location)) %>%
  pivot_longer(
    cols = !c("location","total"),
    values_to = "count",
    names_to = "age range") %>%
  mutate_if(is.character, str_replace_all, pattern = " mun.", replacement = "")
age_band_factors <- age_bands %>%
  mutate(cohort = case_when(
    age_gr == "80-89" ~ "80+",
    age_gr == "90-99" ~ "80+",
    age_gr == "Centenarianai" ~ "80+",
    age_gr == "Nenustatyta" ~ NA_character_,
    TRUE ~ age_gr
  )) %>%
  filter(!is.na(cohort)) %>%
  select(-age_gr) %>%
  group_by(date, cohort) %>%
  summarise(across(where(is.numeric), ~ sum(.x, na.rm=TRUE))) %>%
  ungroup()

per_capita_rates <- left_join(age_band_factors, natl_age_data, by = c("cohort")) %>%
  mutate(population = count,
         cases_per_100k = new_cases / count * 100000,
         deaths_all_per_mill = deaths_all / count * 1000000) %>%
  select(-count)
```

</summary>

![](/lt_covid_calcs/images/age_band_graphs-1.png)<!-- -->

![](/lt_covid_calcs/images/cohort_prevalance_cases_cumulative-1.png)<!-- -->

![](/lt_covid_calcs/images/cohort_prevalance_cases_mean-1.png)<!-- -->

![](/lt_covid_calcs/images/cohort_prevalance_deaths_mean-1.png)<!-- -->
