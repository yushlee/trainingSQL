
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











