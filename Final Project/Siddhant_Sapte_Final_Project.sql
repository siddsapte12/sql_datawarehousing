create database if not exists sql_final_project;
use sql_final_project;

#creating tables and importing data
CREATE TABLE IF NOT EXISTS dim_patient(
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    member_first_name varchar(255) NOT NULL,
    member_last_name varchar(255) NOT NULL,
    member_birth_date varchar(255) NOT NULL,
    member_age INT NOT NULL,
    member_gender varchar(255) NOT NULL,
	UNIQUE KEY unique_member_id (member_id)
);

select * from dim_drug_desc;

select * from dim_patient;

# drug desc
CREATE TABLE IF NOT EXISTS dim_drug_desc(
    drug_ndc INT AUTO_INCREMENT PRIMARY KEY,
    drug_name varchar(255) NOT NULL,
    drug_form_code varchar(255) not null,
    drug_brand_generic_code int(11) not null,
	UNIQUE KEY unique_drug_ndc (drug_ndc)
);
# drug brand
CREATE TABLE IF NOT EXISTS dim_drug_brand(
    drug_brand_generic_code INT AUTO_INCREMENT PRIMARY KEY,
    drug_brand_generic_desc varchar(255) NOT NULL,
	UNIQUE KEY unique_drug_brand_generic_code (drug_brand_generic_code)
);
# drug form
CREATE TABLE IF NOT EXISTS dim_drug_form(
    drug_form_code char(2) PRIMARY KEY,
    drug_form_desc varchar(255) NOT NULL,
	UNIQUE KEY unique_drug_form_code (drug_form_code)
);

ALTER TABLE dim_drug_desc
ADD FOREIGN KEY drug_form_code_fk(drug_form_code)
REFERENCES dim_drug_form(drug_form_code)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE dim_drug_desc
ADD FOREIGN KEY drug_brand_generic_code_fk(drug_brand_generic_code)
REFERENCES dim_drug_brand(drug_brand_generic_code)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

#fact table
CREATE TABLE IF NOT EXISTS fact_table(
	fact_ins_id int auto_increment primary key,
    member_id int not null,
    drug_ndc int not null,
    ﻿fill_date varchar(255),
    copay int,
    insurancepaid int,
	UNIQUE KEY unique_fact_ins_id (fact_ins_id)
);

LOAD DATA LOCAL INFILE 'D:/Analytics/Quarter 5/sql/Final Project/fact_table.csv'
INTO TABLE sql_final_project.fact_table 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(member_id,drug_ndc,fill_date,copay,insurancepaid);

UPDATE fact_table
SET ﻿fill_date = str_to_date( ﻿fill_date, '%m/%d/%Y' );

select * from fact_table;

ALTER TABLE fact_table
ADD FOREIGN KEY member_id_fk(member_id)
REFERENCES dim_patient(member_id)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE fact_table
ADD FOREIGN KEY drug_ndc_fk(drug_ndc)
REFERENCES dim_drug_desc(drug_ndc)
ON DELETE RESTRICT
ON UPDATE RESTRICT;


#part 
#q1
select ds.drug_name, count(f.﻿fill_date) as no_of_prescription
from fact_table as f
join dim_drug_desc as ds on ds.drug_ndc = f.drug_ndc
group by ds.drug_name;

#q2
select p.member_id, ds.drug_name, count(f.﻿fill_date) as total_prescription, 
sum(f.copay) as total_copay, sum(f.insurancepaid) as total_insurance,
case
	when p.member_age<65 then '< 65 +'
    when p.member_age>=65 then 'age 65+'
end as age_cat
from ((fact_table as f
join dim_patient as p on p.member_id = f.member_id)
join dim_drug_desc as ds on ds.drug_ndc = f.drug_ndc)
group by age_cat;

#q3
select member_id, ﻿fill_date,member_first_name,member_last_name,drug_name,insurancepaid
from (select m.member_id, f.﻿fill_date,m.member_first_name,m.member_last_name,d.drug_name,f.insurancepaid,
row_number() over (partition by m.member_id order by f.﻿fill_date desc) as flag
from ((fact_table as f join dim_patient as m 
on f.member_id = m.member_id) join
dim_drug_desc as d 
on f.drug_ndc = d.drug_ndc)) as t
where flag = 1;




  




