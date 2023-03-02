SELECT *
FROM facebook.kag_conversion_data;
DESCRIBE facebook.kag_conversion_data;
/*Data Cleaning
1.Checking missing values
2.Duplicates*/

 /*Checking Missing Values
No missing values*/
SELECT 
ad_id
FROM facebook.kag_conversion_data
WHERE ad_id IS NULL;

/* 2. Checking Duplicates
No Duplicates*/
SELECT
DISTINCT ad_id
FROM facebook.kag_conversion_data;
/* Explanatory Analysis */
-- KPIs
/* 1. Click-Through-Rate(CTR)
This is the ratio of clicks to impressions and measures the effectiveness of an ad in generating clicks
 0.0179% */
SELECT 
SUM(CLicks)/ SUM(Impressions) *100 AS CTR
FROM facebook.kag_conversion_data;
/*Cost per Click(CPC)
This is the amount spent on an ad per conversion and measures the efficiency of the ad spend in generating conversions
The average spent per click 153.82*/
SELECT 
round(SUM(Spent)/SUM(Clicks)*100,2) AS CPC
FROM facebook.kag_conversion_data;
/*Conversion rate (CR)
This is the ratio of conversions to clicks and measures the effectiveness of an ad in generating conversions*/
SELECT
SUM(Approved_Conversion)/SUM(Clicks)*100 AS CR
FROM facebook.kag_conversion_data;

SELECT 
DISTINCT gender,
COUNT(*) AS total_count
FROM facebook.kag_conversion_data
GROUP BY gender;
SELECT
age,
COUNT(*) AS total_count
FROM facebook.kag_conversion_data
GROUP BY age
ORDER BY COUNT(*) DESC;
SELECT
DISTINCT interest,
COUNT(*) AS total_count
FROM facebook.kag_conversion_data
GROUP BY interest
ORDER BY COUNT(*)  DESC;
SELECT
DISTINCT xyz_campaign_id
FROM facebook.kag_conversion_data;

SELECT
DISTINCT xyz_campaign_id,
CASE 
WHEN xyz_campaign_id =916 THEN 1
WHEN xyz_campaign_id =936 THEN 2
WHEN xyz_campaign_id=1178 THEN 3
END AS xyz_campaign_split
FROM facebook.kag_conversion_data;


UPDATE facebook.kag_conversion_data
SET xyz_campaign_id= CASE 
WHEN xyz_campaign_id =916 THEN 1
WHEN xyz_campaign_id =936 THEN 2
WHEN xyz_campaign_id=1178 THEN 3
END;
SELECT
xyz_campaign_id
FROM facebook.kag_conversion_data
GROUP BY xyz_campaign_id;
-- campaign type and approved conversion 
SELECT
xyz_campaign_id,
SUM(Approved_Conversion) AS Total_Approved_Conversion
FROM facebook.kag_conversion_data
GROUP BY xyz_campaign_id
ORDER BY COUNT(*) DESC;
-- campaign type and Impressions and age
SELECT
age,
xyz_campaign_id,
SUM(Impressions) AS total_impressions,
RANK() OVER(PARTITION BY age ORDER BY SUM(Impressions) DESC ) AS ranking
FROM facebook.kag_conversion_data
GROUP BY age,xyz_campaign_id
ORDER BY SUM(Impressions) DESC;

-- campaign and clicks and age
SELECT 
age,
xyz_campaign_id,
SUM(Clicks) AS total_clicks,
RANK() OVER(PARTITION BY age ORDER BY SUM(Clicks)DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY age,xyz_campaign_id
ORDER  BY SUM(Clicks) DESC;
/* total conversion,age and campaign type
enquired about the product*/
SELECT 
age,
xyz_campaign_id,
count(Total_Conversion) AS count_total_conversions,
RANK() OVER(PARTITION BY age ORDER BY COUNT(Total_Conversion)DESC ) AS ranking
FROM facebook.kag_conversion_data
GROUP BY age,xyz_campaign_id 
ORDER BY COUNT(Total_Conversion) DESC;

/* approved conversion
bought the products*/
SELECT 
age,
xyz_campaign_id,
SUM(Approved_Conversion) AS total_approved,
round(SUM(Spent),2) AS total_amount_spent,
RANK()OVER(PARTITION BY age ORDER BY SUM(Approved_Conversion) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY age,xyz_campaign_id
ORDER BY total_approved DESC;

/* Gender$campaign
impression*/

SELECT 
gender,
xyz_campaign_id,
SUM(Impressions)AS total_impressions,
round(SUM(Spent),2) AS total_amount_spent,
RANK() OVER(PARTITION BY gender ORDER BY SUM(Impressions) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY gender,xyz_campaign_id
ORDER BY total_impressions DESC;
-- clicks

SELECT 
gender,
xyz_campaign_id,
SUM(Clicks)AS total_clicks,
round(SUM(Spent),2) AS total_amount_spent,
RANK() OVER(PARTITION BY gender ORDER BY SUM(Clicks) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY gender,xyz_campaign_id
ORDER BY total_clicks DESC;
/* total conversions
enquired to buy*/
SELECT 
gender,
xyz_campaign_id,
SUM(Total_Conversion)AS total_conversion,
RANK() OVER(PARTITION BY gender ORDER BY SUM(Total_Conversion) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY gender,xyz_campaign_id
ORDER BY total_conversion DESC;

/*approved conversion
bought the product*/

SELECT 
gender,
xyz_campaign_id,
SUM(Approved_Conversion)AS total_approved,
round(SUM(Spent),2) AS total_amount_spent,
RANK() OVER(PARTITION BY gender ORDER BY SUM(Approved_Conversion) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY gender,xyz_campaign_id
ORDER BY total_approved DESC;
 /*interestcode specifying the category to which
 the person’s interest belongs (interests are as mentioned in the person’s Facebook public profile).
 range from 2-114*/
SELECT
interest
FROM facebook.kag_conversion_data
GROUP BY interest;
/* create bins with a width of 25*/
SELECT 
CONCAT(FLOOR(interest/25)*25+1, '-', FLOOR(interest/25)*25+25) AS interest_bin, 
COUNT(*) AS num_interest
FROM 
facebook.kag_conversion_data
GROUP BY 
FLOOR(interest/25)
ORDER BY 
num_interest DESC;

-- Distibution of interest per campaign
SELECT 
xyz_campaign_id,
CONCAT(FLOOR(interest/25)*25+1, '-', FLOOR(interest/25)*25+25) AS interest_bin, 
COUNT(*) AS num_interest,
round(SUM(Spent),2) AS total_amount_spent,
SUM(Approved_Conversion) AS total_approved_conversion,
ROW_NUMBER() OVER(PARTITION BY CONCAT(FLOOR(interest/25)*25+1, '-', FLOOR(interest/25)*25+25) ORDER BY COUNT(*) DESC )AS ranking
FROM 
facebook.kag_conversion_data
-- WHERE xyz_campaign_id=1
GROUP BY 
FLOOR(interest/25),xyz_campaign_id
ORDER BY 
num_interest DESC;
