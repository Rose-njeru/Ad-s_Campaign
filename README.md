# facebok-ad_campaign
The file conversion_data.csv contains 1143 observations in 11 variables. Below are the descriptions of the variables.

1.) ad_id: an unique ID for each ad.

2.) xyz_campaign_id: an ID associated with each ad campaign of XYZ company.

3.) fb_campaign_id: an ID associated with how Facebook tracks each campaign.

4.) age: age of the person to whom the ad is shown.

5.) gender: gender of the person to whim the add is shown

6.) interest: a code specifying the category to which the person’s interest belongs (interests are as mentioned in the person’s Facebook public profile).

7.) Impressions: the number of times the ad was shown.

8.) Clicks: number of clicks on for that ad.

9.) Spent: Amount paid by company xyz to Facebook, to show that ad.

10.) Total conversion: Total number of people who enquired about the product after seeing the ad.

11.) Approved conversion: Total number of people who bought the product after seeing the ad.

## Ojectives
+ Business KPIs
+ Determine the demographics of people in relation to the campaign levels
+ Determine the interest to the campaign
+ Provide insights on how the marketing team can improve the least performing campaigns


## Data Cleaning
**Checking Missing Values**
+ No missing values
``` sql
SELECT 
ad_id
FROM facebook.kag_conversion_data
WHERE ad_id IS NULL
```

**Checking Duplicates**
+ No Duplicates
``` sql
SELECT
DISTINCT ad_id
FROM facebook.kag_conversion_data;
```
## Manipulation of Columns
+ manipulating the xyz_campaign_id to represent 3 campaign levels 1-3 and updating the table
``` sql
SELECT
DISTINCT xyz_campaign_id,
CASE 
WHEN xyz_campaign_id =916 THEN 1
WHEN xyz_campaign_id =936 THEN 2
WHEN xyz_campaign_id=1178 THEN 3
END AS xyz_campaign_split
FROM facebook.kag_conversion_data;
```
``` sql
UPDATE facebook.kag_conversion_data
SET xyz_campaign_id= CASE 
WHEN xyz_campaign_id =916 THEN 1
WHEN xyz_campaign_id =936 THEN 2
WHEN xyz_campaign_id=1178 THEN 3
END;
```
**Business KPIs**

1.Click-Through-Rate(CTR)
This is the ratio of clicks to impressions and measures the effectiveness of an ad in generating clicks.
```sql
SELECT 
SUM(CLicks)/ SUM(Impressions) *100 AS CTR
FROM facebook.kag_conversion_data;
```
![image](https://user-images.githubusercontent.com/92436079/222162187-9eede4e1-5102-4c77-8059-623493683416.png)

2.Cost per Click(CPC)
This is the amount spent on an ad per conversion and measures the efficiency of the ad spend in generating conversions.
The average spent per click

```sql
SELECT 
round(SUM(Spent)/SUM(Clicks)*100,2) AS CPC
FROM facebook.kag_conversion_data;
```
![image](https://user-images.githubusercontent.com/92436079/222162434-8464bc2c-b503-41b4-bafe-b62cdbfa0c38.png)

3.Conversion rate (CR)
This is the ratio of conversions to clicks and measures the effectiveness of an ad in generating conversions.
```sql
SELECT
SUM(Approved_Conversion)/SUM(Clicks)*100 AS CR
FROM facebook.kag_conversion_data;
```
![image](https://user-images.githubusercontent.com/92436079/222162531-e4491bcb-a217-466f-9786-bf6b26739dc6.png)

**AGE**
+ Age and Impressions

``` sql
SELECT
age,
xyz_campaign_id,
SUM(Impressions) AS total_impressions,
RANK() OVER(PARTITION BY age ORDER BY SUM(Impressions) DESC ) AS ranking
FROM facebook.kag_conversion_data
GROUP BY age,xyz_campaign_id
ORDER BY SUM(Impressions) DESC;
```
![image](https://user-images.githubusercontent.com/92436079/222163761-f1ddb6bd-6d80-417a-9cc5-7817f4b5d9fe.png)

+ Age and Clicks
``` sql
SELECT 
age,
xyz_campaign_id,
SUM(Clicks) AS total_clicks,
RANK() OVER(PARTITION BY age ORDER BY SUM(Clicks)DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY age,xyz_campaign_id
ORDER  BY SUM(Clicks) DESC;
```
![image](https://user-images.githubusercontent.com/92436079/222164035-bb5c99f3-fc94-4673-996b-25db0256bac8.png)

+ Age and Total conversion
```sql
SELECT 
age,
xyz_campaign_id,
count(Total_Conversion) AS count_total_conversions,
RANK() OVER(PARTITION BY age ORDER BY COUNT(Total_Conversion)DESC ) AS ranking
FROM facebook.kag_conversion_data
GROUP BY age,xyz_campaign_id 
ORDER BY COUNT(Total_Conversion) DESC;
```
![image](https://user-images.githubusercontent.com/92436079/222164225-52873e84-cd9b-477d-892f-2e0ee59de7c9.png)

+ Age and approved conversion
``` sql
SELECT 
age,
xyz_campaign_id,
SUM(Approved_Conversion) AS total_approved,
round(SUM(Spent),2) AS total_amount_spent,
RANK()OVER(PARTITION BY age ORDER BY SUM(Approved_Conversion) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY age,xyz_campaign_id
ORDER BY total_approved DESC;
```
![image](https://user-images.githubusercontent.com/92436079/222164425-014d1cbd-e77d-4205-8e0a-7ada8b232b92.png)

**Gender**
+ Gender and ipressions
``` sql
SELECT 
gender,
xyz_campaign_id,
SUM(Impressions)AS total_impressions,
round(SUM(Spent),2) AS total_amount_spent,
RANK() OVER(PARTITION BY gender ORDER BY SUM(Impressions) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY gender,xyz_campaign_id
ORDER BY total_impressions DESC;
```
+ gender and clicks
``` sql
SELECT 
gender,
xyz_campaign_id,
SUM(Clicks)AS total_clicks,
round(SUM(Spent),2) AS total_amount_spent,
RANK() OVER(PARTITION BY gender ORDER BY SUM(Clicks) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY gender,xyz_campaign_id
ORDER BY total_clicks DESC;
``` 
+ gender and total conversions
``` sql
SELECT 
gender,
xyz_campaign_id,
SUM(Total_Conversion)AS total_conversion,
RANK() OVER(PARTITION BY gender ORDER BY SUM(Total_Conversion) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY gender,xyz_campaign_id
ORDER BY total_conversion DESC;
```
+ gender and approved conversion
``` sql
SELECT 
gender,
xyz_campaign_id,
SUM(Approved_Conversion)AS total_approved,
RANK() OVER(PARTITION BY gender ORDER BY SUM(Approved_Conversion) DESC) AS ranking
FROM facebook.kag_conversion_data
GROUP BY gender,xyz_campaign_id
ORDER BY total_approved DESC;
```
