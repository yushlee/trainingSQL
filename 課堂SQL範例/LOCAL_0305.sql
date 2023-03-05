-- SQL UNION 聯集(不包含重覆值)
-- SQL UNION ALL 聯集(包含重覆值)
-- SQL INTERSECT 交集
-- SQL MINUS 排除(不包含重覆值) 
-- SQL SubQuery 子查詢
-- SQL EXISTS 存在式關聯查詢
-- SQL CASE WHEN 條件查詢

-- SQL UNION 聯集(不包含重覆值)
-- 3
SELECT GEOGRAPHY_ID FROM geography 
UNION
SELECT GEOGRAPHY_ID FROM store_information;

SELECT * FROM geography;
SELECT * FROM store_information;

SELECT G.*, S.* 
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.*, S.* 
FROM geography G 
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- FULL JOIN = LEFT JOIN + RIGHT JOIN
/*
SELECT G.*, S.* 
FROM geography G 
FULL JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;
*/


