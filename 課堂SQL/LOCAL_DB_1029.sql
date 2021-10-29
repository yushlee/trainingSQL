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


-- 表格自我連結 (self join)，將結果依序列出，然後算出每一行之前(包含那一行本身)有多少行數。
SELECT S1.STORE_ID, S1.STORE_NAME, S1.SALES, COUNT(S2.STORE_ID) "RANK"
FROM STORE_INFORMATION S1, STORE_INFORMATION S2
WHERE S2.SALES >= S1.SALES
GROUP BY S1.STORE_ID, S1.STORE_NAME, S1.SALES
ORDER BY S1.SALES DESC;

-- 全部商店營業額排名
SELECT STORE_ID, STORE_NAME, SALES,
	RANK()OVER(ORDER BY SALES DESC) "RANK"
FROM STORE_INFORMATION;

-- 商店依照區域分別營業額排名(分群排名)
-- query_partition_clause(選填)：資料分群排名劃分欄位
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	RANK()OVER(PARTITION BY GEOGRAPHY_ID ORDER BY SALES DESC) "RANK"
FROM STORE_INFORMATION
ORDER BY GEOGRAPHY_ID, SALES DESC;


-- DENSE_RANK ( )：當有同名次時(排名结果是連續的)
-- PERCENT_RANK (  )：名次所佔的百分比
-- ROW_NUMBER (  ) ：依序編號
SELECT STORE_ID, STORE_NAME, SALES,
	RANK()OVER(ORDER BY SALES DESC) "RANK",
    DENSE_RANK()OVER(ORDER BY SALES DESC) "DENSE_RANK",
    PERCENT_RANK()OVER(ORDER BY SALES DESC) "PERCENT_RANK",
    ROW_NUMBER()OVER(ORDER BY SALES DESC) "ROW_NUMBER"
FROM STORE_INFORMATION;


-- Aggregate Functions with OVER Clause (聚合函數)
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	-- 依「區域劃分」取營業額"最大值"
	MAX(SALES)OVER(PARTITION BY GEOGRAPHY_ID) MAX_SALES,
    -- 依「區域劃分」取營業額"最小值"
    MIN(SALES)OVER(PARTITION BY GEOGRAPHY_ID) MIN_SALES,
    -- 依「區域劃分」取商店"數量"
    COUNT(SALES)OVER(PARTITION BY GEOGRAPHY_ID) COUNT_GEOGRAPHY_STORE,
    -- 依「區域劃分」取營業額"總和"
    SUM(SALES)OVER(PARTITION BY GEOGRAPHY_ID) SUM_SALES,
    -- 依「區域劃分」取營業額"平均"
    AVG(SALES)OVER(PARTITION BY GEOGRAPHY_ID) AVG_SALES
FROM STORE_INFORMATION
ORDER BY GEOGRAPHY_ID, SALES DESC;

-- Analytic Functions with OVER Clause (分析函數)
SELECT STORE_ID, STORE_NAME,
    ROW_NUMBER( ) OVER (ORDER BY SALES) ROWNO_STORE,
    SALES,
    -- 依「營業額」排序取"上一個"營業額
    LAG(SALES) OVER (ORDER BY SALES) PREV_SALES,
    -- 依「營業額」排序取"下一個"營業額
    LEAD(SALES) OVER (ORDER BY SALES) NEXT_SALES
FROM STORE_INFORMATION
ORDER BY SALES;



