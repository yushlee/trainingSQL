



-- SQL EXISTS 存在式關聯查詢
-- SQL CASE WHEN 條件查詢

-- SQL UNION 聯集(不包含重覆值)
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

-- SQL UNION ALL 聯集(包含重覆值)
SELECT GEOGRAPHY_ID FROM geography
UNION ALL
SELECT GEOGRAPHY_ID FROM store_information;

-- 1.SQL子句之間欄位"個數"必須一致
-- 2.SQL子句之間欄位"類型"必須一致(MySQL不須一致)
-- 3.不須相同的欄位名稱
SELECT GEOGRAPHY_ID FROM geography
UNION
SELECT STORE_ID FROM store_information;

-- SQL INTERSECT 交集
-- MySQL不支援
-- Oracle、MS SQL:INTERSECT
/*
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
INTERSECT
-- NULL,1,2
SELECT GEOGRAPHY_ID FROM store_information;
*/

-- MySQL INTERSECT替代方案
-- INNER JOIN + DISTINCT = INTERSECT 查詢交集結果
-- 1,2,3
SELECT DISTINCT G.GEOGRAPHY_ID 
FROM geography G 
JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- SQL MINUS(Oracle)
-- 請注意，在 MINUS 指令下，不同的值只會被列出一次。
/*
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
MINUS
-- NULL,1,2
SELECT GEOGRAPHY_ID FROM store_information;
*/

-- SQL MINUS(MS SQL)
/*
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
EXCEPT
-- NULL,1,2
SELECT GEOGRAPHY_ID FROM store_information;
*/

-- SQL MINUS 排除(不包含重覆值) 
-- MySQL不支援(替代方案)
-- LEFT JOIN + table2.id IS NULL = MINUS
SELECT G.GEOGRAPHY_ID
FROM geography G  -- 1,2,3
LEFT JOIN store_information S -- NULL,1,2
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID IS NULL;

-- SQL SubQuery 子查詢
SELECT * FROM store_information
WHERE SALES = (
	-- 子查詢
	SELECT MAX(SALES) FROM store_information
);


SELECT * FROM store_information
WHERE STORE_ID IN (
	SELECT STORE_ID FROM store_information WHERE SALES > 1000
);

-- 『簡單子查詢』 (Simple Subquery)
SELECT * FROM store_information
WHERE STORE_ID NOT IN (
	SELECT STORE_ID FROM store_information WHERE SALES > 1000
);

-- 『相關子查詢』(Correlated Subquery)
-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE GEOGRAPHY_ID = (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM geography G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);


