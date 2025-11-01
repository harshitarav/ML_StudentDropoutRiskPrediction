# Student Dropout Analysis and Risk Prediction

## Problem Question
How can we proactively identify and support at-risk students to reduce dropouts before they occur?

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
- **Target Variable Balance Check**
  - Checked the class distribution of the target variable (Dropped_Out) and found an imbalance — around 15% of students dropped out versus 85% who continued.
  - Since the goal was to proactively identify at-risk students, Recall was prioritized over Accuracy during model evaluation to ensure more true dropouts were captured.
  - This guided later model tuning and threshold adjustment instead of synthetic oversampling.

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

<img width="347" height="204" alt="Rplot" src="https://github.com/user-attachments/assets/a34fe019-85be-400b-8af2-fe5f39f7f06a" />

<img width="831" height="497" alt="image" src="https://github.com/user-attachments/assets/cfb14e16-f862-4e13-888c-788b6748166a" />


### **Correlation Analysis**
- Computed correlation of numeric predictors with the dropout variable to identify strong linear relationships.  
- Found that **low academic grades, frequent absences, and multiple failures** are the top positive correlates with dropout.  
- **Higher study time and family relationship quality** show a strong negative correlation, indicating protective factors.  
- These insights guided the selection of predictors for the logistic regression model.
<img width="940" height="283" alt="image" src="https://github.com/user-attachments/assets/e9299d3c-82c4-4555-847e-307500dc319b" />

## Model Building
- **Train/Test Split:** Partitioned the dataset into training and test sets to evaluate out-of-sample performance.
- **Baseline Models:** Trained two supervised classifiers — **Logistic Regression** (with regularization) and **Random Forest** — to predict dropout.
- **Feature Engineering:** Created/standardized inputs from academic, behavioral, and family-context features; retained interpretable features to enable policy actions.
- **Model Selection:** Chose **Logistic Regression** over **Random Forest** based on validation metrics — **Recall: 73% vs. 65%**, with **~90% accuracy** for both — favoring better generalization and transparent coefficients for stakeholder buy-in.
- **Interpretability:** Interpreted **odds ratios** to identify key risk drivers (e.g., low first-period grades, study time, absences, higher-education aspiration, school type), enabling targeted early interventions.  
- **Evaluation:** Reported Accuracy, Precision, Recall, and AUC on the test set; performed sensitivity checks on thresholds to balance false negatives/positives.
- **Reproducibility:** Encapsulated preprocessing + model training into a pipeline for consistent re-runs and deployment readiness.

## Model Evaluation and Insights
- Evaluated model using Accuracy, Precision, Recall, F1-score, and ROC-AUC metrics on the test set.
- Achieved **~90% accuracy** and **73% recall**, ensuring strong identification of at-risk students.
- Visualized ROC curve and confusion matrix to validate model robustness.

<img width="734" height="395" alt="image" src="https://github.com/user-attachments/assets/345065e9-5cda-493f-9042-7dfd9261d7d2" />

**TOP 5 DRIVERS OF STUDENT DROPOUT**
- 📚 Low Early Grades → Strongest predictor of dropout.
- 📖 Extra Classes → Students taking extra classes still show high dropout risk.
- 🎓 No Higher Education Aspiration → Doubles dropout risk.
- 🏫 School Type Matters → GP School students perform better.
- 💬 Relationship Status → Students in relationships have slightly higher risk.

## Recommendations
Based on the model insights and key dropout predictors, the following recommendations are proposed to reduce student dropout rates:
1. **Monitor Early Academic Performance**  
   - Implement continuous tracking systems for first-term grades and attendance.
   - Flag students showing early academic decline for timely counseling or tutoring support.

2. **Strengthen Academic Support Programs**  
   - Introduce peer-mentoring, remedial classes, and adaptive learning plans for low performers.
   - Ensure early interventions for students with repeated course failures or low study hours.

3. **Promote Future Aspirations**  
   - Encourage career awareness programs and higher education counseling.
   - Strengthen teacher-student mentoring to build long-term academic goals.

4. **Leverage Best Practices Across Schools**  
   - Share successful retention initiatives between schools (e.g., study skill workshops, parental engagement models).
   - Create data-driven dashboards to benchmark school-level dropout risks.

5. **Address Social and Lifestyle Factors**  
   - Conduct awareness campaigns on maintaining healthy social habits.
   - Offer counseling on relationship management, stress handling, and alcohol moderation.




