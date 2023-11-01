--Analyzing this dataset to provid the various aspect of tourism trends 

--1. Calcaute the yearly Average for each Toruisum category 
Select 
cast (split_part (quarter , ' ',  2) as INTEGER)  as year,
  avg(commodities) 
  		as avg_commodities,
  avg(total_tourism_commodities) 
  		as avg_total_tourism_commodities,
  avg(transportation) 
  		as avg_transportation
  from  
  tourism_data
		Group by 
  		year
			order by  
  		year;
		
		
		
--		Find the quator with the Highest total tourium commodities 
select quarter, total_tourism_commodities
From tourism_data
where 
	total_tourism_commodities = (select max(total_tourism_commodities) from  tourism_data);
	
	
	--trend in the passenger Air transport over the years 
 
--extract (year  from  TO_DATE(quarter, 'Q" "YYYY'))as year ,
  select 
   substring (quarter from position  (' ' in  quarter) +1) as year,
  avg (passenger_air_transport) as avg_passenger_air_transport
from 
  tourism_data
group by  year
order by year ;





  -- Caulcating the percentage changein Vehicle rental from q1 2015 to q1 2016 
  
  with   vehicle_rentalchange as (
  	select quarter,
  	vehicle_rental,
  		lag(vehicle_rental) over (order by to_date(regexp_replace(quarter,'Q(\d) (\d+)', '\2-\1'), 'YYYY-Q')) as prev_vehicle_rental 
  
	  from tourism_data )
select 
	quarter,vehicle_rental,((vehicle_rental - prev_vehicle_rental) / prev_vehicle_rental) * 100 AS percentage_change
FROM 
  vehicle_rentalchange
WHERE 
  quarter IN ('Q1 2015', 'Q1 2016');
--  //usign regexp replace to "q"
 


--calcuate the cumlative sum of accommodation expenditures over time 

select 
quarter,
accommodation, 
--sum (accommodation )over (order by to_date (substring (quarter FROM 3), 'YYYY-Q')) as cumulative_accommodation
TO_DATE(SUBSTRING(quarter FROM 3), 'YYYY-Q') AS converted_date
from 
  tourism_data;

