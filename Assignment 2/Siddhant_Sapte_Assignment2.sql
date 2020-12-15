-- creating table and loading dataset 

drop database if exists sql_assignment_2;
create database if not exists sql_assignment_2;
use sql_assignment_2;
set global local_infile=1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

drop table if exists bed_fact;
create table bed_fact(
	ims_org_id varchar(255) not null,
    bed_id int(11) not null,
    license_beds int(11) default null,
    census_beds int(11) default null,
    staffed_beds int(11) default null
    );
    
load data local infile 'D:/Analytics/Quarter 5/sql/Assignment 2/bed_fact.csv'
into table bed_fact
fields terminated by ','
lines terminated by '\n'
ignore 1 rows
(ims_org_id, bed_id, license_beds, census_beds, staffed_beds);
select * from bed_fact;

drop table if exists bed_type;
create table bed_type(
	bed_id int(11) not null,
    bed_code varchar(255) default null,
    bed_desc varchar(255) default null,
    primary key(bed_id)
    );
    
load data local infile 'D:/Analytics/Quarter 5/sql/Assignment 2/bed_type.csv'
into table bed_type
fields terminated by ','
lines terminated by '\n'
ignore 1 rows
(bed_id, bed_code, bed_desc);
select * from bed_type;

drop table if exists business;
create table business(
	ims_org_id varchar(255) not null,
    business_name varchar(255) default null,
    ttl_license_beds int(11) default null,
    ttl_census_beds int(11) default null,
    ttl_staffed_beds int(11) default null,
    bed_cluster_id int(11) default null, 
    primary key(ims_org_id)
    );
    
load data local infile 'D:/Analytics/Quarter 5/sql/Assignment 2/business.csv'
into table business
fields terminated by ','
lines terminated by '\n'
ignore 1 rows
(ims_org_id, business_name, ttl_license_beds, ttl_census_beds, ttl_staffed_beds, bed_cluster_id);
select * from business;

-- 4a

-- 1
select b.business_name as Hospital_Name, sum(bf.license_beds) as Total_License_Beds
from business as b
left join bed_fact as bf on b.ims_org_id = bf.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by b.ims_org_id
order by Total_License_Beds desc
limit 10;

-- 2
select b.business_name as Hospital_Name, sum(bf.census_beds) as Total_Census_Beds
from bed_fact bf
left join business b on b.ims_org_id = bf.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by b.ims_org_id
order by Total_Census_Beds desc
limit 10;

-- 3
select b.business_name as Hospital_Name, sum(bf.staffed_beds) as Total_Staffed_Beds
from bed_fact bf
left join business b on b.ims_org_id = bf.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by b.ims_org_id
order by Total_Staffed_Beds desc
limit 10;

-- 4b
drop table if exists table_license;
create table table_license
select b.business_name as Hospital_Name, sum(bf.license_beds) as Total_License_Beds
from business as b
left join bed_fact as bf on b.ims_org_id = bf.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by b.ims_org_id
order by Total_License_Beds desc;

drop table if exists table_census;
create table table_census
select b.business_name as Hospital_Name, sum(bf.census_beds) as Total_Census_Beds
from bed_fact bf
left join business b on b.ims_org_id = bf.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by b.ims_org_id
order by Total_Census_Beds desc;

drop table if exists table_staffed;
create table table_staffed
select b.business_name as Hospital_Name, sum(bf.staffed_beds) as Total_Staffed_Beds
from bed_fact bf
left join business b on b.ims_org_id = bf.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by b.ims_org_id
order by Total_Staffed_Beds desc;

drop table if exists table_merged;
create table table_merged
select tl.Hospital_name, tl.Total_License_Beds, tc.Total_Census_Beds, ts.Total_Staffed_Beds from 
((table_license as tl
left join table_census as tc on tc.Hospital_Name = tl.Hospital_Name)
left join table_staffed as ts on ts.Hospital_Name = tl.Hospital_Name);

select * from table_merged;

select Hospital_name, Total_License_Beds from table_merged 
order by Total_License_Beds desc 
limit 3;

select Hospital_name, Total_Census_Beds from table_merged 
order by Total_Census_Beds desc 
limit 3;

select Hospital_name, Total_staffed_Beds from table_merged 
order by Total_staffed_Beds desc 
limit 3;

-- 5a

drop table if exists table_license;
create table table_license
select b.business_name as Hospital_Name, sum(bf.license_beds) as Total_License_Beds
from bed_fact as bf
left join bed_type as bt on bf.bed_id=bt.bed_id
left join business b on bf.ims_org_id = b.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by bf.ims_org_id
having
count(bf.bed_id)>1
order by Total_License_Beds desc;

drop table if exists table_census;
create table table_census
select b.business_name as Hospital_Name, sum(bf.census_beds) as Total_Census_Beds
from bed_fact as bf
left join bed_type as bt on bf.bed_id=bt.bed_id
left join business b on bf.ims_org_id = b.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by bf.ims_org_id
having
count(bf.bed_id)>1
order by Total_Census_Beds desc;

drop table if exists table_staffed;
create table table_staffed
select b.business_name as Hospital_Name, sum(bf.staffed_beds) as Total_Staffed_Beds
from bed_fact as bf
left join bed_type as bt on bf.bed_id=bt.bed_id
left join business b on bf.ims_org_id = b.ims_org_id
where bf.bed_id =4 or bf.bed_id=15
group by bf.ims_org_id
having
count(bf.bed_id)>1
order by Total_Staffed_Beds desc;


drop table if exists table_merged;
create table table_merged
select tl.Hospital_name, tl.Total_License_Beds, tc.Total_Census_Beds, ts.Total_Staffed_Beds from 
((table_license as tl
join table_census as tc on tc.Hospital_Name = tl.Hospital_Name)
join table_staffed as ts on ts.Hospital_Name = tl.Hospital_Name);

select * from table_merged;

select Hospital_name, Total_License_Beds from table_merged 
order by Total_License_Beds desc 
limit 10;

select Hospital_name, Total_Census_Beds from table_merged 
order by Total_Census_Beds desc 
limit 10;

select Hospital_name, Total_staffed_Beds from table_merged 
order by Total_staffed_Beds desc 
limit 10;













    

