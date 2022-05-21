--   SQL UNION 聯集(不包含重覆值)
-- 各SQL查詢(欄位個數必須一致、欄位型別必須一致)
SELECT STORE_ID, STORE_NAME FROM store_information
UNION
SELECT GEOGRAPHY_ID,REGION_NAME FROM geography;


-- MySQL 透過UNION查詢將LEFT JOIN、RIGHT JOIN合併查詢實現FULL JOIN
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME, S.STORE_DATE
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME, S.STORE_DATE
FROM geography G 
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

--   SQL UNION ALL 聯集(包含重覆值)
SELECT STORE_NAME FROM store_information
UNION ALL
SELECT REGION_NAME FROM geography;


--   SQL INTERSECT 交集 (PS:MySQL不支援INTERSECT)
-- 請注意，在 INTERSECT 指令下，不同的值只會被列出一次。 
-- 1、2、3
SELECT GEOGRAPHY_ID FROM geography
INTERSECT
SELECT GEOGRAPHY_ID FROM store_information;


-- https://www.yiibai.com/mysql/sql-union-mysql.html
-- INNER JOIN + DISTINCT = INTERSECT(不包含重覆值)查詢交集結果
SELECT DISTINCT G.GEOGRAPHY_ID 
FROM geography G
JOIN store_information S ON G.GEOGRAPHY_ID  = S.GEOGRAPHY_ID;


-- SQL MINUS 排除(不包含重覆值) 
-- (PS:MySQL不支援 MINUS)
-- 先找出第一個 SQL 語句所產生的結果，
-- 然後看這些結果「有沒有在第二個 SQL 語句的結果中」。
-- 如果「有」的話，那這一筆資料就被「去除」，而不會在最後的結果中出現。
-- 如果「沒有」的話，那這一筆資料就被「保留」，而就會在最後的結果中出現。
SELECT GEOGRAPHY_ID FROM geography
MINUS
SELECT GEOGRAPHY_ID FROM store_information;


-- https://www.yiibai.com/mysql/minus.html
-- LEFT JOIN + table2.id IS NULL = MINUS
SELECT G.GEOGRAPHY_ID 
FROM geography G
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID IS NULL;


--   SQL SubQuery 子查詢
-- 找出營業額最高的商店資料

-- 外查詢
SELECT * FROM store_information
WHERE SALES = (
	-- 內查詢
	SELECT MAX(SALES) FROM store_information
);


-- 『簡單子查詢』 (Simple Subquery)
-- 外查詢
SELECT SUM(SALES)
FROM store_information
WHERE GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM geography WHERE REGION_NAME = 'West'
);


-- 『相關子查詢』(Correlated Subquery)
SELECT SUM(S.SALES)
FROM store_information S
WHERE S.GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID G
    FROM geography G WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);


SELECT  G.*, S.*
FROM (
   SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
) G , 
(
   SELECT GEOGRAPHY_ID, STORE_ID, STORE_NAME 
   FROM STORE_INFORMATION
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;




--   SQL EXISTS 存在式關聯查詢
--   SQL CASE WHEN 條件查詢
