# user_profile.R
# ----------------------
# Set up environment to ensure portability and reproducibility
# ----------------------

# Load 'here' package early for path management
if (!require("here")) install.packages("here")
library(here)

# List of required packages
required_packages <- c(
  "tidyverse",
  "tidylog",
  "data.table",
  "readxl",
  "janitor",
  "scales",
  "here",
  "rmarkdown"
)

# Install missing packages
installed <- rownames(installed.packages())
for (pkg in required_packages) {
  if (!(pkg %in% installed)) {
    install.packages(pkg)
  }
}

# Load all required packages
invisible(lapply(required_packages, library, character.only = TRUE))

# Global options
options(stringsAsFactors = FALSE)
options(scipen = 999)

# Define folders using here()
dir_raw    <- here("01_rawdata")
dir_clean  <- here("02_cleaned")
dir_script <- here("03_scripts")
dir_output <- here("04_output")

# Create output folders if they don't exist
dirs <- c(dir_clean, dir_output)
for (d in dirs) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

message("Environment setup completed")