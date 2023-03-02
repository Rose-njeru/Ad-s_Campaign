# facebook-ad_campaign

![image](https://user-images.githubusercontent.com/92436079/222338019-c5eef721-e752-4f65-a251-c478f33a671d.png)


Social Media Ad Campaign marketing is a leading source of Sales Conversion; therefore, I performed descriptive data analysis for company XYZ to help the marketing team understand the demographic customers and people's interests and provide insights on the most effective campaign level and target group.

[Data Source](https://www.kaggle.com/code/joshuamiguelcruz/facebook-ad-campaign-eda/input)

The file conversion_data.csv contains 1143 observations in 11 variables. Below are the descriptions of the variables.

1.) ad_id: an unique ID for each ad.

2.) xyz_campaign_id: an ID associated with each ad campaign of XYZ company.

3.) fb_campaign_id: an ID associated with how Facebook tracks each campaign.

4.) age: age of the person to whom the ad is shown.

5.) gender: gender of the person to whom the add is shown

6.) interest: a code specifying the category to which the person’s interest belongs (interests are as mentioned in the person’s Facebook public profile).

7.) Impressions: the number of times the ad was shown.

8.) Clicks: number of clicks on for that ad.

9.) Spent: Amount paid by company xyz to Facebook, to show that ad.

10.) Total conversion: Total number of people who enquired about the product after seeing the ad.

11.) Approved conversion: Total number of people who bought the product after seeing the ad.

## Ojectives
+ Business KPIs
+ To optimize ad targeting based on age and gender in order to improve ad engagement and conversion rates.
+ Identify the most common and relevant interests codes among a target audience 
+ Cost-Effectiveness;to optimize the allocation of resources towards the most effective marketing campaigns that can maximize returns on investment (ROI) while minimizing costs.
+ Recommendations on how to create more personalized marketing messages and increase the effectiveness of their campaigns. 


## Data Cleaning
**Checking Missing Values**

