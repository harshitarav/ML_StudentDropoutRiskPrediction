<img width="668" height="373" alt="image" src="https://github.com/user-attachments/assets/eb6fb941-fc5a-4508-8cb3-fb47b7c585f3" />

# Student Dropout Analysis and Risk Prediction

## Problem Statement 
- Schools face rising student dropouts, driven by academic struggles, low engagement, and social or family pressures.
- Identifying which students are at risk early enables targeted support, improves retention, and strengthens long-term academic outcomes.
- This project builds a data-driven predictive model to flag at-risk students and uncover key drivers of dropout, guiding timely, personalized interventions.

## Dataset Overview
- Source: Kaggle
- Combination of numerical and categorical variables
- The target variable churn is not balanced. i.e we can see the ratio of yes: no as - 73:27
- Target Variable:
  - `0` → Stayed  
  - `1` → Dropped Out  
- Key Feature Categories:
  - Academic Achievement (Grades, Study Time, Failures)
  - Family Environment (Parental Education, Family Support)
  - Social Behavior (Alcohol Use, Going Out, Relationship Status)
  - Aspirations (Higher Education Plans)
  - Institutional Factors (School Type, Extra Paid Classes)

## Exploratory Data Analysis
- ## Data Cleaning
- Loaded the dataset, checked and handled missing values across all columns to ensure completeness.
- Estimating the percentage of missing values for every feature and plotting it in a point plot
- Converted relevant categorical variables (e.g., School type, Address, Family Support, Internet Access, Relationship Status) to factor variables for analysis.
- Standardized numerical columns (like Age, Study Time, Number of Absences, and Grades) to ensure consistent formats.
- Removed redundant or irrelevant features that didn’t contribute to dropout prediction.
- Renamed columns for better readability and analysis consistency.
- Validated data integrity — checked for outliers, inconsistent codes, and logical value ranges (e.g., grades within valid limits).
- Encoded target variable:
  - 0 → Stayed  
  - 1 → Dropped Out
 


