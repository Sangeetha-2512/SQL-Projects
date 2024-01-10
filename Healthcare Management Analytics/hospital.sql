--	1.List all distinct hospital names from the table.
select distinct hospital from hospital_management
-- 1.1.Retrieve all columns for patients with the medical condition "Diabetes" under Age 25
select * from hospital_management
where medical_condition='Diabetes' and age=25
--1.2.Count the number of male and female patients in the dataset.
select  gender,count(gender) as gender_count from hospital_management
group by gender
--1.3.Retrieve the names of patients who were admitted in the recent month
select name from hospital_management 
where date_admission=
(select max(date_admission) from hospital_management)
-- 1.4.Calculate the average billing amount for all admissions.
select admission_type,round(avg(billing_amount),2) from hospital_management 
group by admission_type 
order by 1
--1.5.Identify the most common medical condition among patients.
--Solution 1
select medical_condition from
(select medical_condition,count(name)
from hospital_management 
group by medical_condition
order by 2 desc )
where rownum=1
--Solution 2
with temp1 as
(select medical_condition,count(name) as patient_cnt
from hospital_management 
group by medical_condition
order by 2 desc),
temp2 as
(select medical_condition,patient_cnt, rank() over(order by patient_cnt desc) as rnk
from temp1)
select medical_condition from temp2
where rnk=1
--1.6.Display the top 5 hospitals with the highest billing amounts.
select hospital from
(select hospital,sum(billing_amount) as tot_amt
from hospital_management 
group by hospital
order by 2 desc)
where rownum between 1 and 5
--------------------------
--2.1.Retrieve the names of patients who stayed in the hospital for more than 10 days.
select name,discharge_date-date_admission from hospital_management
where discharge_date-date_admission  >10
--2.2.Identify the patients who had multiple admissions.
select name ,fam_pt from (select name,count(name) as fam_pt from hospital_management 
group by name)
where fam_pt>1
--2.3.Identify the rooms with the highest number of admissions.
select room_no from
(select room_no,rank() over (order by cta desc) rnk from (select room_no,count(name) cta
from hospital_management group by room_no)) where rnk=1
--2.4.Calculate the percentage of male and female patients for each blood type.
select blood_type,
rpad(round((count(case when Gender='Male' then 1 else null end)/count(*))*100,2),6,'%') as M_Perc,
rpad(round((count(case when Gender='Female' then 1 else null end)/count(*))*100,2),6,'%') as F_Perc 
from hospital_management
group by blood_type
--2.5.Identify the doctors who have treated patients in more than one hospital.
select doctor from (select doctor,count(hospital) cnt from hospital_management 
group by doctor) where cnt> 1





