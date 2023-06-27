create database zomato;
use zomato;

CREATE TABLE Main (
    RestaurantID INT,
    RestaurantName VARCHAR(255),
    CountryCode INT,
    City VARCHAR(255),
    Address VARCHAR(255),
    Locality VARCHAR(255),
    LocalityVerbose VARCHAR(255),
    Longitude DECIMAL(10, 7),
    Latitude DECIMAL(10, 7),
    Cuisines VARCHAR(255),
    Currency VARCHAR(255),
    Has_Table_booking VARCHAR(3),
    Has_Online_delivery VARCHAR(3),
    Is_delivering_now VARCHAR(3),
    Switch_to_order_menu VARCHAR(3),
    Price_range INT,
    Votes INT,
    Average_Cost_for_two INT,
    Rating INT,
    Datekey_Opening DATE
);

select * from Main;

 show variables like "secure_file_priv"; 
 set session sql_mode='';
 
 
load data infile
"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Zomata.csv"
into table Main
CHARACTER SET latin1
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


#######################################################################################

# KPI-1(Country Table)

CREATE TABLE Country (
    CountryCode INT,
    CountryName VARCHAR(255)
);

INSERT INTO Country (CountryCode, CountryName)
VALUES
    (1, 'India'),
    (14, 'Australia'),
    (30, 'Brazil'),
    (37, 'Canada'),
    (94, 'Indonesia'),
    (148, 'New Zealand'),
    (162, 'Philippines'),
    (166, 'Qatar'),
    (184, 'Singapore'),
    (189, 'South Africa'),
    (191, 'Sri Lanka'),
    (208, 'Turkey'),
    (214, 'United Arab Emirates'),
    (215, 'United Kingdom'),
    (216, 'United States');


Select * from  country;

#######################################################################################

# KPI-2(Currency Table)

CREATE TABLE Currency (
  Currency VARCHAR(100),
  Average_Cost_for_two DECIMAL(10, 2),
  Average_Cost_in_USD VARCHAR(100)
);

INSERT INTO Currency (Currency, Average_Cost_for_two, Average_Cost_in_USD)
SELECT Currency, 
       ROUND(Average_Cost_for_two, 2) AS Average_Cost_for_two,
       CASE 
           WHEN Currency = 'Indian Rupees(Rs.)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.0120, 2), ' $')
           WHEN Currency = 'Dollar($)' THEN CONCAT(ROUND(Average_Cost_for_two * 1.0000, 2), ' $')
           WHEN Currency = 'Pounds(£)' THEN CONCAT(ROUND(Average_Cost_for_two * 1.2500, 2), ' $')
           WHEN Currency = 'NewZealand($)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.6200, 2), ' $')
           WHEN Currency = 'Emirati Diram(AED)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.2700, 2), ' $')
           WHEN Currency = 'Brazilian Real(R$)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.2000, 2), ' $')
           WHEN Currency = 'Turkish Lira(TL)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.0510, 2), ' $')
           WHEN Currency = 'Qatari Rial(QR)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.2700, 2), ' $')
           WHEN Currency = 'Rand(R)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.0520, 2), ' $')
           WHEN Currency = 'Botswana Pula(P)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.0740, 2), ' $')
           WHEN Currency = 'Sri Lankan Rupee(LKR)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.0032, 2), ' $')
           WHEN Currency = 'Indonesian Rupiah(IDR)' THEN CONCAT(ROUND(Average_Cost_for_two * 0.00007, 2), ' $')
       END AS Average_Cost_in_USD
FROM Main;

select * from Currency;

#######################################################################################

# KPI-3(calender table)

CREATE TABLE Calendar (
  Date DATE,
  Year INT,
  Month INT,
  Month_Name VARCHAR(20),
  Quarter VARCHAR(5),
  YearMonth VARCHAR(10),
  Weekday_Number INT,
  Weekday VARCHAR(20),
  Financial_Month VARCHAR(10),
  Financial_Quarter VARCHAR(5)
);

