
# COVID-19 in Lithuania: Vaccinations status and incidence, vaccine effectiveness

Lithuania’s Official Statistics Portal (OSP) is now issuing a lot of
data which indicates transitions (“events”) for individuals on each day,
aggregated by municipality (Lithuania has 60), gender and age cohort. I
am aggregating these figures further to generate national data to look
at how COVID-19 is now affecting vaccinated and unvaccinated
individuals.

All this comes with the caveats that I am working from OSP data but
these are my calculations and there may be errors. I am not an
epidemiologist. Straightforward presentation of case numbers have not
seen much adjustment.

Further calculations (towards estimated vaccine effectiveness) may have
error, including in calculations of the unvaccinated population, which
influences the estimate of the proportional incidence in the
unvaccinated population and thus the relative incidence in vaccinated
populations.

## Data source

These charts are drawn using data published by the [Official Statistics
Portal](https://osp.stat.gov.lt/pradinis) (OSP) on their [COVID-19 open
data](https://experience.arcgis.com/experience/cab84dcfe0464c2a8050a78f817924ca/page/page_5/)
site, along with the [annual population counts for Lithuanian
municipalities](https://osp.stat.gov.lt/en_GB/gyventojai1), also
published by the OSP.

The R markdown source is available as a [github
repo](https://github.com/RichardMN/lt_covid_calcs).

![](/lt_covid_calcs/images/cases_graph_contributions-1.png)<!-- -->

![](/lt_covid_calcs/images/cases_graph_fractions-1.png)<!-- -->

![](/lt_covid_calcs/images/cases_by_status_proportional-1.png)<!-- -->

![](/lt_covid_calcs/images/vaccine_effectiveness_7d-1.png)<!-- -->

![](/lt_covid_calcs/images/vaccine_effectiveness_14d-1.png)<!-- -->
