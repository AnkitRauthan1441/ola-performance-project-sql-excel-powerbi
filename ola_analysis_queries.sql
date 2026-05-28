
---->>>>> SQL Project on Ola <<<<<----

--1. Find the Top 10 Highest Revenue generating Customers.

--2. Management wants to analyze only completed rides without repeatedly filtering successful bookings.

--3. Which Routes Have the Highest Cancellation Rate?

--4. Calculate Cancellation Rate.

--5. Find loyal customers.

--6. Analyze Major Incomplete Rides and Reasons.

--7. Which Payment Method Generates the Highest Revenue?

--8. Which Pickup Locations Generate the Highest Revenue?

--9. Which Vehicle Type Has the Highest Customer Satisfaction?

--10. Which Vehicle Types Produce the Highest Revenue Per Kilometer?



              --]--))))))))---->>>>> Problems with Solutions <<<<<----((((((((--[--

--1. Find the Top 10 Highest Revenue generating Customers

create view Top_10_Customer_Revenue_generation as
select top 10 Customer_id, sum(booking_value)as Total_Spending
from bookings
where booking_status = 'Success'
group by customer_id
order by Total_Spending desc

-- Execute

select * from Top_10_Customer_Revenue_generation


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--2.Management wants to analyze only completed rides without 
--  repeatedly filtering successful bookings.

CREATE VIEW successful_booking AS
SELECT
    Booking_ID,
    Customer_ID,
    Vehicle_Type,
    Booking_Value,
    Ride_Distance,
    Payment_Method,
    Customer_Rating,
    Driver_Ratings,
    Booking_Status,
    Date,
    Times
FROM bookings
WHERE Booking_Status = 'Success'

-- Execute

SELECT *
FROM successful_booking

--Calculate Total Revenue of Successful bookings

SELECT SUM(Booking_Value) AS Total_Revenue
FROM successful_bookings


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--3. Which Routes Have the Highest Cancellation Rate?

CREATE VIEW route_cancellation AS
SELECT
    Pickup_Location,
    Drop_Location,

    FORMAT(ROUND(COUNT(
        CASE
            WHEN Booking_Status LIKE 'Canceled%'
            THEN 1
        END
    ) * 100.0 / COUNT(*),2),'N2'
    ) + '%' AS Cancellation_rate

FROM bookings
GROUP BY Pickup_Location, Drop_Location

-- Execute

SELECT TOP 10 *
FROM route_cancellation
ORDER BY cancellation_rate DESC

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--4. Calculate Cancellation Rate on the bases of Vehicle type:

CREATE VIEW vehicle_cancellation_rate AS
SELECT
    Vehicle_Type,
    FORMAT(
    ROUND(
    COUNT(
        CASE
            WHEN Booking_Status LIKE 'Canceled%'
            THEN 1
        END
    ) * 100.0 / COUNT(*)  ,2) ,   'N2'
    ) + '%' AS cancellation_percentage
   
FROM bookings
GROUP BY Vehicle_Type

-- Execute

SELECT *
FROM vehicle_cancellation_rate
ORDER BY cancellation_percentage DESC


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--5.Find loyal customers:

CREATE VIEW repeat_customer AS
SELECT
    Customer_ID,
    COUNT(*) AS Total_bookings,
    SUM(Booking_Value) AS Total_spending
FROM bookings
GROUP BY Customer_ID

-- Execute

SELECT top 10 *
FROM repeat_customer
WHERE Total_bookings >= 3
ORDER BY Total_spending DESC

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--6. Analyze Major Incomplete Rides and Reasons:

CREATE VIEW incomplete_ride AS
SELECT
    Booking_ID,
    Vehicle_Type,
    Pickup_Location,
    Drop_Location,
    Incomplete_Rides_Reason
FROM bookings
WHERE Incomplete_Rides = 1

-- Execute

SELECT
    Incomplete_Rides_Reason,
    COUNT(*) AS Total_cases
FROM incomplete_ride
GROUP BY Incomplete_Rides_Reason
ORDER BY total_cases DESC

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--7. Which Payment Method Generates the Highest Revenue?

CREATE VIEW payment_analysis AS
SELECT
    Payment_Method,
    COUNT(*) AS total_transactions,
    SUM(Booking_Value) AS total_revenue
FROM bookings
WHERE Booking_Status = 'Success'
GROUP BY Payment_Method

-- Execute

SELECT *
FROM payment_analysis
ORDER BY total_revenue DESC


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--8. Which Pickup Locations Generate the Highest Revenue?

CREATE VIEW location_revenue AS
SELECT
    Pickup_Location,
    COUNT(*) AS total_rides,
    SUM(Booking_Value) AS total_revenue
FROM bookings
WHERE Booking_Status = 'Success'
GROUP BY Pickup_Location

-- Execute

SELECT TOP 10 *
FROM location_revenue
ORDER BY total_revenue DESC

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--9. Which Vehicle Type Has the Highest Customer Satisfaction? 

CREATE VIEW vehicle_satisfactions AS
SELECT
    Vehicle_Type,

    round(AVG(Customer_Rating),2) AS Avg_Customer_Rating,

    COUNT(*) AS Total_Successful_Rides

FROM bookings
WHERE Booking_Status = 'Success'
GROUP BY Vehicle_Type

-- Execute

SELECT *
FROM vehicle_satisfactions
ORDER BY avg_customer_rating DESC

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--10. Which Vehicle Types Produce the Highest Revenue Per Kilometer?

CREATE VIEW vehicle_efficiency AS
SELECT
    Vehicle_Type,

    SUM(Booking_Value) AS total_revenue,

    SUM(Ride_Distance) AS total_distance,

    SUM(Booking_Value) * 1.0 /
    NULLIF(SUM(Ride_Distance), 0) AS revenue_per_km

FROM bookings
WHERE Booking_Status = 'Success'
GROUP BY Vehicle_Type

-- Execute

SELECT *
FROM vehicle_efficiency
ORDER BY revenue_per_km DESC
