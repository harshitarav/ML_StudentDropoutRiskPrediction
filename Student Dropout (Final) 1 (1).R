setwd("C:/Spring 25/Subjects/Predictive Analytics/Project/Final")
rm(list=ls())
cat("\014")

# 1. Load Packages
library("data.table")
library("ggplot2")
library("dplyr")

# 2. Load Dataset
stud=fread(file="student dropout.csv",
            na.strings = c("NA",""),
            sep="auto",
            stringsAsFactors = FALSE,
            data.table = TRUE,
            encoding = "UTF-8"
)

# Count of missing values per column
sapply(stud, function(x) sum(is.na(x)))

target_counts <- table(stud$Dropped_Out)
target_pct <- prop.table(target_counts) * 100
print(target_counts)
cat("\nPercentage distribution:\n")
print(round(target_pct, 2))

library(ggplot2)
ggplot(as.data.frame(target_counts), aes(x = as.factor(Var1), y = Freq, fill = as.factor(Var1))) +
  geom_col(width = 0.5) +
  scale_x_discrete(labels = c("FALSE" = "Stayed", "TRUE" = "Dropped Out")) +
  scale_fill_manual(values = c("skyblue", "tomato")) +
  labs(title = "Count of Target Variable per Category",
       x = "Dropout Status", y = "Count") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"))

# 3. Feature Engineering
# 3.1. Target Variable
# Convert Dropped_Out TRUE/FALSE to 1/0
stud[, Dropped_Out := ifelse(Dropped_Out == TRUE, 1, 0)]

# 3.2. Binary Variables
stud[, Female := ifelse(Gender == "F", 1, 0)]
stud[, School_GP := ifelse(School == "GP", 1, 0)]
stud[, Address_Urban := ifelse(Address == "U", 1, 0)]
stud[, Family_Size_GT3 := ifelse(Family_Size == "GT3", 1, 0)]
stud[, Parents_Together := ifelse(Parental_Status == "A", 1, 0)]

# Convert yes/no to 1/0
yes_no_cols <- c("School_Support",
                 "Family_Support",
                 "Extra_Paid_Class", 
                 "Extra_Curricular_Activities",
                 "Attended_Nursery", 
                 "Wants_Higher_Education",
                 "Internet_Access", 
                 "In_Relationship")
for (col in yes_no_cols) {
  stud[[col]] <- ifelse(stud[[col]] == "yes", 1, 0)
}

binary_cols <- c("Female", "School_GP", "Address_Urban", "Family_Size_GT3", "Parents_Together", yes_no_cols)

stud[, c("School", "Gender", "Address", "Family_Size", "Parental_Status") := NULL]


# 3.3. Nominal Variables
factor_cols <- c("Mother_Job",
                 "Father_Job",
                 "Reason_for_Choosing_School",
                 "Guardian")
stud[, (factor_cols) := lapply(.SD, as.factor), .SDcols = factor_cols]

# 3.4. Numerical Variables
num_vars <- setdiff(names(stud), c(binary_cols, factor_cols))

# 3.5. Correlation
correlations <- sapply(stud[, ..num_vars], function(x) cor(x, stud$Dropped_Out))
order_by_magnitude <- order(abs(correlations), decreasing = TRUE)
correlations_by_magnitude <- correlations[order_by_magnitude]; correlations_by_magnitude


# 4. Graphs
# 4.1. Grade_1 vs Dropped Out
ggplot(stud,
       aes(x = as.factor(Dropped_Out),
           y = Grade_1,
           fill = as.factor(Dropped_Out))) +
  geom_boxplot() +
  scale_x_discrete(labels = c("0" = "Stayed", "1" = "Dropped Out")) + # Change x-axis labels
  labs(title = "Distribution of Grade_1 by Dropout Outcome",
       x = "Dropout Outcome", y = "Grade_1",
       fill = "Dropped_Out") +
  theme_minimal() +
  theme(legend.position = "none", # Suppress the legend
        plot.title = element_text(size = 16, hjust = 0.5),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12)) 

# 4.2. Number of Failures vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Number_of_Failures]
ggplot(stud,
       aes(x = as.factor(Number_of_Failures),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Number_of_Failures),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Number of Failures",
       x = "Number of Failures",
       y = "Proportion") +
  theme_minimal()

