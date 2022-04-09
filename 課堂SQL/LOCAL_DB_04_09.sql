
-- UNION 聯集(不包含重覆值)
-- 1.UNION 跟 JOIN(需要下表格連結欄位 JOIN...ON...) 有些許類似
-- 2.查詢結果不包含重覆值
-- 3.查詢之間欄位必須相同(欄位型態) MySQL無此限制
-- 4.查詢之間欄位必須相同(欄位個數)
SELECT STORE_NAME FROM store_information
UNION
SELECT REGION_NAME FROM geography;

SELECT STORE_NAME FROM store_information
UNION
SELECT GEOGRAPHY_ID FROM geography;


SELECT STORE_ID, STORE_NAME FROM store_information
UNION
SELECT GEOGRAPHY_ID FROM geography;


SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME, S.SALES
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME, S.SALES
FROM geography G 
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- SQL UNION ALL 聯集(包含重覆值)
SELECT STORE_NAME FROM store_information
UNION ALL
SELECT STORE_NAME FROM store_information;


-- SQL INTERSECT 交集 (MySQL沒支援)
-- 結果結果:1,2
-- 1,2,null
SELECT GEOGRAPHY_ID FROM store_information
INTERSECT
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography;


-- SQL MINUS 排除(不包含重覆值) (MySQL沒支援)
-- MINUS (Oracle)、EXCEPT (MS SQL)
-- 結果結果:3
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
MINUS
-- 1,2,null
SELECT GEOGRAPHY_ID FROM store_information;

-- 子查詢 Sub Query
SELECT * FROM STORE_INFORMATION
WHERE SALES = (
	SELECT MAX(SALES) FROM STORE_INFORMATION
);











