-- 9筆
SELECT * FROM store_information;

-- 3筆
SELECT * FROM geography;

-- 27筆
SELECT S.*, G.*
FROM store_information S, geography G
WHERE S.geography_id = G.GEOGRAPHY_ID;

-- INNER JOIN...ON
SELECT S.*, G.*
FROM store_information S 
INNER JOIN geography G ON S.geography_id = G.GEOGRAPHY_ID
WHERE S.sales > 2000;