``` sql
SELECT 
ad_id
FROM facebook.kag_conversion_data
WHERE ad_id IS NULL
```
![image](https://user-images.githubusercontent.com/92436079/222508584-0437b975-2272-484c-8a7e-a6a866b24668.png)

+ No missing values

**Checking Duplicates**

``` sql
SELECT
DISTINCT ad_id
FROM facebook.kag_conversion_data;
```

![image](https://user-images.githubusercontent.com/92436079/222508839-cf83ea48-b178-43a8-ab49-33fcedf6de23.png)

+ No Duplicates
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
```sql
SELECT
xyz_campaign_id
FROM facebook.kag_conversion_data
GROUP BY xyz_campaign_id;
```
![image](https://user-images.githubusercontent.com/92436079/222334884-e621d030-5df9-4c1e-b618-e68555671dcd.png)

+ campaign and purchases
```sql
SELECT
xyz_campaign_id,
SUM(Approved_Conversion) AS Total_Approved_Conversion
FROM facebook.kag_conversion_data
GROUP BY xyz_campaign_id
ORDER BY COUNT(*) DESC;
```
![image](https://user-images.githubusercontent.com/92436079/222335036-2c869c05-4fde-46fc-b4c1-d781ff54c392.png)

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

Customers between the age 30-34 years had seen the most ads from Campaigns 3 and 1, while those of age 40-44 years saw the most ads from campaign 2

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

Customers between the age 45-49 clicked most ads in campaigns 3 and 2 

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

Aged 30-34 years made the most inquiries  after seeing the ads in campaigns 3 and 1, while 45-49 years enquired about the product for campaign 2.

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

![image](https://user-images.githubusercontent.com/92436079/222319491-db9b9cfa-0c9d-481e-b62b-879b6555bb8f.png)

Aged 30-34 years  bought the products in all the campaingns.

**Gender**

+ Gender and impressions
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

![image](https://user-images.githubusercontent.com/92436079/222319581-5d85a915-6c30-4839-8df5-82943edd31ee.png)

Most females saw the ads across campaigns 3 and 2 but not in campaign 1,seen mainly by males

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

![image](https://user-images.githubusercontent.com/92436079/222319688-eaff16be-dea5-4c19-b0c2-3add68cc8946.png)

Most females clicked the ads across campaigns 3 and 2 but not in campaign 1, seen mainly by males.


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
![image](https://user-images.githubusercontent.com/92436079/222319794-0bb8ca25-6d21-40b3-9f93-bd9ae4819d1d.png)

Males made the  inquiries after clicking the ads for campaigns 3 and 1, while most females made inquiries for campaign 2 

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
![image](https://user-images.githubusercontent.com/92436079/222319874-48a7d287-8374-446b-aaa6-c6b246379fe4.png)

Males bought the product after inquiries the ads for campaigns 3 and 1, while most females made inquiries for campaign 2 

**Interest**

The interest code ranges from 2-114; therefore, we create bins to understand the distribution of interest across different campaign levels.

```sql
SELECT 
CONCAT(FLOOR(interest/25)*25+1, '-', FLOOR(interest/25)*25+25) AS interest_bin, 
COUNT(*) AS num_interest
FROM 
facebook.kag_conversion_data
GROUP BY 
FLOOR(interest/25)
ORDER BY 
num_interest DESC;
```

![image](https://user-images.githubusercontent.com/92436079/222522004-02dae315-ddc4-4d67-b7ae-f845acbca8af.png)

+ Interest and campaign levels

```sql
SELECT 
xyz_campaign_id,
CONCAT(FLOOR(interest/25)*25+1, '-', FLOOR(interest/25)*25+25) AS interest_bin, 
COUNT(*) AS num_interest,
SUM(Approved_Conversion) AS total_approved_conversion,
round(SUM(Spent),2) AS total_amount_spent,
ROW_NUMBER() OVER(PARTITION BY CONCAT(FLOOR(interest/25)*25+1, '-', FLOOR(interest/25)*25+25) ORDER BY COUNT(*) DESC )AS ranking
FROM 
facebook.kag_conversion_data
GROUP BY 
FLOOR(interest/25),xyz_campaign_id
ORDER BY 
num_interest DESC;
```

![image](https://user-images.githubusercontent.com/92436079/222326823-c5dfbdc9-437c-4d2d-a29a-bee7b368bc1d.png)

Across all campaign levels, people's interest between codes 1-25 had the highest count, most purchases, followed by 26-50 bins.

As the code bins increase, the count and purchases tend to decrease.

## Cost Effectiveness

The measure of how efficiently a campaign is using its resources to achieve its desired goals. It involves evaluating the cost of running a campaign and comparing it to the benefits or returns generated from that campaign.

In this case it is the money spent on the campaigns ads and purchases made across the demographic characteristics and people's interest.

**Age**
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
![image](https://user-images.githubusercontent.com/92436079/222319491-db9b9cfa-0c9d-481e-b62b-879b6555bb8f.png)

+ Money spent on running a campaign ad for ages 35-39  is less compared to other age groups and more for ages 45-49 across the campaign levels.
+ The purchases made by people in that age are minimal comparing them to ages 30-34, although a slightly higher amount is spent on running the ads.
+ It is cost-effective for the company to spend on running the ads for aged 30-34 since it will generate more purchases.

**Gender**
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
![image](https://user-images.githubusercontent.com/92436079/222319874-48a7d287-8374-446b-aaa6-c6b246379fe4.png)

+ It is cost-effective to run the male ads since it is cheaper for the company and the purchases are high compared to the females.

**Interests**
```sql
SELECT 
xyz_campaign_id,
CONCAT(FLOOR(interest/25)*25+1, '-', FLOOR(interest/25)*25+25) AS interest_bin, 
COUNT(*) AS num_interest,
SUM(Approved_Conversion) AS total_approved_conversion,
round(SUM(Spent),2) AS total_amount_spent,
ROW_NUMBER() OVER(PARTITION BY CONCAT(FLOOR(interest/25)*25+1, '-', FLOOR(interest/25)*25+25) ORDER BY COUNT(*) DESC )AS ranking
FROM 
facebook.kag_conversion_data
GROUP BY 
FLOOR(interest/25),xyz_campaign_id
ORDER BY 
num_interest DESC;
```
![image](https://user-images.githubusercontent.com/92436079/222326823-c5dfbdc9-437c-4d2d-a29a-bee7b368bc1d.png)

+ As the interest code increases, the company spends less on running the ads at all campaign levels, but the purchases also decline.
+ Comparing interest bins 1-25 and 26-50, it is cost-effective for the company to spend on campaigns ads for bins 26-50 rather than 1-25 since the is only a slight difference in the purchases made but a higher difference in the amount spent.

## Recomendations 

+ The marketing team should focus more on running ads for campaign level 3 since it generates more purchases.
+ The target group should be males aged 30-34.
+ Focus on people's interest with codes between 26-50 since they'll spend less and generate more purchases 