INSERT INTO Calendar (Date, Year, Month, Month_Name, Quarter, YearMonth, Weekday_Number, Weekday, Financial_Month, Financial_Quarter)
SELECT 
  DATE(Datekey_Opening) AS Date, 
  YEAR(Datekey_Opening) AS Year, 
  MONTH(Datekey_Opening) AS Month, 
  MONTHNAME(Datekey_Opening) AS Month_Name, 
  CONCAT('Q', QUARTER(Datekey_Opening)) AS Quarter, 
  DATE_FORMAT(Datekey_Opening, '%Y-%b') AS YearMonth,
  DAYOFWEEK(Datekey_Opening) AS Weekday_Number, 
  DATE_FORMAT(Datekey_Opening, '%W') AS Weekday,
  CASE 
    WHEN MONTH(Datekey_Opening) = 4 THEN 'FM1'
    WHEN MONTH(Datekey_Opening) = 5 THEN 'FM2'
    WHEN MONTH(Datekey_Opening) = 6 THEN 'FM3'
    WHEN MONTH(Datekey_Opening) = 7 THEN 'FM4'
    WHEN MONTH(Datekey_Opening) = 8 THEN 'FM5'
    WHEN MONTH(Datekey_Opening) = 9 THEN 'FM6'
    WHEN MONTH(Datekey_Opening) = 10 THEN 'FM7'
    WHEN MONTH(Datekey_Opening) = 11 THEN 'FM8'
    WHEN MONTH(Datekey_Opening) = 12 THEN 'FM9'
    WHEN MONTH(Datekey_Opening) = 1 THEN 'FM10'
    WHEN MONTH(Datekey_Opening) = 2 THEN 'FM11'
    ELSE 'FM12'
  END AS Financial_Month, 
  CASE 
    WHEN MONTH(Datekey_Opening) BETWEEN 1 AND 3 THEN 'FQ4'
    WHEN MONTH(Datekey_Opening) BETWEEN 4 AND 6 THEN 'FQ1'
    WHEN MONTH(Datekey_Opening) BETWEEN 7 AND 9 THEN 'FQ2'
    ELSE 'FQ3'
  END AS Financial_Quarter
FROM Main
ORDER BY Date ASC;

select * from Calendar;
#######################################################################################

# KPI-4 (Numbers of Resturants based on City and Country)

SELECT COUNT(RestaurantID) AS Restaurants, City, CountryName
FROM Main
 left JOIN Country ON Country.CountryCode = Main .CountryCode
GROUP BY City, CountryName
ORDER BY Restaurants DESC;


#######################################################################################

# KPI-5 (Numbers of Resturants opening based on Year , Quarter , Month)

SELECT YEAR(Datekey_Opening) AS Year, COUNT(*) AS Yearwise_Restaurants_Opening
FROM Main 
GROUP BY YEAR(Datekey_Opening);

SELECT YEAR(Datekey_Opening) AS Year, QUARTER(Datekey_Opening) AS Quarter, COUNT(*) AS Quaterwise_Restaurants_Opening
FROM Main 
GROUP BY YEAR(Datekey_Opening), QUARTER(Datekey_Opening);

SELECT YEAR(Datekey_Opening) AS Year, MONTHNAME(Datekey_Opening) AS Month, COUNT(*) AS Monthwise_Restaurants_Opening
FROM Main 
GROUP BY YEAR(Datekey_Opening), MONTHNAME(Datekey_Opening);

SELECT YEAR(Datekey_Opening) AS Year, QUARTER(Datekey_Opening) AS Quarter, MONTHNAME(Datekey_Opening) AS Month, COUNT(*) AS Restaurants_Opening
FROM Main 
GROUP BY YEAR(Datekey_Opening), QUARTER(Datekey_Opening), MONTHNAME(Datekey_Opening)
order by year asc;

#######################################################################################

# KPI-6 (Count of Resturants based on Average Ratings)

SELECT Rating_Range, COUNT(*) AS Num_Of_Restaurants
FROM (
  SELECT
    CASE
      WHEN AVG(Rating) BETWEEN 1.0 AND 1.5 THEN '1.0-1.5'
      WHEN AVG(Rating) BETWEEN 1.5 AND 2.0 THEN '1.5-2.0'
      WHEN AVG(Rating) BETWEEN 2.0 AND 2.5 THEN '2.0-2.5'
      WHEN AVG(Rating) BETWEEN 2.5 AND 3.0 THEN '2.5-3.0'
      WHEN AVG(Rating) BETWEEN 3.0 AND 3.5 THEN '3.0-3.5'
      WHEN AVG(Rating) BETWEEN 3.5 AND 4.0 THEN '3.5-4.0'
      WHEN AVG(Rating) BETWEEN 4.0 AND 4.5 THEN '4.0-4.5'
      WHEN AVG(Rating) BETWEEN 4.5 AND 5.0 THEN '4.5-5.0'
    END AS Rating_Range
  FROM Main 
  GROUP BY RestaurantID
) AS Avg_Ratings
GROUP BY Rating_Range
order by rating_range asc;

