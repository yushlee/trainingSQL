--   SQL UNION 聯集(不包含重覆值)
-- NULL、1、2
-- 1、2、3
-- 1.子查詢之間欄位個數必須相同
-- 2.子查詢之間欄位型態必須一致(MySQL無此限制)
SELECT GEOGRAPHY_ID, STORE_NAME FROM STORE_INFORMATION
UNION
SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY;

-- NULL、1、2、3
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;

--   SQL UNION ALL 聯集(包含重覆值)
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION ALL
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;

--   SQL INTERSECT 交集 (MySQL不支援)
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
INTERSECT
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;

--   SQL MINUS 排除(不包含重覆值)(MySQL不支援)
--  請注意，在 MINUS 指令下，不同的值只會被列出一次。
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
MINUS
-- 1,2,NULL
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;

--   SQL EXISTS 存在式關聯查詢
SELECT SUM(SALES) FROM STORE_INFORMATION
-- 測試是否"存在"
WHERE EXISTS (
	-- EXISTS 是用來測試「內查詢」有沒有產生任何結果
	SELECT * FROM GEOGRAPHY WHERE REGION_NAME = 'West'
);

SELECT SUM(SALES) FROM STORE_INFORMATION
-- 測試是否"不存在"
WHERE NOT EXISTS (
	-- EXISTS 是用來測試「內查詢」有沒有產生任何結果
	SELECT * FROM GEOGRAPHY WHERE REGION_NAME = 'West'
);


--   SQL EXISTS 存在式關聯查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S
-- 測試內查詢是否"存在"，如果存在就執行外查詢
WHERE EXISTS (
	-- EXISTS 是用來測試「內查詢」有沒有產生任何結果
	SELECT * FROM GEOGRAPHY G 
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
    AND REGION_NAME = 'West'
);


-- SQL CASE WHEN 條件查詢
-- ELSE 子句則並不是必須的
-- 'Los Angeles' 的 Sales 數值乘以2
-- 'San Diego' 的 Sales 數值乘以1.5
SELECT STORE_ID, STORE_NAME, SALES,
	CASE STORE_NAME
		WHEN 'Los Angeles' THEN SALES * 2
        WHEN 'San Diego' THEN SALES * 1.5
        ELSE SALES
	END "NEW_SALES"
FROM STORE_INFORMATION
ORDER BY STORE_NAME;


-- 接在CASE 之後的欄位名可以不寫
-- "條件" 可以是一個數值或是公式
-- 計算每個營業額區間的商店個數
-- 0 ~ 1000
-- 1001 ~ 2000
-- 2001 ~ 3000
-- > 3000
SELECT SALES_RANGE, COUNT(STORE_ID) 
FROM (
	SELECT STORE_ID, STORE_NAME, SALES,
		CASE WHEN (SALES BETWEEN 0 AND 1000) THEN '0-1000'
			 WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
			 WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
			 WHEN (SALES > 3000) THEN '>300'
		END "SALES_RANGE"
	FROM STORE_INFORMATION
	ORDER BY SALES
) RANGE_STORE
GROUP BY SALES_RANGE;

