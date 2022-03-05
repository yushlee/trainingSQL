
-- SQL UNION 聯集(不包含重覆值)
-- 1.UNION 可下多次
-- 2.UNION SQL之間欄位"型態"必須一致
-- 3.UNION SQL之間欄位資料個數必須一致
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.store_id, S.store_name 
FROM geography G
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.store_id, S.store_name 
FROM geography G
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

SELECT STORE_ID, STORE_NAME FROM store_information
UNION
SELECT GEOGRAPHY_ID, REGION_NAME FROM geography;


-- SQL UNION ALL 聯集(包含重覆值)
SELECT REGION_NAME FROM geography
UNION ALL
SELECT REGION_NAME FROM geography;


-- INTERSECT 交集(MySQL不支援)
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
INTERSECT
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;












