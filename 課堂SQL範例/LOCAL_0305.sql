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

-- 將每一個查詢的結果視為一張資料表
SELECT G.*, S.*
FROM (
	SELECT * FROM STORE_INFORMATION
) S, (
	SELECT * FROM geography
) G
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- SQL EXISTS 存在式關聯查詢
-- EXISTS 是用來測試「內查詢」有沒有產生任何結果。
-- 如果有的話，系統就會執行「外查詢」中的 SQL。
-- 若是沒有的話，那整個 SQL 語句就不會產生任何結果。
-- EXISTS有測試的意圖，但非條件過濾限刷
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography 
    WHERE GEOGRAPHY_ID = 2
);

SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE NOT EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography 
    WHERE GEOGRAPHY_ID = 2
);

SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography G
    WHERE GEOGRAPHY_ID = 2
    AND S.GEOGRAPHY_ID = G.GEOGRAPHY_ID
);

-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE EXISTS (
	-- 內查詢
	SELECT EMPLOYEE_ID, FIRST_NAME FROM employees
);

-- SQL CASE WHEN 條件查詢
SELECT  STORE_ID, STORE_NAME, SALES,
	CASE STORE_NAME
		WHEN 'Boston' THEN SALES * 2
        WHEN 'Los Angeles' THEN SALES * 1.5
        ELSE SALES
	END "NEW_SALES"
FROM store_information;

SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	CASE GEOGRAPHY_ID
		WHEN 1 THEN '東區'
    WHEN 2 THEN '西區'
    ELSE '不分區'
	END "GEOGRAPHY_TEXT"
FROM store_information;

-- Oracle DECODE
/*
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	 DECODE(GEOGRAPHY_ID, 1, '東區', 2, '西區', '不分區') "GEOGRAPHY_TEXT"
FROM store_information;
*/

SELECT STORE_ID, STORE_NAME, SALES,
	CASE
		WHEN (SALES BETWEEN 0 AND 500) THEN '0-500'
        WHEN (SALES BETWEEN 501 AND 1000) THEN '501-1000'
        WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
        WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
        WHEN SALES > 3000 THEN ' > 3000'
	END "SALES_RANGE"
FROM store_information
ORDER BY SALES;

SELECT SALES_RANGE, COUNT(STORE_ID) 
FROM (
	SELECT STORE_ID, STORE_NAME, SALES,
		CASE
			WHEN (SALES BETWEEN 0 AND 500) THEN '0-500'
			WHEN (SALES BETWEEN 501 AND 1000) THEN '501-1000'
			WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
			WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
			WHEN SALES > 3000 THEN ' > 3000'
		END "SALES_RANGE"
	FROM store_information
	ORDER BY SALES
) SR
GROUP BY SALES_RANGE
ORDER BY SALES_RANGE;