# 4.3. Wants Higher Education vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Wants_Higher_Education]
ggplot(stud,
       aes(x = as.factor(Wants_Higher_Education),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Wants_Higher_Education),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_x_discrete(
    labels = c("0" = "No", "1" = "Yes") # Map original levels to new labels
  ) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Wants_Higher_Education",
       x = "Wants_Higher_Education",
       y = "Proportion") +
  theme_minimal() +
  theme(plot.title = element_text(size = 16, hjust = 0.5),
      axis.title.x = element_text(size = 14),
      axis.title.y = element_text(size = 14),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12)) 

# 4.4. Weekday Alcohol Consumption vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Weekday_Alcohol_Consumption]
ggplot(stud,
       aes(x = as.factor(Weekday_Alcohol_Consumption),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Weekday_Alcohol_Consumption),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Weekday Alcohol Consumption",
       x = "Weekday Alcohol Level (1-5)",
       y = "Proportion") +
  theme_minimal()

# 4.5. Weekend Alcohol Consumption vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Weekend_Alcohol_Consumption]
ggplot(stud,
       aes(x = as.factor(Weekend_Alcohol_Consumption),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Weekend_Alcohol_Consumption),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Weekend Alcohol Consumption",
       x = "Weekend Alcohol Level (1-5)",
       y = "Proportion") +
  theme_minimal()

# 4.6. Age vs Dropped Out
ggplot(stud,
       aes(x = as.factor(Dropped_Out),
           y = Age,
           fill = as.factor(Dropped_Out))) +
  geom_boxplot() +
  scale_x_discrete(labels = c("0" = "Stayed", "1" = "Dropped Out")) + # Change x-axis labels
  labs(title = "Distribution of Age by Dropout Outcome",
       x = "Dropout Outcome", y = "Age",
       fill = "Dropped_Out") +
  theme_minimal() +
  theme(legend.position = "none") # Suppress the legend

