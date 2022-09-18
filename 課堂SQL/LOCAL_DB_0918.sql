-- SQL UNION 聯集(不包含重覆值)
-- 1.查詢「欄位個數」必須要一致
-- 2.查詢「欄位型態」必須要一致
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
UNION
-- null,1,2
SELECT GEOGRAPHY_ID FROM store_information;

-- 可以透過 UNION(聯集) 將 LEFT JOIN + RIGHT JOIN = FULL JOIN
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM geography G 
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


--   SQL UNION ALL 聯集(包含重覆值)
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
UNION ALL
-- null,1,2
SELECT GEOGRAPHY_ID FROM store_information;

--  SQL INTERSECT 交集
--  MySQL不支援INTERSECT
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
INTERSECT
-- null,1,2
SELECT GEOGRAPHY_ID FROM store_information;


-- MySQL INTERSECT交集查詢替代方案
-- https://www.yiibai.com/mysql/sql-union-mysql.html
-- INNER JOIN + DISTINCT = INTERSECT 查詢交集結果
SELECT DISTINCT G.GEOGRAPHY_ID
FROM geography G
JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


--   SQL MINUS 排除(不包含重覆值) 



--   SQL SubQuery 子查詢
--   SQL EXISTS 存在式關聯查詢
--   SQL CASE WHEN 條件查詢
