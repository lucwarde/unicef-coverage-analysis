# run_project.R
# This script runs the full workflow end-to-end

# 1. Load environment and project settings
source("user_profile.R")

# 2. Run data cleaning and analysis scripts
source(file.path(dir_script, "01_data_cleaning.R"))
source(file.path(dir_script, "02_analysis.R"))

# 3. Render final report
rmarkdown::render(
  input = file.path(dir_script,"03_report.Rmd"),
#  output_file = "03_report.html", 
  output_dir = dir_report_output,
  output_format = "all"
)

# ⚠️ If PDF rendering fails due to LaTeX block quote compatibility issues,
# run the report in HTML only by using the alternative below:

# rmarkdown::render(
#   input = file.path(dir_script, "03_report.Rmd"),
#   output_file = "03_report.html",
#   output_dir = dir_report_output
# )