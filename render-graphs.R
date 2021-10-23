
# Render age breakdowns
rmarkdown::render(
  "Lithuanian age breakdowns.Rmd",
  output_format = "github_document",
  output_dir = "docs",
  output_options = list(
    output_format = "github_document",
    self_contained = FALSE
  ),
  params = list(
    prepared_by = "github.com/RichardMN/lt_covid_calcs"
  )
  #output_file = paste0("COVID-19 regional graphs - Lithuania-specific.md")
)

rmarkdown::render(
  "Lithuanian breakthrough calculations.Rmd",
  output_format = "github_document",
  output_dir = "docs",
  output_options = list(
    output_format = "github_document",
    self_contained = FALSE
  ),
  params = list(
    prepared_by = "github.com/RichardMN/lt_covid_calcs"
  )
  #output_file = paste0("COVID-19 regional graphs - Lithuania-specific.md")
)
