# UNICEF D&A Consultancy Assessment – ANC4 and SBA Coverage Analysis

This repository contains the full workflow developed as part of the technical assessment for the following UNICEF consultancy positions:

-   Learning and Skills Data Analyst Consultant (#581598)\
-   Household Survey Data Analyst Consultant (#581656)\
-   Administrative Data Analyst Consultant (#581696)\
-   Microdata Harmonization Consultant (#581699)

------------------------------------------------------------------------

## 🧭 Project Structure

```         
├── 01_rawdata/           # Raw input files: coverage, births, classification
├── 02_cleaned/           # Cleaned and merged intermediate datasets
├── 03_scripts/           # Main R scripts for cleaning, analysis, and reporting
├── 04_output/            
│   ├── 01_report_output/ # Final HTML/PDF/Word reports
│   └── 02_data_output/   # Saved processed data objects (RDS)
├── 05_documents/         # Supporting documents (metadata, notes, README)
├── user_profile.R        # Centralized environment: paths, packages, settings
├── run_project.R         # Master script to run the full pipeline
└── README.md             # Project overview (this file)
```

------------------------------------------------------------------------

## 🚀 How to Run the Project

1.  Clone the repository locally.
2.  Open the RStudio project.
3.  Run the main script:

``` r
source("run_project.R")
```

This will:

\- Load all required packages and paths via `user_profile.R`

\- Clean and merge input data (`01_data_cleaning.R`)

\- Compute weighted stats and prepare outputs (`02_analysis.R`) - Generate the final report in **HTML**, **PDF**, and **Word** (`03_report.Rmd`)

> ❗ **PDF rendering issues with block quotes**\
> If the LaTeX compilation fails due to block quote compatibility, you can temporarily disable PDF rendering by commenting out `output_format = "all"` and using HTML only, as shown in the alternate block in `run_project.R`.

------------------------------------------------------------------------

## 🧾 Data Sources

-   **Coverage indicators** (ANC4, SBA):\
    [UNICEF Global Data Repository](https://data.unicef.org/resources/data_explorer/unicef_f/?ag=UNICEF&df=GLOBAL_DATAFLOW&ver=1.0&dq=.MNCH_ANC4+MNCH_SAB.&startPeriod=2018&endPeriod=2022)

-   **Under-five mortality classification**:\
    [UNICEF U5MR Overview](https://data.unicef.org/topic/child-survival/under-five-mortality/)

-   **Birth estimates**:\
    *UN World Population Prospects 2022*

-   **Indicator metadata**:

    -   [ANC4 – WHO](https://www.who.int/data/gho/indicator-metadata-registry/imr-details/80)\
    -   [SBA – WHO](https://data.who.int/indicators/i/F835E3B/1772666)\
    -   [SDG 3.1.1 – Maternal Mortality](https://unstats.un.org/sdgs/metadata/files/Metadata-03-01-01.pdf)\
    -   [SDG 3.1.2 – Skilled Birth Attendance](https://unstats.un.org/sdgs/metadata/files/Metadata-03-01-02.pdf)\
    -   [SDG 3.2.1 – Under-Five Mortality](https://unstats.un.org/sdgs/metadata/files/Metadata-03-02-01.pdf)\
    -   [SDG 3.2.2 – Neonatal Mortality](https://unstats.un.org/sdgs/metadata/files/Metadata-03-02-02.pdf)

------------------------------------------------------------------------

## 🔧 Requirements

-   R ≥ 4.1
-   Required packages (automatically loaded in `user_profile.R`): `tidyverse`, `knitr`, `kableExtra`, `rmarkdown`, `scales`, `plotly`

------------------------------------------------------------------------

## 📬 Contact

This repository was prepared as part of a technical assessment and should not include author names as per submission instructions.
