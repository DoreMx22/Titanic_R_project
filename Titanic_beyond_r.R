Titanic analysis · R
# ============================================================
# Titanic Survival Analysis - Statistical Analysis
# Author: Dorena Estrada Pereira
# Date: May 2026
# Data source: titanic_clean.csv (1,046 passengers, post-cleaning)
# ============================================================


# ============================================================
# 1. SETUP
# ============================================================


library(dplyr)      # Data manipulation
library(ggplot2)    # Visualization
library(tidyr)      # Reshaping (pivot_longer)
library(tibble)     # Data frames
library(knitr)      # frame formating


# ============================================================
# 2. DATA TRANSFORMATION
# ============================================================

# Create age category variable: children (<13) vs adults (>=13)
# Threshold reflects 1912 maritime law classification of minors
titanic_clean <- titanic_clean %>%
  mutate(
    grupo_edad = ifelse(age < 12, "niño", "adulto")
  )


# ============================================================
# 3. DESCRIPTIVE STATISTICS - SURVIVAL PROBABILITIES
# ============================================================

# Overall survival rate (baseline)
survival_overall <- mean(titanic_clean$survived)


# Survival by sex
# Includes death_count and death_rate (complement) for stacked visualization
survival_by_sex <- titanic_clean %>% 
  group_by(sex) %>%
  summarise(
    n = n(),
    survival_count = sum(survived),
    survival_rate = mean(survived)
  ) %>%
  mutate(
    death_count = n - survival_count,
    death_rate = 1 - survival_rate
  )


# Survival by passenger class
survival_by_class <- titanic_clean %>% 
  group_by(class) %>% 
  summarise(
    n = n(),
    survival_count = sum(survived),
    survival_rate = mean(survived)
  )


# Survival by age category (children vs adults)
survival_by_age_category <- titanic_clean %>% 
  group_by(grupo_edad) %>% 
  summarise(
    n = n(),
    survival_count = sum(survived),
    survival_rate = mean(survived)
  )


# Survival by sex AND class (intersection)
# Used to test whether the protocol applied uniformly across classes
survival_by_sex_class <- titanic_clean %>% 
  group_by(sex, class) %>%
  summarise(
    n = n(),
    survival_count = sum(survived),
    survival_rate = mean(survived),
    .groups = 'drop'
  )


# Survival by age AND class
# Tests whether the "children first" protocol held across classes
survival_by_age_class <- titanic_clean %>%
  group_by(grupo_edad, class) %>%
  summarise(
    n = n(),
    survival_count = sum(survived),
    survival_rate = mean(survived),
    .groups = 'drop'
  )


# Three-way intersection: age, class, and sex
# Most granular view of survival patterns
survival_by_age_class_sex <- titanic_clean %>%
  group_by(grupo_edad, class, sex) %>%
  summarise(
    n = n(),
    survival_count = sum(survived),
    survival_rate = mean(survived),
    .groups = 'drop'
  )



# ============================================================
# 4. DATA RESHAPING FOR VISUALIZATION
# ============================================================

# Convert survival_by_sex to long format for stacked bar chart
# ggplot requires long format when stacking outcomes (survived vs died)
survival_by_sex_long <- survival_by_sex %>%
  select(sex, survival_count, death_count) %>%
  pivot_longer(
    cols = c(survival_count, death_count),
    names_to = "outcome",
    values_to = "count"
  )

#Filter information: women from first class and pull survival rate

mujeres_1 <- survival_by_age_class_sex %>% filter(sex=="female", grupo_edad == "adulto", class == 1) %>% 
  pull(survival_rate)

mujeres_2 <- survival_by_age_class_sex %>% filter(sex=="female", grupo_edad =="adulto", class == 2) %>% 
  pull(survival_rate)

mujeres_3 <- survival_by_age_class_sex %>% filter(sex=="female", grupo_edad=="adulto", class==3) %>% 
  pull(survival_rate)

hombres_1 <- survival_by_age_class_sex %>% filter(sex=="male", grupo_edad=="adulto", class == 1) %>% 
  pull(survival_rate)

