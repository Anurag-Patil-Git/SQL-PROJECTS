CREATE DATABASE IF NOT EXISTS ride_pricing_engine;
USE ride_pricing_engine;

-- Create Clean Table
CREATE TABLE IF NOT EXISTS rides_clean (
    ride_id INT PRIMARY KEY,
    request_time VARCHAR(50),
    pickup_location VARCHAR(100),
    pickup_latitude DECIMAL(10,6),
    pickup_longitude DECIMAL(10,6),
    dropoff_location VARCHAR(100),
    dropoff_latitude DECIMAL(10,6),
    dropoff_longitude DECIMAL(10,6),
    ride_distance DECIMAL(10,2),
    fare_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    driver_id VARCHAR(10),
    vehicle_type VARCHAR(50),
    traffic_condition VARCHAR(50),
    peak_hours VARCHAR(10),
    day_of_week VARCHAR(20),
    public_holiday VARCHAR(10),
    user_rating DECIMAL(3,2)
) ENGINE=InnoDB;

-- ===============================
-- BASIC ANALYSIS
-- ===============================

-- 1. Total Rides
SELECT COUNT(*) AS total_rides 
FROM rides_clean;

-- 2. Total Revenue
SELECT SUM(fare_amount) AS total_revenue 
FROM rides_clean;

-- 3. Average Ride Distance
SELECT AVG(ride_distance) AS avg_distance 
FROM rides_clean;

-- 4. Average Fare Per Mile
SELECT AVG(fare_amount / ride_distance) AS avg_fare_per_mile
FROM rides_clean
WHERE ride_distance > 0;

-- ===============================
-- DEMAND ANALYSIS
-- ===============================

-- 5. Rides Per Hour
SELECT HOUR(STR_TO_DATE(request_time,'%m-%d-%y %H:%i')) AS ride_hour,
       COUNT(*) AS total_rides
FROM rides_clean
GROUP BY ride_hour
ORDER BY total_rides DESC;

-- 6. Rides Per Location
SELECT pickup_location,
       COUNT(*) AS ride_count
FROM rides_clean
GROUP BY pickup_location
ORDER BY ride_count DESC;

-- 7. Peak Demand Day
SELECT day_of_week,
       COUNT(*) AS total_rides
FROM rides_clean
GROUP BY day_of_week
ORDER BY total_rides DESC;

-- ===============================
-- REVENUE ANALYSIS
-- ===============================

-- 8. Revenue by Location
SELECT pickup_location,
       SUM(fare_amount) AS total_revenue
FROM rides_clean
GROUP BY pickup_location
ORDER BY total_revenue DESC;

-- 9. Revenue by Hour
SELECT HOUR(STR_TO_DATE(request_time,'%m-%d-%y %H:%i')) AS ride_hour,
       SUM(fare_amount) AS total_revenue
FROM rides_clean
GROUP BY ride_hour
ORDER BY total_revenue DESC;

-- ===============================
-- DRIVER PERFORMANCE
-- ===============================

-- 10. Top 10 Earning Drivers
SELECT driver_id,
       SUM(fare_amount) AS total_earnings
FROM rides_clean
GROUP BY driver_id
ORDER BY total_earnings DESC
LIMIT 10;

-- 11. Driver Ranking
SELECT driver_id,
       SUM(fare_amount) AS total_earnings,
       RANK() OVER (ORDER BY SUM(fare_amount) DESC) AS rank_position
FROM rides_clean
GROUP BY driver_id;

-- ===============================
-- USER EXPERIENCE
-- ===============================

-- 12. Average Rating by Vehicle Type
SELECT vehicle_type,
       AVG(user_rating) AS avg_rating
FROM rides_clean
GROUP BY vehicle_type
ORDER BY avg_rating DESC;

-- 13. Rating by Traffic Condition
SELECT traffic_condition,
       AVG(user_rating) AS avg_rating
FROM rides_clean
GROUP BY traffic_condition;

-- ===============================
-- SURGE PRICING SIMULATION
-- ===============================

-- 14. Demand Per Location Per Hour
SELECT pickup_location,
       HOUR(STR_TO_DATE(request_time,'%m-%d-%y %H:%i')) AS ride_hour,
       COUNT(*) AS ride_count
FROM rides_clean
GROUP BY pickup_location, ride_hour;

-- 15. Surge Logic Simulation
SELECT pickup_location,
       HOUR(STR_TO_DATE(request_time,'%m-%d-%y %H:%i')) AS ride_hour,
       COUNT(*) AS ride_count,
       CASE
           WHEN COUNT(*) > 50 THEN 2.0
           WHEN COUNT(*) > 30 THEN 1.5
           ELSE 1.0
       END AS surge_multiplier
FROM rides_clean
GROUP BY pickup_location, ride_hour;

-- ===============================
-- ADVANCED ANALYTICS
-- ===============================

-- 16. Moving Average Fare
SELECT STR_TO_DATE(request_time,'%m-%d-%y %H:%i') AS request_datetime,
       AVG(fare_amount) OVER (
           ORDER BY STR_TO_DATE(request_time,'%m-%d-%y %H:%i')
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ) AS moving_avg_fare
FROM rides_clean;

-- 17. Hourly Ride Growth
SELECT ride_hour,
       total_rides,
       total_rides - LAG(total_rides) OVER (ORDER BY ride_hour) AS ride_growth
FROM (
    SELECT HOUR(STR_TO_DATE(request_time,'%m-%d-%y %H:%i')) AS ride_hour,
           COUNT(*) AS total_rides
    FROM rides_clean
    GROUP BY ride_hour
) AS hourly_data;
