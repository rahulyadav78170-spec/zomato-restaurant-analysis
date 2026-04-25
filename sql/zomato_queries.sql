-- Zomato Bangalore Restaurant Analysis
-- Author: [Rahul]
-- Tool: MySQL

USE zomato_db;

-- Q1) Top localities by rating
  SELECT location,
           ROUND(AVG(rate), 2)         AS avg_rating,
           COUNT(*)                    AS total_restaurants,
           ROUND(AVG(cost_for_two), 0) AS avg_cost
    FROM restaurants
    WHERE rate IS NOT NULL
    GROUP BY location
    HAVING COUNT(*) >= 50
    ORDER BY avg_rating DESC
    LIMIT 10;
    
  -- Q2) Online ordering impact
    SELECT CASE WHEN online_order = 1 THEN 'Online ON'
                ELSE 'Online OFF' END  AS segment,
           COUNT(*)                    AS restaurants,
           ROUND(AVG(rate), 3)         AS avg_rating,
           ROUND(AVG(votes), 0)        AS avg_votes
    FROM restaurants
    WHERE rate IS NOT NULL
    GROUP BY online_order
    ORDER BY avg_rating DESC;
    
   -- Q3) Cuisine saturation
    SELECT 
    cuisines,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(votes), 0) AS avg_votes
FROM restaurants
WHERE cuisines IS NOT NULL
GROUP BY cuisines
HAVING COUNT(*) >= 30
ORDER BY restaurant_count DESC;

 -- Q4) Price tier vs rating
    SELECT CASE
               WHEN cost_for_two <= 200  THEN '1. Budget (<=200)'
               WHEN cost_for_two <= 500  THEN '2. Mid (201-500)'
               WHEN cost_for_two <= 1000 THEN '3. Premium (501-1000)'
               ELSE                           '4. Luxury (1000+)'
           END                        AS price_tier,
           COUNT(*)                   AS restaurant_count,
           ROUND(AVG(rate), 3)        AS avg_rating,
           ROUND(AVG(votes), 0)       AS avg_votes
    FROM restaurants
    WHERE rate IS NOT NULL AND cost_for_two IS NOT NULL
    GROUP BY price_tier
    ORDER BY price_tier;
    
    -- Q5)  Restaurant types by engagement
    SELECT rest_type,
           COUNT(*)             AS restaurant_count,
           ROUND(AVG(votes), 0) AS avg_votes_per_outlet,
           ROUND(AVG(rate), 2)  AS avg_rating
    FROM restaurants
    WHERE rest_type IS NOT NULL AND rate IS NOT NULL
    GROUP BY rest_type
    HAVING COUNT(*) >= 100
    ORDER BY avg_votes_per_outlet DESC
    LIMIT 8;
    
    -- Q6) High demand, low supply zones
    SELECT location,
           COUNT(*)                    AS restaurant_count,
           ROUND(AVG(votes), 0)        AS avg_votes,
           ROUND(AVG(rate), 2)         AS avg_rating,
           ROUND(AVG(cost_for_two), 0) AS avg_cost
    FROM restaurants
    WHERE rate IS NOT NULL
    GROUP BY location
    HAVING restaurant_count BETWEEN 10 AND 50
       AND avg_votes >= 150
    ORDER BY avg_votes DESC
    LIMIT 10;
