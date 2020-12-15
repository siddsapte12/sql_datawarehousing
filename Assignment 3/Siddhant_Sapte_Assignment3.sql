create database if not exists sql_assginment3;
use sql_assginment3;

-- Q5

select * from public_housing_inspections;
select PHA_NAME, MR_INSPECTION_DATE, MR_INSPECTION_COST, SECOND_MR_INSPECTION_DATE, SECOND_MR_INSPECTION_COST, CHANGE_IN_COST, PERCENT_CHANGE_IN_COST
from (
select PUBLIC_HOUSING_AGENCY_NAME as PHA_NAME,
	   DATE_OF_INSPEC as MR_INSPECTION_DATE,
       COST_OF_INSPECTION_IN_DOLLARS as MR_INSPECTION_COST,
	   lead(DATE_OF_INSPEC,1) over (partition by public_housing_agency_name order by DATE_OF_INSPEC desc) as SECOND_MR_INSPECTION_DATE,
       lead(COST_OF_INSPECTION_IN_DOLLARS,1) over (partition by public_housing_agency_name order by DATE_OF_INSPEC desc) as SECOND_MR_INSPECTION_COST,
       COST_OF_INSPECTION_IN_DOLLARS - lead(COST_OF_INSPECTION_IN_DOLLARS,1) over (partition by public_housing_agency_name order by DATE_OF_INSPEC desc) as CHANGE_IN_COST,
       
       (((COST_OF_INSPECTION_IN_DOLLARS) - (lead(COST_OF_INSPECTION_IN_DOLLARS,1) over (partition by PUBLIC_HOUSING_AGENCY_NAME order by DATE_OF_INSPEC desc))) 
       /(lead(COST_OF_INSPECTION_IN_DOLLARS,1) over (partition by PUBLIC_HOUSING_AGENCY_NAME order by DATE_OF_INSPEC desc)))
       * 100 as PERCENT_CHANGE_IN_COST,
       row_number() over(partition by PUBLIC_HOUSING_AGENCY_NAME) as sit
from 
(select *, STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y') AS DATE_OF_INSPEC
from public_housing_inspections)as pha)as pha_final
where PERCENT_CHANGE_IN_COST > 0 and (sit = 1);