#######################################################################################

# KPI-7 (Resturants Based On Average Price Bucket)

SELECT COUNT(RestaurantID) AS Num_Of_Restaurants,
  CASE
    WHEN Currency = 'Indian Rupees(Rs.)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.0120) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.0120) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.0120) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.0120) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.0120) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Dollar($)' THEN
      CASE
        WHEN (Average_Cost_for_two * 1.0000) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 1.0000) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 1.0000) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 1.0000) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 1.0000) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Pounds(£)' THEN
      CASE
        WHEN (Average_Cost_for_two * 1.2500) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 1.2500) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 1.2500) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 1.2500) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 1.2500) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'NewZealand($)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.6200) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.6200) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.6200) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.6200) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.6200) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Emirati Diram(AED)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Brazilian Real(R$)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.2000) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.2000) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.2000) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.2000) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.2000) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Turkish Lira(TL)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.0510) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.0510) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.0510) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.0510) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.0510) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Qatari Rial(QR)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.2700) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Rand(R)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.0520) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.0520) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.0520) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.0520) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.0520) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Botswana Pula(P)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.0740) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.0740) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.0740) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.0740) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.0740) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Sri Lankan Rupee(LKR)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.0032) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.0032) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.0032) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.0032) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.0032) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    WHEN Currency = 'Indonesian Rupiah(IDR)' THEN
      CASE
        WHEN (Average_Cost_for_two * 0.00007) BETWEEN 0 AND 100 THEN '0-100'
        WHEN (Average_Cost_for_two * 0.00007) BETWEEN 101 AND 200 THEN '101-200'
        WHEN (Average_Cost_for_two * 0.00007) BETWEEN 201 AND 300 THEN '201-300'
        WHEN (Average_Cost_for_two * 0.00007) BETWEEN 301 AND 400 THEN '301-400'
        WHEN (Average_Cost_for_two * 0.00007) BETWEEN 401 AND 500 THEN '401-500'
        ELSE '501 and above'
      END
    ELSE 'Unknown Currency' -- Handling any other currencies not listed above
  END AS Bucket
FROM Main 
GROUP BY Bucket
ORDER BY Bucket ASC;



#######################################################################################

# KPI-8 (Percentage of Resturants based on "Has_Table_booking")

SELECT 
    CONCAT(COUNT(CASE
                WHEN Has_Table_Booking = 'Yes' THEN 1
                ELSE NULL
            END) * 100 / COUNT(*),
            '%') AS Percentage_With_Table_Booking
FROM
 Main ;
    
 #######################################################################################

# KPI-9 (Percentage of Resturants based on "Has_Online_delivery")

SELECT 
    CONCAT(COUNT(CASE
                WHEN Has_Online_delivery = 'Yes' THEN 1
                ELSE NULL
            END) * 100 / COUNT(*),
            '%') AS Percentage_With_Online_delivery
FROM
   Main ;
   
  ###########################################################################################
   
 # KPI-10 (Card Visual kpi's) 
   
# (1) Total number of restaurants:
   SELECT COUNT(*) AS TotalRestaurants
FROM Main ;

# (2) Total number of Countries:
SELECT COUNT(DISTINCT CountryCode) AS TotalCountries
FROM Main ;


# (3) Total number of Cities:
SELECT COUNT(DISTINCT City) AS TotalCities
FROM Main ;

# (4) Total Cuisines:
SELECT COUNT(DISTINCT Cuisines) AS TotalCuisines
FROM Main ;

# (5) Total Votes:
SELECT SUM(Votes) AS TotalVotes
FROM Main ;

# (6) Average Rating:
SELECT AVG(Rating) AS AverageRating
FROM Main ;

###########################################################################################
   
 # KPI-11 (top 5 cities with highest no of resturants) 

SELECT City, COUNT(RestaurantID) AS Num_Of_Restaurants
FROM Main 
GROUP BY City
ORDER BY Num_Of_Restaurants DESC
LIMIT 5;

 
 ###########################################################################################
   
 # KPI-11 (top 5 most Expensive cuisines) 
 
 SELECT Cuisines, AVG(Average_Cost_for_two) AS Average_Cost
FROM Main 
GROUP BY Cuisines
ORDER BY Average_Cost DESC
LIMIT 5;

 ###########################################################################################