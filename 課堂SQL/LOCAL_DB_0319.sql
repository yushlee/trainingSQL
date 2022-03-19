-- 9筆
SELECT * FROM store_information;

-- 3筆
SELECT * FROM geography;

-- 27筆
SELECT S.*, G.*
FROM store_information S, geography G
WHERE S.geography_id = G.GEOGRAPHY_ID;

-- INNER JOIN...ON(內部連接)
SELECT S.*, G.*
FROM store_information S 
INNER JOIN geography G ON S.geography_id = G.GEOGRAPHY_ID
WHERE S.sales > 2000;


SELECT G.*,S.*
FROM geography G INNER JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

-- INNER 可省略
SELECT G.*,S.*
FROM geography G JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

-- OUTER JOIN ON (外部連結)
-- OUTER可省略
SELECT G.*,S.*
FROM geography G LEFT OUTER JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

SELECT G.*,S.*
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;


SELECT G.*,S.*
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;


SELECT G.*,S.*
FROM geography G RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

-- MySQL不支援 FULL JOIN
SELECT G.*,S.*
FROM geography G FULL JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;