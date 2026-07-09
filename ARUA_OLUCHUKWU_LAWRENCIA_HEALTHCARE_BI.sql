--OVERVIEW OF THE DATASET
SELECT * FROM fact_encounters fe 
SELECT * FROM fact_financial_summary 
SELECT * FROM fact_patients
SELECT * FROM fact_payers
SELECT * FROM fact_procedures 

--OPERATIONAL ANALYTICS
--1.How have inpatient encounter volume and Average Length of Stay (ALOS) changed over time.

--OVER THE YEARS
--For inpatient encounter volume
SELECT date_part('Year',start_date) AS Years, COUNT(encounter_id) AS Number_of_Patients
FROM fact_encounters fe 
WHERE date_part('Year',start_date) != 2025 AND fe.encounter_class = 'inpatient'
GROUP BY Years
ORDER BY Years

--For Average Length of Stay(ALOS)
SELECT date_part('Year', start_date) AS Years, COUNT(encounter_id) AS Number_of_Patients,
    ROUND(AVG(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS ALOS_in_days
FROM fact_encounters fe 
WHERE date_part('Year', start_date) != 2025 AND fe.encounter_class = 'inpatient'
GROUP BY Years
ORDER BY Years

--OVER THE MONTHS
--For inpatient encounter volume
SELECT to_char(start_date, 'Month') AS Months, COUNT(encounter_id) AS Number_of_Patients
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
GROUP BY to_char(start_date, 'Month'), date_part('month', start_date)
ORDER BY date_part('month', start_date)

--For Average Length of Stay(ALOS)
SELECT to_char(start_date, 'Month') AS Months, COUNT(encounter_id) AS Number_of_Patients,
    ROUND(AVG(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS ALOS_in_days
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
GROUP BY to_char(start_date, 'Month'), date_part('month', start_date)
ORDER BY date_part('month', start_date)

--OVER THE LAST 24 MONTHS
--For inpatient encounter volume
SELECT to_char(start_date, 'YYYY-Month') AS Year_Month, COUNT(encounter_id) AS Number_of_Patients
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient' 
AND start_date >= (SELECT MAX(start_date) FROM fact_encounters) - INTERVAL '24 months'
GROUP BY to_char(start_date, 'YYYY-Month'), date_trunc('month', start_date)
ORDER BY date_trunc('month', start_date)

--For Average Length of Stay(ALOS)
SELECT to_char(start_date, 'YYYY-Month') AS Year_Month, COUNT(encounter_id) AS Number_of_Patients,
    ROUND(AVG(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS ALOS_in_days
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
AND start_date >= (SELECT MAX(start_date) FROM fact_encounters) - INTERVAL '24 months'
GROUP BY to_char(start_date, 'YYYY-Month'), date_trunc('month', start_date)
ORDER BY date_trunc('month', start_date)

--2.Which departments are experiencing the highest inpatient workload?
SELECT fe.department, COUNT(fe.patient_id ) AS Workload
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
GROUP BY fe.department 
ORDER BY Workload DESC

--3.Which departments are associated with prolonged inpatient Length of Stay (LOS)?
SELECT fe.department, COUNT(fe.patient_id) AS Workload,
    ROUND(SUM(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS Los_in_days
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
GROUP BY fe.department
ORDER BY Los_in_days DESC

--4.Which procedures are most frequently performed, 
--and are certain procedures associated with prolonged Length of Stay (LOS) or increased operational burden?
--For Procedure Frequency
SELECT fp.procedure_description AS PROCEDURES, COUNT(fp.encounter_id) AS Procedure_Frequency
FROM fact_procedures fp  
GROUP BY PROCEDURES 
ORDER BY procedure_frequency DESC

--For Association of Procedure Frequency with Length of Stay and Operational Burden
SELECT fp.procedure_description AS procedures, COUNT(fe.encounter_id) AS procedure_frequency,
    ROUND(AVG(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS alos_in_days
FROM fact_procedures fp 
JOIN fact_encounters fe ON fp.encounter_id = fe.encounter_id
WHERE fe.encounter_class = 'inpatient' 
GROUP BY procedures
ORDER BY alos_in_days DESC


--CLINICAL ANALYTICS
--1.What diagnoses are driving inpatient hospital activity?
SELECT fe.diagnosis, COUNT(fe.patient_id) AS Number_of_Patients
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
GROUP BY diagnosis
ORDER BY Number_of_Patients DESC

--2.Are specific diagnoses, specialties, 
--or departments associated with higher inpatient burden or prolonged Length of Stay (LOS)?
--For diagnosis
SELECT fe.diagnosis, COUNT(fe.patient_id) AS Number_of_Patients,
ROUND(AVG(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS alos_in_days
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
GROUP BY diagnosis
ORDER BY alos_in_days DESC

--For specialties
SELECT fe.subspecialty, COUNT(fe.patient_id) AS Number_of_Patients,
ROUND(AVG(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS alos_in_days
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
GROUP BY subspecialty
ORDER BY alos_in_days DESC

--For department
SELECT fe.department, COUNT(fe.patient_id) AS Number_of_Patients,
ROUND(AVG(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS alos_in_days
FROM fact_encounters fe 
WHERE fe.encounter_class = 'inpatient'
GROUP BY department
ORDER BY alos_in_days DESC

--3.What proportion of patients had another inpatient encounter within 30 days of discharge?
WITH inpatient AS (
    SELECT fe.patient_id, fe.encounter_id, fe.start_date AS admission_date, fe.stop_date AS discharge_date,
          LEAD(fe.start_date) OVER (PARTITION BY fe.patient_id ORDER BY fe.start_date) AS next_admission_date
    FROM fact_encounters fe
    WHERE fe.encounter_class = 'inpatient')
SELECT COUNT(DISTINCT patient_id) AS total_unique_inpatients,
       COUNT(DISTINCT CASE WHEN next_admission_date <= discharge_date + INTERVAL '30 days' 
       THEN patient_id END) AS readmitted_patients,
       ROUND(COUNT(DISTINCT CASE WHEN next_admission_date <= discharge_date + INTERVAL '30 days' 
       THEN patient_id END) * 100.0/COUNT(DISTINCT patient_id), 2) AS readmission_rate_percentage
FROM inpatient

--4.Which diagnoses or departments are associated with higher readmission patterns or rates?
--For diagnosis
WITH inpatient AS (
  	 SELECT fe.patient_id, fe.encounter_id, fe.diagnosis, fe.stop_date AS discharge_date,
        LEAD(fe.start_date) OVER (PARTITION BY fe.patient_id ORDER BY fe.start_date) AS next_admission_date
    FROM fact_encounters fe
    WHERE fe.encounter_class = 'inpatient')
SELECT diagnosis,COUNT(DISTINCT patient_id) AS total_patients_treated,
	   COUNT(DISTINCT CASE WHEN next_admission_date <= discharge_date + INTERVAL '30 days' 
	   THEN patient_id END) AS readmitted_patients,
       ROUND(COUNT(DISTINCT CASE WHEN next_admission_date <= discharge_date + INTERVAL '30 days' 
       THEN patient_id END) * 100.0 / COUNT(DISTINCT patient_id), 2) AS readmission_rate_percentage
FROM inpatient
WHERE diagnosis IS NOT NULL
GROUP BY diagnosis
ORDER BY readmission_rate_percentage DESC

--For department
WITH inpatient AS (
    SELECT fe.patient_id, fe.encounter_id, fe.department, fe.stop_date AS discharge_date,
         LEAD(fe.start_date) OVER (PARTITION BY fe.patient_id ORDER BY fe.start_date) AS next_admission_date
    FROM fact_encounters fe
    WHERE fe.encounter_class = 'inpatient')
SELECT department, COUNT(DISTINCT patient_id) AS total_patients_discharged,
      COUNT(DISTINCT CASE WHEN next_admission_date <= discharge_date + INTERVAL '30 days'
      THEN patient_id END) AS readmitted_patients,
      ROUND(COUNT(DISTINCT CASE WHEN next_admission_date <= discharge_date + INTERVAL '30 days'
      THEN patient_id END) * 100.0 / COUNT(DISTINCT patient_id), 2) AS readmission_rate_percentage
FROM inpatient
WHERE department IS NOT NULL
GROUP BY department
ORDER BY readmission_rate_percentage DESC

--FINANCIAL ANALYTICS
--1.How have hospital charges and payments changed over time?
SELECT date_part('Year',start_date) AS Years, SUM(ffs.total_charges) AS Hospital_charges,
	   SUM(ffs.patient_payments) AS Patient_payments 
FROM fact_financial_summary ffs 
JOIN fact_encounters fe ON ffs.encounter_id = fe.encounter_id
GROUP BY Years 
ORDER BY Years

--2.What is the distribution of insurance versus patient payments across the hospital system?
SELECT date_part('Year',start_date) AS Years, SUM(ffs.insurance_payments ) AS Insurance,
	   SUM(ffs.patient_payments) AS Patient_payments 
FROM fact_financial_summary ffs 
JOIN fact_encounters fe ON ffs.encounter_id = fe.encounter_id
GROUP BY Years 
ORDER BY Years

--3.How does financial activity vary across departments 
--with different operational workloads and Length of Stay (LOS) patterns? 
SELECT fe.department,COUNT(ffs.encounter_id) AS Workload, 
	   ROUND(AVG(EXTRACT(EPOCH FROM (fe.stop_date - fe.start_date)) / 86400)::numeric, 1) AS alos_in_days,
	   ROUND(AVG(ffs.total_charges),2) AS Average_Hospital_Charges
FROM fact_financial_summary ffs 
JOIN fact_encounters fe ON ffs.encounter_id = fe.encounter_id
WHERE fe.encounter_class = 'inpatient'
GROUP BY department

--FOR READMISSION RATE
--vw_readmissions
CREATE VIEW vw_readmissions AS 
WITH patient_timeline AS (
    SELECT patient_id, encounter_id, encounter_class,start_date AS admission_date, 
    stop_date AS discharge_date,
    LEAD(start_date) OVER(PARTITION BY patient_id ORDER BY start_date) AS next_admission_date
    FROM fact_encounters
    WHERE encounter_class = 'inpatient')

SELECT patient_id, encounter_id, encounter_class, admission_date, discharge_date, next_admission_date,
	   next_admission_date - discharge_date AS days_of_readmissions,
       CASE WHEN next_admission_date IS NOT NULL 
       AND (next_admission_date - discharge_date) <= INTERVAL'30 days'
       AND (next_admission_date - discharge_date) > INTERVAL '0 days'
        THEN 1
        ELSE 0
    END AS readmission_flag
FROM patient_timeline

--vw_master_kpi
CREATE VIEW vw_master_kpi AS
SELECT ROUND(AVG(readmission_flag) * 100,2) AS "30-Day_Readmission_Rate"
FROM vw_readmissions

SELECT * FROM vw_master_kpi