count_data <- stud[, .(Total_Count = .N), by = Age]
ggplot(stud,
       aes(x = as.factor(Age),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  geom_text(data = count_data,
            aes(x = as.factor(Age),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out")) + # Set specific labels for levels
  labs(title = "Distribution of Dropout Outcome by Age",
       x = "Age", y = "Age") +
  theme_minimal() 

# 4.7. Study Time vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Study_Time]
ggplot(stud,
       aes(x = as.factor(Study_Time),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Study_Time),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Weekly Study Time",
       x = "Weekly Study Hours (1-4)",
       y = "Proportion") +
  theme_minimal()

# 4.8. School GP vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = School_GP]
ggplot(stud,
       aes(x = as.factor(School_GP),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(School_GP),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_x_discrete(
    labels = c("0" = "MS", "1" = "GP") # Map original levels to new labels
  ) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by School",
       x = "School",
       y = "Proportion") +
  theme_minimal() +
  theme(plot.title = element_text(size = 16, hjust = 0.5),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12)) 

stud2 <- stud
stud2 <- stud2 %>%
  mutate(
    School_Factor = factor(School_GP, levels = c(0, 1), labels = c("MS", "GP")), # Adjust levels/labels
    Reason_Factor = factor(Reason_for_Choosing_School), # ggplot will handle levels
    Dropout_Factor = factor(Dropped_Out, levels = c(0, 1), labels = c("Stayed", "Dropped Out"))
  )
ggplot(stud2, aes(x = Reason_Factor, fill = Dropout_Factor)) +
  geom_bar(position = "stack") + # Creates stacked bars showing counts
  facet_wrap(~ School_Factor) +
  labs(
    title = "Student Counts by Reason for Choosing School and Dropout Outcome",
    subtitle = paste("Faceted by School | As of:", format(Sys.time(), "%Y-%m-%d %H:%M %Z")),
    x = "Reason for Choosing School",
    y = "Number of Students"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    strip.background = element_rect(fill = "lightgrey"),
    strip.text = element_text(face = "bold"),
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, size = 10)
  )

# 4.9. Internet Access vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Internet_Access]
ggplot(stud,
       aes(x = as.factor(Internet_Access),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Internet_Access),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_x_discrete(
    labels = c("0" = "No", "1" = "Yes") ) + # Map original levels to new labels
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Internet Access",
       x = "Internet Access",
       y = "Proportion") +
  theme_minimal()

# 4.10. Address Type vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Address_Urban]
ggplot(stud,
       aes(x = as.factor(Address_Urban),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Address_Urban),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_x_discrete(
    labels = c("0" = "Rural", "1" = "Urban") # Map original levels to new labels
  ) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Address Type",
       x = "Address Type",
       y = "Proportion") +
  theme_minimal()

# 4.11. Mother's Education vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Mother_Education]
ggplot(stud,
       aes(x = as.factor(Mother_Education),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Mother_Education),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Mother's Education",
       x = "Mother's Education (0-4)",
       y = "Proportion") +
  theme_minimal()

# 4.12. Father's Education vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Father_Education]
ggplot(stud,
       aes(x = as.factor(Father_Education),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Father_Education),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Father's Education",
       x = "Father's Education (0-4)",
       y = "Proportion") +
  theme_minimal()

# 4.13. Family Support vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Family_Support]
ggplot(stud,
       aes(x = as.factor(Family_Support),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Family_Support),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_x_discrete(
    labels = c("0" = "No", "1" = "Yes") # Map original levels to new labels
  ) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Family Support",
       x = "Family Support",
       y = "Proportion") +
  theme_minimal()

# 4.14. Family Relationship vs Dropped Out
ggplot(stud, aes(x = as.factor(Dropped_Out),
                 y = Family_Relationship,
                 fill = as.factor(Dropped_Out))) +
  geom_boxplot() +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(
    title = "Family Relationship Quality vs Dropout Outcome",
    x = "Dropout Outcome",
    y = "Family Relationship Quality (1–5)"
  ) +
  theme_minimal()

# 4.15. Extracurricular Activities vs Dropped Out
count_data <- stud[, .(Total_Count = .N), by = Extra_Curricular_Activities]
ggplot(stud,
       aes(x = as.factor(Extra_Curricular_Activities),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Extra_Curricular_Activities),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_x_discrete(
    labels = c("0" = "No", "1" = "Yes") # Map original levels to new labels
  ) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Extracurricular Activities",
       x = "Extracurricular Activities",
       y = "Proportion") +
  theme_minimal()

# 4.16. Gender (Female) vs Dropped Out 
count_data <- stud[, .(Total_Count = .N), by = Female]
ggplot(stud,
       aes(x = as.factor(Female),
           fill = as.factor(Dropped_Out))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  geom_text(data = count_data,
            aes(x = as.factor(Female),
                y = 1.03,
                label = Total_Count,
                fill = NULL), # Don't inherit fill aesthetic
            size = 3, vjust = 0) +
  scale_x_discrete(
    labels = c("0" = "Male", "1" = "Female") # Map original levels to new labels
  ) +
  scale_fill_discrete(
    name = "Dropout Outcome",            # Set Legend title
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Set specific labels for levels
  ) +
  labs(title = "Dropout Outcome Proportion by Gender",
       x = "Gender",
       y = "Proportion") +
  theme_minimal()

# 4.17. Free Time vs Dropped Out
ggplot(stud,
       aes(x = as.factor(Dropped_Out),
           y = Free_Time,
           fill = as.factor(Dropped_Out))) +
  geom_boxplot() +
  scale_x_discrete(
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Map original levels to new labels
  ) +
  labs(
    title = "Free Time After School by Dropout Outcome",
    x = "Dropout Outcome",
    y = "Free Time After School (1-5)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# 4.18. Going Out vs Dropped Out
ggplot(stud,
       aes(x = as.factor(Dropped_Out),
           y = Going_Out,
           fill = as.factor(Dropped_Out))) +
  geom_boxplot() +
  scale_x_discrete(
    labels = c("0" = "Stayed", "1" = "Dropped Out") # Map original levels to new labels
  ) +
  labs(
    title = "Frequency of Going Out with Friends by Dropout Outcome",
    x = "Dropout Outcome",
    y = "Frequency of Going Out with Friends (1-5)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# 4.19. Number of Absences
ggplot(stud,
       aes(x = Number_of_Absences,
           fill = as.factor(Dropped_Out))) +
  geom_histogram(bins = 10,
                 color = "black",
                 position = "identity") +
  scale_fill_discrete(
    labels = c("0" = "Stayed", "1" = "Dropped Out")) +
  labs(title = "Number of Absences by Dropout Outcome",
       x = "Number of Absences",
       y = "Count",
       fill = "Dropped Out") +
  theme_minimal()

# Skewed -> Log-transformation
stud[, log_Number_of_Absences := log(Number_of_Absences + 0.000001)]

# 6. Logistic Regression

# 6.1. Split training and test data
set.seed(123) # for reproducibility

train_indices <- sample(1:nrow(stud), size = 0.7 * nrow(stud))

train_data <- stud[train_indices]
test_data <- stud[-train_indices]

# 6.2. Build the model on training data
logit_model_train <- glm(Dropped_Out ~ Wants_Higher_Education +
                           School_GP +
                           Number_of_Absences +
                           Study_Time +
                           Number_of_Failures +
                           Grade_1 +
                           Free_Time +
                           Going_Out +
                           Family_Relationship +
                           Weekend_Alcohol_Consumption +
                           In_Relationship +
                           Extra_Paid_Class,
                         data = train_data,
                         family = "binomial")
summary(logit_model_train)

# 6.3. View Odds Ratios and p-values from Training Model (IMPORTANT: logit_model_train here)
odds_ratios <- data.table(
  Variable = names(coef(logit_model_train)),
  OR = exp(coef(logit_model_train)),
  lowerCI = exp(confint.default(logit_model_train))[, 1],
  upperCI = exp(confint.default(logit_model_train))[, 2],
  pvalue = summary(logit_model_train)$coefficients[, 4]
)

# Remove Intercept
odds_ratios <- odds_ratios[Variable != '(Intercept)']

# View Odds Ratios
print(odds_ratios)

# Extract Data for Standard Deviations Calculation
predictors_used <- labels(terms(logit_model_train))
predictors_used_data <- train_data[, .SD, .SDcols = predictors_used]

sd_values <- sapply(predictors_used_data, function(x) {
  if (is.numeric(x)) {
    return(sd(x, na.rm = TRUE))
  } else {
    return(NA_real_)
  }
})

sd_table <- data.table(
  Variable = names(sd_values),
  standard_deviation = sd_values
)

merged_or_sd <- merge(odds_ratios, sd_table,
                      by = "Variable",
                      all = FALSE)

# View Standard Deviations
print(merged_or_sd)

# Calculate Economic Importance
merged_or_sd[, Economic_Importance :=
               # Check if OR > 1
               fifelse(Variable %in% binary_cols,
                       # If Variable is binary
                       fifelse(OR > 1,
                               OR,
                               1 / OR),
                       # If Variable is numeric
                       fifelse(OR > 1,
                               OR ^ standard_deviation,
                               (1 / OR) ^ standard_deviation)
               )
               ]

sorted_economic_importance <- merged_or_sd[order(-Economic_Importance)]

# View Economic Importances
print("Odds Ratios Table with Economic Importance:")
print(sorted_economic_importance)

# View only Significant Variables
sig_odds_ratios <- odds_ratios[pvalue < 0.1]
sig_odds_ratios <- sig_odds_ratios[order(-abs(OR))]
print(sig_odds_ratios)

# 6.3.1. Coefficient Plot (Odds Ratios Visualization)
library(ggplot2)

odds_ratios_plot <- odds_ratios[Variable != "(Intercept)"]
odds_ratios_plot <- odds_ratios_plot[order(OR, decreasing = TRUE)]

ggplot(odds_ratios_plot, aes(x = reorder(Variable, OR), y = OR)) +
  geom_point(size = 3, color = "tomato") +
  geom_errorbar(aes(ymin = lowerCI, ymax = upperCI), width = 0.2, color = "gray40") +
  geom_hline(yintercept = 1, linetype = "dashed", color = "black") +
  coord_flip() +
  labs(
    title = "Logistic Regression Coefficients (Odds Ratios)",
    subtitle = "95% Confidence Intervals | OR > 1 increases dropout risk",
    x = "Predictor Variables",
    y = "Odds Ratio (log scale)"
  ) +
  scale_y_log10() +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 10),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold")
  )

# 6.X Random Forest (classification, probability predictions)
install.packages("ranger")
library(ranger)

# Copy data and make target a factor for classification
train_rf <- data.table::copy(train_data)
test_rf  <- data.table::copy(test_data)
train_rf[, Dropped_Out := factor(Dropped_Out, levels = c(0,1), labels = c("Stayed","Dropped"))]
test_rf[,  Dropped_Out := factor(Dropped_Out, levels = c(0,1), labels = c("Stayed","Dropped"))]

set.seed(123)
rf_fit <- ranger(
  formula   = Dropped_Out ~ .,
  data      = train_rf,
  probability = TRUE,        # get class probabilities
  mtry        = floor(sqrt(ncol(train_rf) - 1)),
  num.trees   = 500,
  min.node.size = 5,
  importance  = "impurity"
)

# Predict probabilities for the positive class ("Dropped")
rf_prob <- predict(rf_fit, data = test_rf)$predictions[, "Dropped"]
# Apply SAME 0.40 threshold you used for logistic
rf_pred <- ifelse(rf_prob >= 0.40, "Dropped", "Stayed")
rf_pred <- factor(rf_pred, levels = c("Stayed","Dropped"))

# Confusion matrix + metrics for RF
rf_cm <- table(Predicted = rf_pred, Actual = test_rf$Dropped_Out)
TN <- rf_cm["Stayed","Stayed"]; FP <- rf_cm["Dropped","Stayed"]
FN <- rf_cm["Stayed","Dropped"]; TP <- rf_cm["Dropped","Dropped"]

rf_accuracy <- (TP + TN) / sum(rf_cm)
rf_precision <- TP / (TP + FP)
rf_recall <- TP / (TP + FN)
rf_f1 <- 2 * rf_precision * rf_recall / (rf_precision + rf_recall)

cat("\n[Random Forest @ 0.40 threshold]\n")
cat("Accuracy :", round(rf_accuracy * 100, 2), "%\n")
cat("Precision:", round(rf_precision * 100, 2), "%\n")
cat("Recall   :", round(rf_recall * 100, 2), "%\n")
cat("F1 Score :", round(rf_f1 * 100, 2), "%\n")

# Variable importance plot (top 15)
imp <- as.data.frame(rf_fit$variable.importance)
imp$Variable <- rownames(imp)
colnames(imp)[1] <- "Importance"
imp <- imp[order(-imp$Importance), ][1:min(15, nrow(imp)), ]

ggplot(imp, aes(x = reorder(Variable, Importance), y = Importance)) +
  geom_col() +
  coord_flip() +
  labs(title = "Random Forest Variable Importance (Top 15)",
       x = "Feature", y = "Importance") +
  theme_minimal()

# 6.4. Predict on Test Data
test_data[, predicted_prob := predict(logit_model_train, newdata = test_data, type = "response")]

# 6.5. Classify based on 0.4 cutoff
test_data[, predicted_class := ifelse(predicted_prob >= 0.4, 1, 0)]

# 6.6. Confusion Matrix
confusion_matrix <- table(Predicted = test_data$predicted_class, Actual = test_data$Dropped_Out)

# Plot the confusion matrix
cm_df <- as.data.frame(confusion_matrix)
plot_labels <- c("0" = "Stayed", "1" = "Dropped Out")

ggplot(data = cm_df,
                aes(x = Actual,
                    y = Predicted,
                    fill = Freq)) +
  geom_tile(color = "black") +
  geom_text(aes(label = Freq),
            color = "black",
            size = 5,
            fontface = "bold") +
  scale_fill_distiller(palette = "Blues", direction = 1) +
  scale_x_discrete(labels = plot_labels) +
  scale_y_discrete(labels = plot_labels) +
  labs(
    title = "Confusion Matrix on Test Data",
    x = "Actual Outcome",
    y = "Predicted Outcome",
    fill = "Frequency"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5), # Center title
    axis.ticks = element_blank(),          # Remove axis ticks
    panel.grid = element_blank(),          # Remove grid lines
    legend.position = "none"             # Suppress legend
  )

# 6.7. Evaluation Metrics
TN <- confusion_matrix[1,1]
FP <- confusion_matrix[2,1]
FN <- confusion_matrix[1,2]
TP <- confusion_matrix[2,2]

# Calculate metrics
accuracy <- (TP + TN) / (TP + TN + FP + FN)
precision <- TP / (TP + FP)
recall <- TP / (TP + FN)
f1_score <- 2 * precision * recall / (precision + recall)

cat("Model Evaluation Metrics:\n")
cat("Accuracy :", round(accuracy * 100, 2), "%\n")
cat("Precision:", round(precision * 100, 2), "%\n")
cat("Recall   :", round(recall * 100, 2), "%\n")
cat("F1 Score :", round(f1_score * 100, 2), "%\n")