hombres_2 <- survival_by_age_class_sex %>% filter(sex == "male", grupo_edad=="adulto", class==2) %>% 
  pull(survival_rate)

hombres_3 <- survival_by_age_class_sex %>% filter(sex == "male", grupo_edad=="adulto", class==3) %>% 
  pull(survival_rate)

niña_general <- survival_by_age_class_sex %>% filter(sex == "female", grupo_edad=="niño") %>% 
  summarise(rate = weighted.mean(survival_rate,n)) %>% pull(rate)
  
niño_general <- survival_by_age_class_sex %>% filter(sex=="male",grupo_edad=="niño") %>% 
  summarise(rate = weighted.mean(survival_rate,n)) %>% pull(rate)

niña_1 <- survival_by_age_class_sex %>% filter(sex=="female", grupo_edad=="niño", class==1) %>% 
  pull(survival_rate)

niña_2 <- survival_by_age_class_sex %>% filter(sex=="female", grupo_edad == "niño", class == 2) %>% 
  pull(survival_rate)

niña_3 <- survival_by_age_class_sex %>% filter(sex=="female", grupo_edad=="niño", class == 3) %>% 
  pull(survival_rate)

niño_1 <- survival_by_age_class_sex %>% filter(sex=="male",grupo_edad =="niño", class==1) %>% 
  pull(survival_rate)

niño_2 <- survival_by_age_class_sex %>%  filter(sex=="male", grupo_edad =="niño", class==2) %>% 
  pull(survival_rate)

niño_3 <- survival_by_age_class_sex %>% filter(sex == "male", grupo_edad == "niño", class == 3) %>% 
  pull(survival_rate)


# ============================================================
# 5. VISUALIZATIONS
# ============================================================

# ------------------------------------------------------------
# Figure 1: Survival rate by sex (simple bar)
# ------------------------------------------------------------
ggplot(data = survival_by_sex, aes(x = sex, y = survival_rate, fill = sex)) + 
  geom_col() +
  labs(
    title = "Survival Rates by Gender",
    x = "Sex",
    y = "Survival Rate"
  )


# ------------------------------------------------------------
# Figure 2: Stacked composition - survived vs died, by sex
# Shows proportion within each group (always sums to 100%)
# ------------------------------------------------------------
ggplot(data = survival_by_sex_long, 
       aes(x = sex, y = count, fill = outcome)) +
  geom_col(position = "fill") +
  scale_fill_manual(
    values = c("survival_count" = "#3182bd", "death_count" = "salmon"),
    labels = c("survival_count" = "Survived", "death_count" = "Did not survive")
  ) +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Figure 1. Titanic Survival Composition by Sex",
    x = "Sex",
    y = "Proportion",
    fill = "Outcome"
  )


# ------------------------------------------------------------
# Figure 3: Survival rate by age group (children vs adults)
# ------------------------------------------------------------
ggplot(data = survival_by_age_category, 
       aes(x = grupo_edad, y = survival_rate, fill = factor(grupo_edad))) + 
  geom_col() + 
  scale_fill_manual(values = c("niño" = "#3182bd", "adulto" = "#08519c")) +
  scale_x_discrete(labels = c("niño" = "Child", "adulto" = "Adult")) +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Figure 2.Survival Rates by Age Group",
    x = "Age Group",
    y = "Proportion of Each Age Group That Survived"
  ) +
  theme(legend.position = "none")


# ------------------------------------------------------------
# Figure 4: Survival rate by class (simple bar)
# Class is converted to factor so it's treated as categorical
# ------------------------------------------------------------
ggplot(data = survival_by_class, 
       aes(x = factor(class), y = survival_rate, fill = factor(class))) +
  geom_col() +
  scale_fill_manual(values = c("1" = "#08519c", "2" = "#3182bd", "3" = "#9ecae1")) +
  scale_x_discrete(labels = c("1" = "1st class", "2" = "2nd class", "3" = "3rd class")) +
  labs(
    title = "Survival Rates by Passenger Class",
    x = "Class",
    y = "Survival Rate"
  ) +
  theme(legend.position = "none")


