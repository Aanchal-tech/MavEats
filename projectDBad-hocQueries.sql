SET PAGESIZE 120;
SET LINESIZE 100;

-- 1. Finding the most popular restaurant based on the highest number of orders for a particular month
SELECT r.name, COUNT(*) AS total_orders
FROM Spring25_S003_T7_RESTAURANT r
INNER JOIN Spring25_S003_T7_ORDERS o ON r.rest_id = o.rest_id
WHERE EXTRACT(MONTH FROM o.ORDER_DATE) = 1 AND EXTRACT(YEAR FROM o.ORDER_DATE) = 2025
GROUP BY r.rest_id, r.name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM Spring25_S003_T7_RESTAURANT r2
    INNER JOIN Spring25_S003_T7_ORDERS o2 ON r2.rest_id = o2.rest_id
    WHERE EXTRACT(MONTH FROM o2.ORDER_DATE) = 1 AND EXTRACT(YEAR FROM o2.ORDER_DATE) = 2025
    GROUP BY r2.rest_id, r2.name
);

-- Output before update:
-- NAME                                               TOTAL_ORDERS
-- -------------------------------------------------- ------------
-- Alamo's Delight                                               3
-- The Tasty Spoon                                               3


-- 2. Finding the top delivery agents whose minimum rating greater than the avg rating of all delivery agents
COLUMN TOP_DELIVERY_AGENTS FORMAT A30
SELECT a.FIRST_NAME || ' ' || a.LAST_NAME AS TOP_DELIVERY_AGENTS, b.RATING
FROM SPRING25_S003_T7_DELIVERY_AGENT a, SPRING25_S003_T7_RATES b
WHERE a.ID = b.DELIVERY_AGENT_ID
GROUP BY a.ID, a.FIRST_NAME, a.LAST_NAME, b.RATING
HAVING MIN(RATING) > (
                        SELECT AVG(RATING)
                        FROM SPRING25_S003_T7_RATES
                     )
ORDER BY RATING DESC, TOP_DELIVERY_AGENTS
FETCH FIRST 3 ROWS ONLY;

-- Output before update:
-- TOP_DELIVERY_AGENTS                RATING
-- ------------------------------ ----------
-- Adam Thompson                           5
-- Brandon Walker                          5
-- Cody Green                              5

-- Output after update:
-- TOP_DELIVERY_AGENTS                RATING
-- ------------------------------ ----------
-- Brandon Walker                          5
-- Cody Green                              5
-- Grace Baker                             5

-- Difference:
-- Adam Thompson is no longer in the top delivery agents


-- 3.   Finding the total weekly revenue/sales for each restaurant.
SELECT r.NAME AS restaurant_name,
       TO_CHAR(o.ORDER_DATE, 'IW') AS week_number,
       SUM(o.TOTAL_AMT) AS weekly_revenue
FROM Spring25_S003_T7_ORDERS o
JOIN Spring25_S003_T7_RESTAURANT r ON o.REST_ID = r.REST_ID
GROUP BY ROLLUP (r.NAME, TO_CHAR(o.ORDER_DATE, 'IW'))
ORDER BY r.NAME;

