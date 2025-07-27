# Test for Consultancy with the D&A Education Team

This repository contains the tasks for the **UNICEF Data and Analytics technical evaluation** for education.

------------------------------------------------------------------------

## 📋 General Instructions

-   Please **clone this repository** to your local computer. Once complete, **push your work to your own GitHub repository** and share the link.

-   To preserve your anonymity:

    -   ❌ Do **not fork** this repository
    -   ❌ Do **not include your name** anywhere in the submitted assessment

-   Please respect the **confidential nature of this test** and **do not share or discuss** its content with others.

-   Please add the **positions you applied for** in the final output and your readme. Please **do not include your name**.

-   The focus of this test is to assess:

    -   ✅ How you **structure your workflow and code**
    -   ✅ Your **proficiency in collaborative work environments**
    -   ✅ Your **commitment to reproducible research practices**

-   The **final code and results** must be uploaded to your GitHub repository. Your code should:

    -   📌 Be **well-documented**
    -   ⚙️ Be **ready for automated execution**
    -   📂 Follow best practices in **version control and coding standards**

-   You may use **R, Python, or Stata**.

-   **Estimated completion time**: 4 hours

-   ⏱️ **You have 48 hours** to complete the assessment and share back your GitHub repository link. Commits made **after 48 hours** will not be considered for evaluation.

------------------------------------------------------------------------

## 🗂️ Exercise Overview

### 1. Set up your GitHub repository and workflow

Create a **well-structured repository** with the following:

-   📁 **Folder structure**: Reflect an end-to-end workflow with clear organization that supports reproducibility (e.g., `data`, `documentation`, `scripts`, etc.)

-   📝 **README file**:

    -   Describe the **structure** of your repository
    -   Explain the **purpose** of each folder and file
    -   Include **instructions** on how to reproduce your analysis

-   🧩 In the **main directory**, include the following scripts:

    -   `user_profile`: A script or configuration file that ensures your code can run on **any machine**
    -   `run_project`: A script that executes your **workflow end-to-end**, producing the final output (**PDF, HTML, or DOCX report**)

------------------------------------------------------------------------

## 🩺 Task

You are required to **calculate the population-weighted coverage** of two health services:

-   **Antenatal care (ANC4)**: % of women (aged 15–49) with at least 4 antenatal care visits
-   **Skilled birth attendance (SBA)**: % of deliveries attended by skilled health personnel

for countries categorized as **on-track** or **off-track** in achieving under-five mortality targets (as of 2022).

------------------------------------------------------------------------

## 📊 Data Sources

-   **Retrieve the following indicators** from the UNICEF Global Data Repository [`LINK`](https://data.unicef.org/resources/data_explorer/unicef_f/?ag=UNICEF&df=GLOBAL_DATAFLOW&ver=1.0&dq=.MNCH_ANC4+MNCH_SAB.&startPeriod=2018&endPeriod=2022) at the country level for the years **2018–2022**:

    -   **ANC4**: % of women (aged 15–49) with at least 4 antenatal care visits
    -   **SBA**: % of deliveries attended by skilled health personnel

-   Use the following additional files:

    -   📈 **Population Data**: UN World Population Prospects, 2022\
        *File: `WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx` (located in `01_rawdata/`)*

    -   **Under-five mortality classification**:

        -   On-track if `Status.U5MR` is `"achieved"` or `"on-track"`
        -   Off-track if `Status.U5MR` is `"acceleration needed"`\
            *File: `On-track and off-track countries.xlsx`*

------------------------------------------------------------------------

## 🧪 Steps to Follow

### 1. Data Preparation

-   Clean and merge all datasets using **consistent country identifiers**
-   For ANC4 and SBA, **filter for coverage estimates from 2018 to 2022**
    -   Use the **most recent estimate** within this range per country

### 2. Calculate Population-Weighted Coverage

-   For each group (**on-track** and **off-track**), calculate **population-weighted averages** for ANC4 and SBA
-   Use **projected births for 2022** as weights

### 3. Reporting

-   Create a **PDF / HTML / DOCX report** including:
    -   📉 A **visualization** comparing coverage for on-track vs. off-track countries
    -   🧾 A short paragraph **interpreting the results**, highlighting any caveats or assumptions

------------------------------------------------------------------------