# ------------------------------------------------------------
# Figure 5: Survival rate by class AND sex (grouped bars)
# Bars are dodged (side by side), not stacked, because rates
# from different groups cannot be summed meaningfully.
# This figure shows the central argument of the paper.
# ------------------------------------------------------------
ggplot(data = survival_by_sex_class, 
       aes(x = factor(class), y = survival_rate, fill = sex)) +
  geom_col(position = "dodge") +
  scale_fill_manual(
    values = c("female" = "#D4537E", "male" = "#378ADD"),
    labels = c("female" = "Women", "male" = "Men")
  ) +
  scale_x_discrete(labels = c("1" = "1st class", "2" = "2nd class", "3" = "3rd class")) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  labs(
    title = "Figure 4. Titanic Survival Rate by Class and Sex",
    x = "Passenger Class",
    y = "Survival Rate",
    fill = "Sex"
  )


# ------------------------------------------------------------
# Figure 6: Heatmap - survival rate by sex and class
# Color intensity = survival rate
# ------------------------------------------------------------
ggplot(data = survival_by_sex_class, 
       aes(x = factor(class), y = sex, fill = survival_rate)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "darkred") +
  labs(
    title = "Survival Rates by Sex and Passenger Class",
    x = "Passenger Class",
    y = "Sex",
    fill = "Survival Rate"
  )


# ------------------------------------------------------------
# Figure 7: Heatmap - survival rate by age group and class
# ------------------------------------------------------------
ggplot(data = survival_by_age_class, 
       aes(x = factor(class), y = grupo_edad, fill = survival_rate)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "darkgreen") +
  labs(
    title = "Survival Rates by Age Group and Passenger Class",
    x = "Passenger Class",
    y = "Age Group",
    fill = "Survival Rate"
  )


# ------------------------------------------------------------
# Figure 8: Jitter plot - age vs class colored by survival
# Includes horizontal line at age 13 (child/adult threshold)
# Jitter adds horizontal noise so points don't overlap
# height = 0 keeps actual age values intact (no vertical noise)
# ------------------------------------------------------------
ggplot(data = titanic_clean, 
       aes(x = factor(class), y = age, color = factor(survived))) +
  geom_jitter(width = 0.25, height = 0, alpha = 0.6, size = 2) +
  geom_hline(yintercept = 12, linetype = "dashed", color = "gray40") +
  scale_color_manual(
    values = c("0" = "salmon", "1" = "#3182bd"),
    labels = c("0" = "Did not survive", "1" = "Survived")
  ) +
  scale_x_discrete(labels = c("1" = "1st class", "2" = "2nd class", "3" = "3rd class")) +
  labs(
    title = "Figure 3. Age and Survival Across Passenger Classes",
    x = "Passenger Class",
    y = "Age (years)",
    color = "Outcome"
  )


# ------------------------------------------------------------
#Figure 9: table of survival probability - this table contains all
#the survival rates per group as the intention is to show dependant 
# and independant variables
# ------------------------------------------------------------



tabla_probabilidades <- tibble(
  Group = c(
    "Women (overall)",
    "Women, 1st class", "Women, 2nd class", "Women, 3rd class",
    "Men (overall)",
    "Men, 1st class", "Men, 2nd class", "Men, 3rd class",
    "Girls (Overall)", "Girls 1st class", "Girls 2nd class", "Girls 3rd class",
    "Boys (Overall)", "Boys 1st class", "Boys 2nd class", "Boys 3rd class"
  ),  
  Survival_Probability = c(
    survival_by_sex$survival_rate[survival_by_sex$sex == "female"],
    mujeres_1, mujeres_2, mujeres_3,
    survival_by_sex$survival_rate[survival_by_sex$sex == "male"],
    hombres_1, hombres_2, hombres_3,
    niña_general, niña_1, niña_2, niña_3,
    niño_general, niño_1, niño_2, niño_3
  ) 
) 


kable(tabla_probabilidades,
      col.names = c("Group", "Survival Probability"),
      digits = 3,
      na.string = "—",
      caption = "Survival probabilities by demographic group and passenger class. 
      † Girls, 1st class excluded (n=1, statistically unreliable).")
