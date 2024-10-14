-- SELECT DATA THAT WE AR GOING TO BE USING
SELECT *
FROM [Portfolio project]..[MANUFACTURING ADDED VALUE];

-- Completed the data for the years 2021 and 2022 due to missing information.

UPDATE [Portfolio project]..[MANUFACTURING ADDED VALUE]
SET Manufacturing_value_added_US = 2923000000000.00
WHERE Country_Name = 'United States' and year = 2023;

UPDATE [Portfolio project]..[MANUFACTURING ADDED VALUE]
SET Manufacturing_value_added_US = 2981946000000.00
WHERE Country_Name = 'United States' and year = 2022;


--SELECT THE GREATEST MANUFACTURING VALUE ADDED IN HISTORY

SELECT Country_Name, Year, MAX(Manufacturing_value_added_US) AS MAXIMUM_ADDED_VALUE
FROM
	[Portfolio project]..[MANUFACTURING ADDED VALUE]
GROUP BY Country_Name, Year
ORDER BY MAXIMUM_ADDED_VALUE desc
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;



--SELECT THE TOP 10 COUNTRIES IN THE LAST YEAR

SELECT 
    Country_Name, 
    MAX(YEAR) AS LAST_YEAR, 
    Manufacturing_value_added_US
FROM 
    [Portfolio project]..[MANUFACTURING ADDED VALUE]
WHERE YEAR = (SELECT MAX(YEAR) FROM [Portfolio project]..[MANUFACTURING ADDED VALUE])

GROUP BY 
    Country_Name, Manufacturing_value_added_US
ORDER BY 
    Manufacturing_value_added_US DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;



-- SELECT  THE % OF THE MANUFACTURING VALUE SHARE BY COUNTRY


SELECT 
    Country_Name, 
    Year,  
    Manufacturing_value_added_US, 
    Manufacturing_value_added_US / SUM(Manufacturing_value_added_US) OVER (PARTITION BY Year)  AS PERCENTAGE
FROM 
    [Portfolio project]..[MANUFACTURING ADDED VALUE]
ORDER BY 
    Year, 
    Country_Name;


-- % GROWTH COMPARED FROM THE PREVIOUS YEAR BY COUNTRY 

SELECT 
    current_data.Country_Name,
    current_data.YEAR AS Current_Year,
    current_data.Manufacturing_value_added_US AS Current_Manufacturing_Value,
    previous_data.YEAR AS Previous_Year,
    previous_data.Manufacturing_value_added_US AS Previous_Manufacturing_Value,
    ((current_data.Manufacturing_value_added_US - previous_data.Manufacturing_value_added_US) / previous_data.Manufacturing_value_added_US) AS Growth_Percentage
FROM 
    [Portfolio project]..[MANUFACTURING ADDED VALUE] AS current_data
JOIN 
    [Portfolio project]..[MANUFACTURING ADDED VALUE] AS previous_data 
    ON current_data.Country_Name = previous_data.Country_Name
    AND current_data.YEAR = previous_data.YEAR + 1
ORDER BY 
    current_data.YEAR ASC, 
    current_data.Country_Name ASC;







