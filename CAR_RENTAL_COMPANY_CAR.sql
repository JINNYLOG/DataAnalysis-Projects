-- look at the dataset
SELECT *
FROM CAR_RENTAL_COMPANY_CAR

-- Calculate the average daily rental fee
SELECT ROUND(AVG(DAILY_FEE)) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE = 'SUV';
    
-- List of cars with a specific option included
SELECT *
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%navigation%'
ORDER BY CAR_ID DESC;

-- Classify rental records into long-term and short-term rentals
SELECT HISTORY_ID, CAR_ID, 
    DATE_FORMAT(START_DATE,'%Y-%m-%d') AS START_DATE, 
    DATE_FORMAT(END_DATE,'%Y-%m-%d') AS END_DATE, 
    IF(DATEDIFF(END_DATE, START_DATE) >= 29, 'Long-term rental','Short-term rental') AS RENT_TYPE
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE YEAR(START_DATE) = 2022 AND MONTH(START_DATE) = 9
ORDER BY HISTORY_ID DESC;

-- Average car rental duration
SELECT CAR_ID, ROUND(AVG(DATEDIFF(END_DATE,START_DATE)+1),1) AS AVERAGE_DURATION 
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
HAVING AVERAGE_DURATION >=7
ORDER BY AVERAGE_DURATION DESC, CAR_ID DESC;

-- Count the number of cars with a specific option, grouped by car type
SELECT CAR_TYPE, COUNT(*) AS CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE "%seat%"
GROUP BY 1
ORDER BY 1;

-- list of cars that have rental records
SELECT CAR_ID
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_ID IN (SELECT CAR_ID
                FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY 
                WHERE MONTH(START_DATE) = 10) AND CAR_TYPE = "sedan"
ORDER BY CAR_ID DESC;

-- Classify cars as 'rented' or 'available' using rental data
SELECT CAR_ID,
    IF(SUM(IF('2022-10-16' BETWEEN START_DATE AND END_DATE, 1, 0)) > 0, 'rented', 'available') AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY 1
ORDER BY 1 DESC;

-- the monthly rental count for the most frequently rented cars
SELECT MONTH, CAR_ID, RECORDS
FROM (SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(*) AS RECORDS
      FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
      WHERE START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
      AND CAR_ID IN (SELECT CAR_ID
                 FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
                 WHERE START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
                 GROUP BY 1
                 HAVING COUNT(*) >= 5)
      GROUP BY 1, 2) AS RENT
ORDER BY 1, 2 DESC;





