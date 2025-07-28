# 02_analysis.R
# Compute population-weighted ANC4 and SBA coverage by group



# ---- 1. Load data ----

df_merge <- readRDS(file.path(dir_clean, "cleaned_data.rds"))


# ---- 2. Preparation analysis----

## ---- Save excluded countries (missing data or group) ----
excluded_countries <- df_merge %>%
  group_by(iso3, OfficialName) %>%
  summarise(
    group_missing = all(is.na(group)),
    births_missing = all(is.na(births_2022)),
    coverage_missing = all(is.na(coverage)),
    fully_excluded = group_missing | births_missing | coverage_missing,
    .groups = "drop"
  ) %>%
  filter(fully_excluded) %>%
  select(iso3, OfficialName)

## ---- Filter for valid countries with complete data ----
df_final <- df_merge %>%
  select(-country) %>%
  filter(!is.na(group), !is.na(coverage), !is.na(births_2022)) %>%
  rename(country = OfficialName) %>%
  relocate(country, iso3)




## ---- Reshape to wide format (ANC4 + SBA in columns) ----

df_final_wide <- df_final %>%
  pivot_wider(
    id_cols = c(iso3,country, births_2022, group),
    names_from = indicator,
    values_from = coverage
  ) %>%
  rename(
    anc4_coverage = `MNCH_ANC4: Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider`,
    sba_coverage  = `MNCH_SAB: Skilled birth attendant - percentage of deliveries attended by skilled health personnel`
  ) %>% 
  mutate(
    anc4_coverage = as.numeric(anc4_coverage),
    sba_coverage = as.numeric(sba_coverage),
    births_2022 = as.numeric(births_2022)
  )

# ---- 3. Quality: Check NA and Missing Coverage ----

# Calculate % of countries excluded from the analysis
# => 27.4% of countries are missing due to data availability
round(
  100 * (excluded_countries %>% distinct(iso3) %>% nrow()) / 
    ((excluded_countries %>% distinct(iso3) %>% nrow()) + 
       (df_merge %>% distinct(iso3) %>% nrow())), 
  1
)

# Summarise missing data per group
# Highlights major gaps in ANC4 coverage for on-track countries
quality_summary <- df_final_wide %>%
  group_by(group) %>%
  summarise(
    n_total     = n(),
    n_anc4_na   = sum(is.na(anc4_coverage)),
    pct_anc4_na = round(100 * n_anc4_na / n_total, 1),
    n_sba_na    = sum(is.na(sba_coverage)),
    pct_sba_na  = round(100 * n_sba_na / n_total, 1),
    .groups = "drop"
  )
quality_summary



# Pivot wider to identify ANC4 and SBA coverage per country
df_wide_missing <- df_merge %>%
  mutate(indicator_short = case_when(
    grepl("ANC4", indicator) ~ "ANC4",
    grepl("SAB", indicator)  ~ "SBA",
    TRUE                     ~ NA_character_
  )) %>%
  select(iso3, OfficialName, group, indicator_short, coverage, births_2022) %>%
  pivot_wider(names_from = indicator_short, values_from = coverage)

# Identify reason for exclusion per country
excluded_countries_detailed <- df_wide_missing %>%
  filter(is.na(group) | is.na(ANC4) | is.na(SBA) | is.na(births_2022)) %>%
  mutate(reason = case_when(
    is.na(group) & is.na(ANC4) & is.na(SBA) & is.na(births_2022) ~ "Missing U5MR group, ANC4, SBA, and births",
    is.na(group) & is.na(ANC4) & is.na(SBA)                     ~ "Missing U5MR group, ANC4, and SBA",
    is.na(ANC4) & is.na(SBA)                                    ~ "Missing ANC4 and SBA",
    is.na(ANC4)                                                 ~ "Missing ANC4 only",
    is.na(SBA)                                                  ~ "Missing SBA only",
    is.na(group)                                                ~ "Missing group",
    is.na(births_2022)                                          ~ "Missing births",
    TRUE                                                        ~ "Other"
  ))

# Count and summarize
excluded_summary <- excluded_countries_detailed %>%
  count(reason, name = "n") %>%
  arrange(desc(n)) %>%
  mutate(pct = round(100 * n / sum(n), 1)) %>%
  rename(`Exclusion Reason` = reason,
         `# Countries` = n,
         `Share (%)` = pct)


# ---- 4. Summary Statistics by Group ----

summary_group <- df_final_wide %>%
  group_by(group) %>%
  summarise(
    n_countries = n(),
    anc4_mean = mean(anc4_coverage, na.rm = TRUE),
    sba_mean = mean(sba_coverage, na.rm = TRUE),
    anc4_missing = sum(is.na(anc4_coverage)),
    sba_missing = sum(is.na(sba_coverage)),
    .groups = "drop"
  )


# ---- 5. Weighted Averages ----


# 4a. By group
results_group <- df_final_wide %>%
  group_by(group) %>%
  summarise(
    anc4_weighted = weighted.mean(anc4_coverage, births_2022, na.rm = TRUE),
    sba_weighted  = weighted.mean(sba_coverage, births_2022, na.rm = TRUE),
    .groups = "drop"
  )
results_group

# 4b. By country
results_country <- df_final_wide %>%
  mutate(
    anc4_weighted = anc4_coverage,  # Already weighted at country level
    sba_weighted  = sba_coverage
  ) %>%
  select(iso3, country, group, anc4_weighted, sba_weighted)
results_country


# ---- 6. Top 10 Countries with Lowest ANC4 ----

top10_anc4 <- df_final_wide %>%
  filter(!is.na(anc4_coverage)) %>%
  arrange(anc4_coverage) %>%
  slice_head(n = 10) %>%
  select(iso3, country, group, anc4_coverage)

# Create top 10 list of countries with lowest combined ANC4 + SBA coverage
df_top10_combined <- df_final_wide %>%
  filter(!is.na(anc4_coverage), !is.na(sba_coverage)) %>%
  mutate(mean_score = (anc4_coverage + sba_coverage) / 2) %>%
  arrange(mean_score) %>%
  slice_head(n = 10) %>%
  select(country, group, anc4_coverage, sba_coverage)






# ---- 7. Reshape for Visualisation ----

df_long <- df_final_wide %>%
  pivot_longer(cols = c(anc4_coverage, sba_coverage), names_to = "indicator", values_to = "coverage")



# ---- 8. Save outputs ----


saveRDS(excluded_summary, file.path(dir_output, "excluded_summary.rds"))
saveRDS(excluded_countries, file.path(dir_output, "excluded_countries.rds"))

saveRDS(summary_group, file.path(dir_output, "coverage_summary_group.rds"))


saveRDS(results_group, file.path(dir_output, "coverage_results_by_group.rds"))
saveRDS(results_country, file.path(dir_output, "coverage_results_by_country.rds"))


saveRDS(top10_anc4, file.path(dir_output, "top10_anc4.rds"))
saveRDS(df_top10_combined, file.path(dir_output, "top10_combined_coverage.rds"))

saveRDS(df_long, file.path(dir_output, "coverage_long_data.rds"))
saveRDS(df_final_wide, file.path(dir_output, "coverage_wide_data.rds"))
write_csv(df_long, file.path(dir_output, "df_long.csv"), col_names = TRUE)
write_csv(df_final_wide, file.path(dir_output, "df_final_wide.csv"), col_names = TRUE)




