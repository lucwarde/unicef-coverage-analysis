# 01_data_cleaning.R
# Clean and merge ANC4, SBA, births and U5MR status for UNICEF D&A analysis


# ---- 1. Load and clean ANC4 + SBA data ----

# Indicators coverage from UNICEF Global Data Repository at the country level:https://data.unicef.org/resources/data_explorer/unicef_f/?ag=UNICEF&df=GLOBAL_DATAFLOW&ver=1.0&dq=.MNCH_ANC4+MNCH_SAB.&startPeriod=2018&endPeriod=2022 


coverage_full_data <- fread(file.path(dir_raw, "fusion_GLOBAL_DATAFLOW_UNICEF_1.0_all.csv"),   colClasses = 'character') 

# Clean column names, filter relevant indicators (2018–2022), and keep most recent estimate per country
coverage_full_clean_data <- coverage_full_data %>%
  rename_with(~ sub(":.*", "", .x)) %>%  # Clean column names
  select(country = REF_AREA, indicator = INDICATOR, year = TIME_PERIOD, coverage = OBS_VALUE) %>% 
  filter(str_sub(country, 4, 4) == ":") %>% # Keep only rows where the 4th character is ":" (ensures keep only country ")
  filter(indicator %in% c("MNCH_ANC4: Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider", 
                          "MNCH_SAB: Skilled birth attendant - percentage of deliveries attended by skilled health personnel")
         & year>="2018", year<="2022")%>%
  mutate(iso3 = str_sub(country, 1, 3)) %>%
  filter(!is.na(iso3)) %>% 
  arrange(iso3, indicator, desc(year)) %>% 
  distinct(iso3, indicator, .keep_all = TRUE) # keep most recent estimate per country



# ---- 2. Load births (2022 projections) ----


births_raw_data <- read_excel(file.path(dir_raw, "WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx"),    sheet = "Projections", skip = 16,  col_type = "text")

births_2022_data <- births_raw_data %>%
  filter(Year == "2022") %>%
  select(
    iso3 = `ISO3 Alpha-code`,
    births_2022_thousands = `Births (thousands)`
  ) %>%
  filter(!is.na(iso3)) %>%
  mutate(births_2022 = as.numeric(births_2022_thousands) * 1000) %>%
  select(iso3, births_2022)


# ---- 3. Load on-track / off-track status ----


class_mort_data <- read_excel(file.path(dir_raw, "On-track and off-track countries.xlsx"),   col_type = "text") %>%
  rename(iso3 = ISO3Code) %>%
  mutate(group = case_when(
    str_to_lower(Status.U5MR) %in% c("achieved", "on-track") ~ "on-track",
    str_to_lower(Status.U5MR) == "acceleration needed" ~ "off-track",
    TRUE ~ NA_character_
  )) %>%
  select(iso3, OfficialName, group)


# ---- 4. Merge datasets (full join to keep everything) ----

df_merge <- coverage_full_clean_data %>%
  full_join(births_2022_data, by = "iso3") %>%
  full_join(class_mort_data, by = "iso3")


# ---- 5. Save outputs ----

# Save as CSV and RDS
write_csv(df_merge, file.path(dir_clean, "cleaned_data.csv"))
saveRDS(df_merge, file.path(dir_clean, "cleaned_data.rds"))



