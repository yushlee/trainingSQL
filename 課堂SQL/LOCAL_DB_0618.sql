-- SQL UNION 聯集(不包含重覆值)
-- 1.結合兩個查詢SQL語言的查詢結果
-- 2.兩個查詢SQL的欄位查詢個數必須一致
-- 3.兩個查詢SQL的欄位型態必須一致(MySQL無此限制)

-- null,1,2
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;

-- MySQL透過UNION達到FULL JOIN的結果
-- FULL JOIN = LEFT JOIN + RINGHT JOIN
SELECT G.*, S.* 
FROM GEOGRAPHY G 
LEFT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.*, S.* 
FROM GEOGRAPHY G 
RIGHT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

  
--   SQL UNION ALL 聯集(包含重覆值)



--   SQL INTERSECT 交集
--   SQL MINUS 排除(不包含重覆值) 

--   SQL SubQuery 子查詢
--   SQL EXISTS 存在式關聯查詢
--   SQL CASE WHEN 條件查詢

