## code to prepare `anthropometry` dataset goes here
# Generate a synthetic longitudinal dataset (in long format) with the following variables:
# id: subject ID
# age: from 1 to 20 years (10 repeated measures per subject)
# sex: Male/Female
# nationality: simulated as e.g., "US", "UK", "JP", "FR"
# head_circumference: simulated with age/sex-specific means
# height: simulated with age/sex-specific means
# bmi: simulated from height and a synthetic weight

set.seed(42)

library(dplyr)

n_subjects <- 200   # number of unique subjects
n_measures <- 8    # repeated measures per subject
ages <- seq(1, 19, length.out = n_measures)
nationalities <- c("Dutch", "Italian", "French", "British", "German")

# Generate subject-level data (random effects)
subj_df <- data.frame(
  id = 1:n_subjects,
  sex = sample(c("Male", "Female"), n_subjects, replace = TRUE),
  nationality = sample(nationalities, n_subjects, replace = TRUE),
  # Random intercepts and slopes for individuals
  head_int = rnorm(n_subjects, 0, 1.2),
  head_slope = rnorm(n_subjects, 0, 0.07),
  height_int = rnorm(n_subjects, 0, 3),
  height_slope = rnorm(n_subjects, 0, 0.12),
  bmi_int = rnorm(n_subjects, 0, 1.1),
  bmi_slope = rnorm(n_subjects, 0, 0.07)
)

 # Generate long format repeated measures
anthropometry <- subj_df %>%
  slice(rep(1:n(), each = n_measures)) %>%
  group_by(id) %>%
  mutate(
    age = ages + rnorm(n_measures, 0, 0.5),  # smaller jitter for more realistic spacing
    # Nonlinear head circumference: logistic/log growth + sex + random slopes
    head_circumference = case_when(
      sex == "Male" ~ 48 + 13 / (1 + exp(-0.5 * (age - 3))) + 0.1 * log(age + 1) + head_int + head_slope * age + rnorm(n_measures, 0, 1.2),
      TRUE ~ 47 + 12 / (1 + exp(-0.55 * (age - 3))) + 0.09 * log(age + 1) + head_int + head_slope * age + rnorm(n_measures, 0, 1.2)
    ),
    # Nonlinear height: logistic S-curve + sex + random slopes
    height = case_when(
      sex == "Male" ~ 54 + 145 / (1 + exp(-0.25 * (age - 12))) + height_int + height_slope * age + rnorm(n_measures, 0, 5),
      TRUE ~ 52 + 135 / (1 + exp(-0.23 * (age - 11))) + height_int + height_slope * age + rnorm(n_measures, 0, 5)
    ),
    # Nonlinear BMI: "adiposity rebound" + random intercept/slope
    bmi = 15.5 + 1.8 * exp(-0.5 * (age - 6)^2 / 8) - 1.2 * exp(-0.5 * (age - 2)^2 / 1.2) +
      0.15 * age + bmi_int + bmi_slope * age + rnorm(n_measures, 0, 1.1),
  ) %>%
  ungroup() %>%
  mutate(
    # Weight is computed from BMI and height
    weight = bmi * (height/100)^2
  ) %>%
  select(id, age, sex, nationality, head_circumference, height, weight, bmi)

# Display the first few rows
head(anthropometry)

usethis::use_data(anthropometry, overwrite = TRUE)
