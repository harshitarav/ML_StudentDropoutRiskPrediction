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

 ### **Univariate Analysis**
- Examined the distribution of key numerical features such as **Age**, **Study Time**, **Number of Failures**, and **Absences**.  
- Majority of students have:
  - Study Time between 1–3 hours per day.  
  - 0–1 course failures.  
  - Less than 10 absences.  
- Grades show a wide spread — indicating academic performance varies strongly across the population.  
- Visualized individual features to identify skewness and potential outliers.

 ### **Bivariate Analysis**
- Compared categorical and numerical features against the **Dropped Out** target variable to uncover behavioral and academic patterns:  

| Feature | Observation |
|----------|--------------|
| **Grade 1 (First-Term Marks)** | Lower early grades strongly correlate with higher dropout rates. |
| **Number of Failures** | Each additional failure increases dropout likelihood by ~34%. |
| **Study Time** | Students who dedicate more study hours are 19% less likely to drop out. |
| **Wants Higher Education** | Students aspiring for higher studies have 54% lower dropout odds. |
| **Relationship Status** | Students in a relationship are 93% more likely to drop out. |
| **Family Relationship Quality** | Stronger family relationships reduce dropout by 15%. |
| **Extra Paid Classes** | Surprisingly, students taking paid classes show 3x higher dropout odds, indicating underlying stress or burnout. |
| **School Type (GP vs MS)** | Students in GP school have 51% lower dropout risk. |
| **Alcohol Consumption (Weekday/Weekend)** | Moderate weekend consumption shows slightly lower dropout, possibly due to balanced social activity. |

### **Correlation Analysis**
- Computed correlation of numeric predictors with the dropout variable to identify strong linear relationships.  
- Found that **low academic grades, frequent absences, and multiple failures** are the top positive correlates with dropout.  
- **Higher study time and family relationship quality** show a strong negative correlation, indicating protective factors.  
- These insights guided the selection of predictors for the logistic regression model.
<img width="940" height="283" alt="image" src="https://github.com/user-attachments/assets/e9299d3c-82c4-4555-847e-307500dc319b" />

## Model Building