-- Output before update:
-- RESTAURANT_NAME                                    WE WEEKLY_REVENUE
-- -------------------------------------------------- -- --------------
-- Alamo's Delight                                    02             60
-- Alamo's Delight                                    03             60
-- Alamo's Delight                                    05             60
-- Alamo's Delight                                                  180
-- Big Tex BBQ                                        02             43
-- Big Tex BBQ                                                       43
-- Blue Ribbon BBQ                                    06             82
-- Blue Ribbon BBQ                                                   82
-- Bluebonnet Bistro                                  04             73
-- Bluebonnet Bistro                                                 73
-- Cactus Cantina                                     06             39
-- Cactus Cantina                                                    39
-- Casa Bonita                                        02             31
-- Casa Bonita                                                       31
-- Cattleman's Cut                                    03             82
-- Cattleman's Cut                                                   82
-- Chili's Corner                                     04             69
-- Chili's Corner                                                    69
-- Desert Rose Caf???                                 03             56
-- Desert Rose Caf???                                                56
-- Dynasty Wok                                        02             89
-- Dynasty Wok                                                       89
-- Fiesta Flame                                       06             53
-- Fiesta Flame                                                      53
-- Fire and Ice Diner                                 08             42
-- Fire and Ice Diner                                                42
-- Flame and Flavor                                   05             44
-- Flame and Flavor                                                  44
-- Flamingo's Fiesta                                  06             47
-- Flamingo's Fiesta                                                 47
-- Gator's Cajun                                      03             50
-- Gator's Cajun                                                     50
-- Harvest House                                      07             80
-- Harvest House                                                     80
-- Lone Pine Pub                                      07             64
-- Lone Pine Pub                                                     64
-- Lone Star Grill                                    03             65
-- Lone Star Grill                                                   65
-- Mama Mia Pizzeria                                  02             77
-- Mama Mia Pizzeria                                                 77
-- Mesquite Magic                                     05             73
-- Mesquite Magic                                                    73
-- Metro Grill                                        02             54
-- Metro Grill                                                       54
-- Midnight Mesa                                      07             58
-- Midnight Mesa                                                     58
-- Pecos Palate                                       05            170
-- Pecos Palate                                                     170
-- Pecos Smokehouse                                   07             91
-- Pecos Smokehouse                                                  91
-- Quick Quesadilla                                   08             96
-- Quick Quesadilla                                                  96
-- Rodeo Kitchen                                      04             58
-- Rodeo Kitchen                                                     58
-- Roundup Roadhouse                                  07             49
-- Roundup Roadhouse                                                 49
-- Rustic Roast                                       08             74
-- Rustic Roast                                                      74
-- Rustler's Roadhouse                                03             40
-- Rustler's Roadhouse                                               40
-- Saddle Up Steakhouse                               08             60
-- Saddle Up Steakhouse                                              60
-- Salty Sage Eatery                                  08             50
-- Salty Sage Eatery                                                 50
-- Santa Fe Bistro                                    06             89
-- Santa Fe Bistro                                                   89
-- Silverado Station                                  08             78
-- Silverado Station                                                 78
-- Soto's Taqueria                                    02             68
-- Soto's Taqueria                                                   68
-- Spice Junction                                     03             90
-- Spice Junction                                                    90
-- Sunrise Diner                                      02             25
-- Sunrise Diner                                                     25
-- Sunset Grill                                       05             51
-- Sunset Grill                                                      51
-- Tex Mex Twist                                      06             70
-- Tex Mex Twist                                                     70
-- The Hungry Hitchin'                                07             83
-- The Hungry Hitchin'                                               83
-- The Hungry Wrangler                                04             81
-- The Hungry Wrangler                                               81
-- The Outlaw Oven                                    08             86
-- The Outlaw Oven                                                   86
-- The Ranch House                                    04             52
-- The Ranch House                                                   52
-- The Roadhouse Cafe                                 04             67
-- The Roadhouse Cafe                                 05             67
-- The Roadhouse Cafe                                               134
-- The Rolling Grill                                  07             38
-- The Rolling Grill                                                 38
-- The Sizzling Skillet                               04             63
-- The Sizzling Skillet                                              63
-- The Tasty Spoon                                    01             36
-- The Tasty Spoon                                    02             36
-- The Tasty Spoon                                    03             36
-- The Tasty Spoon                                                  108
-- The Urban Saddle                                   06             92
-- The Urban Saddle                                                  92
-- Twisted Taco                                       04             48
-- Twisted Taco                                                      48
-- Urban Eats                                         03             47
-- Urban Eats                                                        47
-- Whisk and Fork                                     05             78
-- Whisk and Fork                                                    78
--                                                                 3520


--4 Weekly Average Rating of delivery agents
COLUMN DELIVERY_AGENT FORMAT A30
SELECT
    d.FIRST_NAME || ' ' || d.LAST_NAME AS DELIVERY_AGENT,
    TO_CHAR(TRUNC(o.ORDER_DATE, 'IW'), 'YYYY-MM-DD') AS WEEK,
    ROUND(AVG(r.RATING), 2) AS WEEKLY_AVERAGE_RATING
FROM
    Spring25_S003_T7_RATES r
    JOIN Spring25_S003_T7_DELIVERY_AGENT d
    ON r.DELIVERY_AGENT_ID = d.ID
    JOIN Spring25_S003_T7_ORDERS o
    ON r.DELIVERY_AGENT_ID = o.DELIVERY_AGENT_ID
GROUP BY ROLLUP(
    d.FIRST_NAME || ' ' || d.LAST_NAME,
    TO_CHAR(TRUNC(o.ORDER_DATE,'IW'),'YYYY-MM-DD')
)
ORDER BY DELIVERY_AGENT, WEEK;

