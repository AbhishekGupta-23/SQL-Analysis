select * from dbo_data1;
select * from dbo_data2;
--1-> number of rows into our dataset

select count(*) from dbo_data1;
select count(*) from dbo_data2;

--2-> dataset for jahrkhand and bihar

select * from dbo_data1
where "States" in ('Jharkhand','Bihar');

--3-> total population of india

select sum(population) as population from dbo_data2;

--4-> avg growth of india

select avg(Growth)*100 as avg_growth from dbo_data1; 

--5-> avg growth by each state (used aggregate funcion)

select states, avg(growth)*100 as avg_state_growth from dbo_data1
group by states
order by avg_state_growth desc;

--6-> avg sex_ratio 

select states, round(avg(sex_ratio),0) as avg_sex_ratio from dbo_data1
group by states
order by avg_sex_ratio desc;

--7-> avg litreacy rate

select states,avg(litreacy) as avg_litreacy from dbo_data1
group by states having avg(litreacy) > 90
order by avg_litreacy desc;

--8-> top 3 states showing highest growth ratio

select states, avg(growth)*100 as avg_state_growth from dbo_data1
group by states
order by avg_state_growth desc
limit 3;

--9-> bottom 3 states with lowest sex ratio

select states, round(avg(sex_ratio),0) as avg_sex_ratio from dbo_data1
group by states
order by avg_sex_ratio
limit 3;

--10-> top and bottom 3 states in litreacy rates

create table topstates (
state varchar(70),
topstate float
);
insert into topstates 
select states,avg(litreacy) as avg_litreacy from dbo_data1
group by states 
order by avg_litreacy desc;
select * from topstates
limit 3;

create table bottomstates (
state varchar(70),
bottomstate float
);
insert into bottomstates 
select states,avg(litreacy) as avg_litreacy from dbo_data1
group by states 
order by avg_litreacy;
select * from bottomstates
limit 3;

--union function 
select * from (
	select * from topstates order by topstate desc limit 3) a
union
select * from (
	select *  from bottomstates order by bottomstate asc limit 3) b;

--11-> all state names with letter a or b

select distinct states from dbo_data1 
where states like 'A%' or states like 'B%';

--12-> number of males and females(could not get)

--joining 2 tables
select c.district, c.states,c.population/(c.sex_ratio+1) males,(c.population*c.sex_ratio)/(c.sex_ratio+1) females from
(select db1.district ,db1.states,db1.sex_ratio/1000,db2.population from dbo_data1  db1
join dbo_data2 db2 using (district)) c;

--13-> litreacy people in different states(could not get)

select a.district,a.states,a.litreacy_ratio*a.population as literate_people, (1-a.litreacy_ratio)*a.population as illiterate_people from 
(select db1.district, db1.states, db1.litreacy/100 as litreacy_ratio, db2.population from dbo_data1 db1
join dbo_data2 db2 using (district)) a;

--14-> population in previous year

select sum(b.previous_yr_pop) as pre_yr_total, sum(b.current_census_pop) as cur_yr_total from
(select a.states,sum(a.previous_yr_pop) as pre_yr,sum(a.current_census_pop) as cur_yr from
(select d.district,d.states,d.population/(1-d.growth) as previous_yr_pop,d.population as current_census_pop from 
(select d1.district,d1.states,d1.growth,d2.population from dbo_data1 d1 
join dbo_data2 d2 using (district)) d) a
group by a.states)b
order by a.states;





































































