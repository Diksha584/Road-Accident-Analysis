select * from road_accident;

-- 1. CY Casualties

SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = 2021;

-- 2. CY Accidents

SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = 2021 and road_surface_conditions = 'Dry';
select count(distinct accident_index) as CY_Accidents
from road_accident
where year(accident_date)=2021;

-- 3.CY Fatal Casualties

SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM road_accident
where year(accident_date)=2021 and accident_severity='Fatal';

-- 4. CY Serious Casualties

SELECT SUM(number_of_casualties) AS CY_Serious_Casualties
FROM road_accident
where year(accident_date)=2021 and accident_severity='Serious';

-- 5.CY Slight Casualties

SELECT SUM(number_of_casualties) AS CY_Slight_Casualties
FROM road_accident
where year(accident_date)=2021 and accident_severity='Slight';
SELECT SUM(number_of_casualties) AS CY_Slight_Casualties
FROM road_accident
where  accident_severity='Slight';
select cast(sum(number_of_casualties) as decimal(10,2))*100 /
(select cast(sum(number_of_casualties)as decimal(10,2))from road_accident) as PCT
from road_accident
where accident_severity='Slight';
select cast(sum(number_of_casualties) as decimal(10,2))*100 /
(select cast(sum(number_of_casualties)as decimal(10,2))from road_accident) as PCT
from road_accident
where accident_severity='Serious';
select cast(sum(number_of_casualties) as decimal(10,2))*100 /
(select cast(sum(number_of_casualties)as decimal(10,2))from road_accident) as PCT
from road_accident
where accident_severity='Fatal';

-- 6.Vehicle-wise Casualties Analysis

select
case
when vehicle_type in('Agricultural vehicle') then 'Agricultural'
when vehicle_type in('Car' , 'Taxi/Private hire car') then 'Cars'
when vehicle_type in('Motorcycle 125cc and under', 'Motorcycle 50cc and under','Motocycle over 125cc and up to 500cc', 'Motocycle over 500cc', 'Pedal cycle') then 'Bike'
when vehicle_type in('Bus or coach (17 or more pass seats)', 'Minibus(8 - 16 passenger seats)') then 'Bus'
when vehicle_type in('Goods tonnes mgw and over', 'Goods over 3.5t and under 7.5t', 'Van / Goods 3.5 toones  mgw or under') then 'Van'
else 'Other'
end as Vehicle_group,
sum(number_of_casualties) as Cy_Casualties
from road_accident
where year(accident_date)=2021
group by
case
when vehicle_type in('Agricultural vehicle') then 'Agricultural'
when vehicle_type in('Car' , 'Taxi/Private hire car') then 'Cars'
when vehicle_type in('Motorcycle 125cc and under', 'Motorcycle 50cc and under','Motocycle over 125cc and up to 500cc', 'Motocycle over 500cc', 'Pedal cycle') then 'Bike'
when vehicle_type in('Bus or coach (17 or more pass seats)', 'Minibus(8 - 16 passenger seats)') then 'Bus'
when vehicle_type in('Goods tonnes mgw and over', 'Goods over 3.5t and under 7.5t', 'Van / Goods 3.5 toones  mgw or under') then 'Van'
else 'Other'
end ;

-- 7.Monthly Trend of Casualties

SELECT 
    MONTHNAME(accident_date) AS Month_Name,
    SUM(number_of_casualties) AS Total_Casualties
FROM road_accident
WHERE YEAR(accident_date) = 2021
GROUP BY MONTH(accident_date), MONTHNAME(accident_date)
ORDER BY MONTH(accident_date);

-- 8.Road Type-wise Casualties Analysis

select road_type,sum(number_of_casualties) as CY_Casualties
from road_accident
where year(accident_date)=2021
group by road_type;

-- 9.Urban vs Rural Area Casualties Analysis

select urban_or_rural_area,sum(number_of_casualties)
from road_accident
where year(accident_date)=2021
group by urban_or_rural_area;

-- 10.Light Condition-wise Casualties Analysis

SELECT
    CASE
        WHEN light_conditions IN ('Daylight') THEN 'Day'
        WHEN light_conditions IN (
            'Darkness - lighting unknown',
            'Darkness - lights lit',
            'Darkness - lights unlit',
            'Darkness - no lighting'
        ) THEN 'Night'
    END AS Light_Condition,

    CAST(
        CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100 /
        (
            SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2))
            FROM road_accident
            WHERE YEAR(accident_date) = 2021
        )
    AS DECIMAL(10,2)) AS CY_Casualties_PCT

FROM road_accident
WHERE YEAR(accident_date) = 2021
GROUP BY
    CASE
        WHEN light_conditions IN ('Daylight') THEN 'Day'
        WHEN light_conditions IN (
            'Darkness - lighting unknown',
            'Darkness - lights lit',
            'Darkness - lights unlit',
            'Darkness - no lighting'
        ) THEN 'Night'
    END;
    
   -- 11.Local Authority-wise Casualties Analysis
   
   select local_authority,sum(number_of_casualties) as Total_Casualties
    from road_accident
    group by local_authority
    order by Total_Casualties desc limit 10;