-- Output before update:
-- DELIVERY_AGENT                 WEEK       WEEKLY_AVERAGE_RATING
-- ------------------------------ ---------- ---------------------
-- Adam Thompson                  2025-01-20                     5
-- Adam Thompson                                                 5
-- Allison King                   2025-02-03                     2
-- Allison King                                                  2
-- Amber Jackson                  2025-01-20                     3
-- Amber Jackson                                                 3
-- Anna Flores                    2025-02-10                     2
-- Anna Flores                                                   2
-- Ava Mitchell                   2025-02-17                     4
-- Ava Mitchell                                                  4
-- Brandon Walker                 2025-01-27                     5
-- Brandon Walker                                                5
-- Brian Wilson                   2025-01-13                     3
-- Brian Wilson                                                  3
-- Brittany Perez                 2025-01-20                     3
-- Brittany Perez                                                3
-- Caleb Carter                   2025-02-17                     3
-- Caleb Carter                                                  3
-- Chloe Rivera                   2025-02-17                     4
-- Chloe Rivera                                                  4
-- Cody Green                     2025-02-10                     5
-- Cody Green                                                    5
-- Daniel Rodriguez               2025-01-13                     4
-- Daniel Rodriguez                                              4
-- David Jones                    2025-01-06                     2
-- David Jones                                                   2
-- Dylan Hill                     2025-02-10                     4
-- Dylan Hill                                                    4
-- Emily Brown                    2025-01-06                     4
-- Emily Brown                                                   4
-- Emma Adams                     2025-02-10                     3
-- Emma Adams                                                    3
-- Eric Thomas                    2025-01-13                     2
-- Eric Thomas                                                   2
-- Erica Scott                    2025-02-03                     4
-- Erica Scott                                                   4
-- Grace Baker                    2025-02-10                     5
-- Grace Baker                                                   5
-- Heather Robinson               2025-01-27                     4
-- Heather Robinson                                              4
-- Jacob Nelson                   2025-02-10                     4
-- Jacob Nelson                                                  4
-- Jason Martin                   2025-01-20                     4
-- Jason Martin                                                  4
-- Jessica Davis                  2025-01-06                     5
-- Jessica Davis                                                 5
-- John Smith                     2024-12-30                     4
-- John Smith                     2025-01-06                     4
-- John Smith                     2025-01-13                     4
-- John Smith                                                    4
-- Jordan Gomez                   2025-02-17                     4
-- Jordan Gomez                                                  4
-- Justin Clark                   2025-01-06                     5
-- Justin Clark                   2025-01-13                     5
-- Justin Clark                   2025-01-27                     5
-- Justin Clark                                                  5
-- Kelly White                    2025-01-20                     4
-- Kelly White                                                   4
-- Kevin Lee                      2025-01-13                     4
-- Kevin Lee                                                     4
-- Kristen Nguyen                 2025-02-03                     5
-- Kristen Nguyen                                                5
-- Laura Hernandez                2025-01-13                     3
-- Laura Hernandez                                               3
-- Lauren Sanchez                 2025-01-27                     4
-- Lauren Sanchez                                                4
-- Linda Garcia                   2025-01-06                     4
-- Linda Garcia                                                  4
-- Luke Hall                      2025-02-10                     3
-- Luke Hall                                                     3
-- Mark Harris                    2025-01-27                     3
-- Mark Harris                                                   3
-- Megan Gonzalez                 2025-01-13                     5
-- Megan Gonzalez                                                5
-- Mia Roberts                    2025-02-17                     5
-- Mia Roberts                                                   5
-- Mike Johnson                   2025-01-06                     3
-- Mike Johnson                                                  3
-- Nicole Taylor                  2025-01-20                     4
-- Nicole Taylor                                                 4
-- Olivia Young                   2025-02-03                     3
-- Olivia Young                                                  3
-- Owen Campbell                  2025-02-17                     2
-- Owen Campbell                                                 2
-- Rachel Ramirez                 2025-01-20                     2
-- Rachel Ramirez                 2025-01-27                     2
-- Rachel Ramirez                                                2
-- Robert Martinez                2025-01-06                     3
-- Robert Martinez                                               3
-- Ryan Moore                     2025-01-20                     5
-- Ryan Moore                                                    5
-- Sarah Williams                 2025-01-06                     5
-- Sarah Williams                                                5
-- Scott Lewis                    2025-01-27                     3
-- Scott Lewis                                                   3
-- Sean Torres                    2025-02-03                     3
-- Sean Torres                                                   3
-- Stephanie Anderson             2025-01-13                     4
-- Stephanie Anderson                                            4
-- Trevor Allen                   2025-02-03                     4
-- Trevor Allen                                                  4
-- Zachary Wright                 2025-02-03                     5
-- Zachary Wright                                                5
-- Zoe Phillips                   2025-02-17                     3
-- Zoe Phillips                                                  3
--                                                            3.71


-- 5 Find the restaurants that offers dishes in all cuisine
SELECT r.REST_ID,
       r.NAME
