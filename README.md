# Hospital Performance, Clinical Outcomes & Financial Sustainability Analysis

**By Arua Oluchukwu Lawrencia** | Healthcare Data Analyst | Medical Radiographer

An end-to-end healthcare business intelligence project analyzing 16,600 inpatient encounters across operational, clinical, and financial dimensions to identify what's driving prolonged hospital stays, recurring readmissions, and rising costs.

## Dashboard

<img width="1919" height="1079" alt="Screenshot 2026-07-08 203113" src="https://github.com/user-attachments/assets/5159394f-8656-4e19-976a-a40ef4d31fb2" />


**[View the Interactive Tableau Story ](https://public.tableau.com/views/ARUA_OLUCHUKWU_LAWRENCIA_HEALTHCARE_BI/HEALTHCAREBI?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

**[Read the full write-up on Medium ](https://medium.com/@aruaoluchilaw/hospital-performance-clinical-outcomes-financial-sustainability-analysis-42065b129dc2)**

---

## Project Background

Hospitals continuously face the challenge of balancing patient care quality, operational efficiency, and financial sustainability. Increasing inpatient demand, prolonged hospital stays, and recurring admissions place significant pressure on healthcare resources and organizational performance.

## Business Problem

Hospital leadership observed increasing strain on inpatient capacity, longer-than-expected patient stays, recurring admissions after discharge, and rising financial exposure, raising concerns about operational efficiency, patient outcomes, and resource utilization.

## Project Objectives

- Identify drivers of prolonged Length of Stay (LOS).

- Evaluate inpatient workload across departments and specialties.

- Examine readmission patterns within 30 days of discharge.

- Assess relationships between operational performance and financial activity.

- Generate actionable recommendations to improve hospital efficiency and patient outcomes.

## Tools Used

`PostgreSQL` · `SQL` · `Tableau`

## Analytical Process

1. **Data Preparation**: Explored hospital datasets, filtered inpatient encounters.

2. **SQL Analysis**:  Generated KPIs, performed readmission analysis, analyzed workload and Length of Stay ((ARUA_OLUCHUKWU_LAWRENCIA_HEALTHCARE_BI.sql))

3. **Tableau Visualization**:  Built operational, clinical, and financial dashboards, combined into an interactive Tableau Story

---

## Dashboards

### Operational Analysis
<img width="1734" height="858" alt="Screenshot 2026-07-08 201830" src="https://github.com/user-attachments/assets/9de6a46c-dc5c-44be-80f3-f5163c0b8069" />


Internal Medicine carries the highest inpatient workload (14K encounters) and longest average Length of Stay (5.4 days) of any department. Bone marrow transplantation and amputative procedures are the biggest contributors to prolonged stays.

### Clinical Analysis
<img width="1913" height="868" alt="Screenshot 2026-07-08 201757" src="https://github.com/user-attachments/assets/bbb0b9d0-02c6-462b-85f1-cf2c25df90e1" />


30-day readmission rate: **12.59%**. Pulmonology, Cardiology, and Psychiatry carry the highest inpatient workload by subspecialty; Endocrinology patients have the longest average stay (20.7+ days). Internal Medicine leads department-level readmission rates at ~15%.

### Financial Analysis
<img width="1745" height="868" alt="Screenshot 2026-07-08 201817" src="https://github.com/user-attachments/assets/961fbefe-cf60-44fe-8a80-508002c7392f" />


Total hospital charges: **2.68B**, with insurance payments (2.17B) covering the vast majority of revenue over patient payments (512.6M). Internal Medicine generates the highest average charges per department, directly tracking its operational burden.

---

## Key Insights & Recommendations

### Operational

**Insight:** Internal Medicine is the most burdened department across volume, LOS, and complexity of procedures performed.

**Recommendations:** Strengthen discharge planning, build dedicated pathways for high-LOS procedures, monitor high-burden departments continuously, optimize bed allocation.

### Clinical

**Insight:** Chronic and respiratory conditions (diabetes-related neuropathy, COPD, pulmonary emphysema) drive both the longest stays and the highest readmission concentration, centered in Internal Medicine.

**Recommendations:** Increase post-discharge monitoring for high-risk patients, improve multidisciplinary care coordination, implement predictive risk stratification, strengthen chronic disease management programs.

### Financial

**Insight:** Financial activity tracks operational burden directly as departments with higher workload and longer LOS generate the greatest hospital charges.

**Recommendations:** Monitor high-LOS departments as a financial risk indicator, align resource allocation with workload demand, reduce avoidable inefficiencies, improve financial planning around payer dependence.

## Conclusion

Patient complexity is the common thread connecting operational strain, clinical outcomes, and financial performance. Internal Medicine consistently emerged as the department under the greatest pressure, while complex procedures and chronic conditions drove prolonged hospitalization and resource consumption. The findings demonstrate how integrating operational, clinical, and financial analytics can support better patient outcomes, more efficient resource use, and long-term organizational sustainability.

---

## Repository Contents

| File | Description |
|---|---|
| `ARUA_OLUCHUKWU_LAWRENCIA_HEALTHCARE_BI.sql` | Full SQL analysis |
| `ARUA_OLUCHUKWU_LAWRENCIA_HEALTHCARE_BI.docx` | Executive summary report |

## Tools Used

- **PostgreSQL/Dbeaver** — granular analysis and insight generation
- **Tableau** — visualization, dashboard design, interactive reporting

## About

Built by **Arua Oluchukwu Lawrencia**, a data analyst specializing in SQL and Tableau.

- 🔗 [Medium](https://medium.com/@aruaoluchilaw)
- 💼 [LinkedIn](https://linkedin.com/in/oluchukwu-arua-law2349043419246)
- 🐦 [X (Twitter)](https://twitter.com/OluchukwuArua)


