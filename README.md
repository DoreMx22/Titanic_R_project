# Beyond 'Women and Children First': Socioeconomic Status and Survival on the Titanic

**Author:** Dorena Estrada Pereira  
**Date:** May 2026  
**Tools:** R · SQL · ggplot2 · dplyr · tidyr

\---

## Overview

This project examines whether survival outcomes on the RMS Titanic aligned with the maritime protocol of "women and children first," or whether passenger class — as a proxy for socioeconomic status — played a more decisive role in determining who had access to lifeboats.

Using statistical analysis of 1,046 passengers with complete demographic data, the study combines descriptive probability analysis with historical evidence to explore the intersection of gender, age, and class in survival outcomes.

\---

## Research Questions

1. Were the lifeboats sufficient to accommodate all passengers, regardless of class?
2. Was the "women and children first" protocol applied consistently across all passenger classes?
3. Was survival correlated with passenger class?

\---

## Key Findings

* **Women and children did survive at higher rates overall** — consistent with the Birkenhead drill.
* **However, this advantage was conditional on class.** Women in 3rd class survived at 47.5%, compared to 97.0% for women in 1st class.
* **All children in 1st and 2nd class survived**, while only 40% of 3rd-class children did.
* **Survival and passenger class were not independent variables.** Under independence, the joint probability P(survived ∩ 1st class) would be 11.1%; the observed value was 17.3%.
* The Titanic can be understood not only as a maritime tragedy, but as a moment in which the social order of the Edwardian world remained visible even in disaster.

\---

## Repository Structure

```
titanic-survival-analysis/
├── README.md
├── paper/
│   └── beyond\_women\_and\_children\_first.pdf
├── code/
│   └── titanic\_analysis.R
├── data/
│   └── titanic\_clean.csv
└── figures/
    ├── figure1\_Titanic\_Survival\_Composition\_by\_Sex.png
    ├── figure2\_Survival\_Rates\_by\_Age\_Group.png
    ├── figure3\_Age\_and\_Survival\_Across\_passenger\_classes.png
    ├── figure4\_Titanic\_Survival\_Rate\_By\_Class\_and\_Sex.png
```

\---

## Methodology

* **Dataset:** 1,309 original passenger records; restricted to 1,046 with complete age, sex, class, and survival data
* **Exclusions:** 263 passengers with missing age data (20.1%); crew members excluded as they cannot be categorized by passenger class
* **Age threshold:** Children defined as under 12 years, consistent with the Titanic's Certificates for Clearance (1912)
* **Analysis:** Descriptive statistics, conditional probability comparisons, independence checks via multiplication rule
* **Tools:** Data cleaning in SQL; statistical analysis and visualization in R (dplyr, ggplot2, tidyr)

\---

## How to Reproduce

1. Clone this repository
2. Open `code/titanic\_analysis.R` in RStudio
3. Load `data/titanic\_clean.csv` (update the file path if needed)
4. Run the script sequentially — all figures and the probability table will be generated

**Required packages:**

```r
install.packages(c("dplyr", "ggplot2", "tidyr", "tibble", "knitr", "scales"))
```

\---

## Data Source

Hind, R. (2016). *Titanic3 dataset*. Retrieved from the Encyclopedia Titanica and made available via the `titanic3` package. Original passenger records sourced from historical archives.

\---

## Related Portfolio Projects

* [European Soccer SQL Analysis](https://github.com/DoreMx22/european-soccer-sql)
* [Global Education SQL Analysis](https://github.com/DoreMx22/global-education-sql)
* [Tableau Public Dashboards](https://public.tableau.com/app/profile/dorena.estrada)