FROM   Spring25_S003_T7_RESTAURANT r
WHERE  NOT EXISTS (
          SELECT *
          FROM  (
                  SELECT DISTINCT CUISINE
                  FROM   Spring25_S003_T7_MENU
                ) c
          WHERE NOT EXISTS (
                             SELECT *
                             FROM   Spring25_S003_T7_MENU m
                             WHERE  m.REST_ID = r.REST_ID AND
                                    m.CUISINE = c.CUISINE
                )
       );

-- Output before update:
--    REST_ID NAME
-- ---------- --------------------------------------------------
-- 1000000002 Big Tex BBQ


-- 6 To identify spicy menu items for recommendation or filtering.
SELECT m.DISH_ID, m.DISH_NAME, r.NAME AS RESTAURANT
FROM Spring25_S003_T7_MENU m
JOIN Spring25_S003_T7_RESTAURANT r ON m.REST_ID = r.REST_ID
WHERE m.DISH_NAME LIKE '%Spicy%';

-- Output before update:
--    DISH_ID DISH_NAME                 RESTAURANT
-- ---------- ------------------------- --------------------------------------------------
-- 1000000001 Spicy Tuna Sushi          Big Tex BBQ
-- 1000000022 Spicy Ramen               Chili's Corner
-- 1000000045 Spicy Tuna Roll           Salty Sage Eatery


--7 Active customer in last 10 days
COLUMN NAME FORMAT A30
SELECT s.mav_id, s.FIRST_NAME || ' ' || s.LAST_NAME AS NAME
FROM Spring25_S003_T7_STUDENT s
INNER JOIN Spring25_S003_T7_ORDERS o
ON s.mav_id = o.mav_id
WHERE o.ORDER_DATE >=TO_DATE('2025-01-05', 'YYYY-MM-DD') AND o.ORDER_DATE <= TO_DATE('2025-01-15', 'YYYY-MM-DD')
GROUP BY s.mav_id, s.FIRST_NAME || ' ' || s.LAST_NAME
HAVING COUNT(*) >=1;

-- Output before update:
--     MAV_ID NAME
-- ---------- ------------------------------
-- 1002160009 Humberto Landry
-- 1002160011 Demetrius Boyer
-- 1002160000 Audrey Pacheco
-- 1002160003 Del Lewis
-- 1002160004 Rolando Fischer
-- 1002160024 Emmanuel Friedman
-- 1002160006 Aline Rich
-- 1002160008 Bradly Cherry
-- 1002160001 Jerry Suarez
-- 1002160002 Jillian Fitzpatrick
-- 1002160005 Rene Velazquez
-- 1002160007 Sammy Marsh
-- 1002160010 Isabella Mcmillan

-- Output after update:
--     MAV_ID NAME
-- ---------- ------------------------------
-- 1002160009 Humberto Landry
-- 1002160021 Chester Sanchez
-- 1002160011 Demetrius Boyer
-- 1002160000 Audrey Pacheco
-- 1002160003 Del Lewis
-- 1002160004 Rolando Fischer
-- 1002160024 Emmanuel Friedman
-- 1002160006 Aline Rich
-- 1002160008 Bradly Cherry
-- 1002160001 Jerry Suarez
-- 1002160002 Jillian Fitzpatrick
-- 1002160005 Rene Velazquez
-- 1002160007 Sammy Marsh
-- 1002160010 Isabella Mcmillan

-- Difference:
-- New entry -> 1002160021 Chester Sanchez

-- 8 Find the busiest hour of the day for customer service agents based on the number of calls made in that hour.
COLUMN hour_of_day FORMAT A11
SELECT TO_CHAR(CALL_DATE, 'HH24') AS HOUR_OF_DAY, COUNT(*) AS NUMBER_OF_CALLS
FROM SPRING25_S003_T7_CALLS
GROUP BY TO_CHAR(CALL_DATE, 'HH24')
HAVING COUNT(*) = (
                    SELECT MAX(COUNT(*))
                    FROM SPRING25_S003_T7_CALLS
                    GROUP BY TO_CHAR(CALL_DATE, 'HH24')
                   )
ORDER BY NUMBER_OF_CALLS DESC;

-- Output before update:
-- HOUR_OF_DAY NUMBER_OF_CALLS
-- ----------- ---------------
-- 09                       12
-- 11                       12
-- 10                       12
-- 12                       12

-- Output after update:
-- HOUR_OF_DAY NUMBER_OF_CALLS
-- ----------- ---------------
-- 12                       12
-- 11                       12
-- 10                       12

-- Difference:
-- Entry for hour 09 is removed