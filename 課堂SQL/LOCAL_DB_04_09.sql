
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
-- 外查詢
SELECT * FROM STORE_INFORMATION
WHERE SALES = (
	-- 內查詢
	SELECT MAX(SALES) FROM STORE_INFORMATION
);


SELECT SUM(SALES) FROM STORE_INFORMATION 
WHERE GEOGRAPHY_ID IN (
	SELECT GEOGRAPHY_ID FROM GEOGRAPHY WHERE REGION_NAME = 'West'
);

-- 『相關子查詢』(Correlated Subquery
-- "內查詢"使用"外查詢"欄位做關聯查詢
-- 10250
-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM GEOGRAPHY G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);

-- 13250
SELECT SUM(SALES) FROM STORE_INFORMATION;

SELECT * FROM STORE_INFORMATION;

-- 簡單子查詢
SELECT G.*, S.* FROM (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
) G, 
(
	SELECT GEOGRAPHY_ID, STORE_ID, STORE_NAME FROM STORE_INFORMATION
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 查詢與查詢之間彼此獨立不能互相使用對方的欄位做關聯查詢
SELECT G.*, S.* 
FROM (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
) G, 
(
	SELECT STORE.GEOGRAPHY_ID, STORE.STORE_ID, STORE.STORE_NAME 
    FROM STORE_INFORMATION STORE, G
    WHERE STORE.GEOGRAPHY_ID = G.GEOGRAPHY_ID
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- Common Table Expressions
-- 相關子查詢
WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
),
S AS (
	SELECT GEOGRAPHY_ID, STORE_ID, STORE_NAME FROM STORE_INFORMATION
)
SELECT * FROM G,S 
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 查詢與查詢之間可以相互使用欄位做關聯式查詢
-- PS：注意只能下面的查詢使用上面查詢的欄位
WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
),
S AS (
	SELECT STORE.GEOGRAPHY_ID, STORE.STORE_ID, STORE.STORE_NAME 
    FROM STORE_INFORMATION STORE, G
    WHERE STORE.GEOGRAPHY_ID = G.GEOGRAPHY_ID
)
SELECT * FROM G,S 
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- SQL 子查詢相關應用(分頁功能)
SELECT S.* FROM (
	SELECT ROW_NUMBER() OVER() ROW_NUM, STORE_ID, STORE_NAME,SALES, STORE_DATE 
	FROM store_information
) S
WHERE S.ROW_NUM BETWEEN 4 AND 6;

-- 13,250
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
    WHERE REGION_NAME = 'West'
);

-- 存在式關聯子查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME 
    FROM GEOGRAPHY G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
    AND REGION_NAME = 'West'
);

-- CASE 接之後的"欄位"
SELECT STORE_ID, STORE_NAME, SALES,
	CASE STORE_NAME
		WHEN 'Los Angeles' THEN  SALES * 2
        WHEN 'San Diego' THEN  SALES * 1.5
        ELSE SALES END NEW_SALES
FROM STORE_INFORMATION
ORDER BY STORE_NAME;

-- CASE 接之後的"條件"
SELECT STORE_ID, STORE_NAME, SALES,
	CASE
		WHEN (SALES BETWEEN 0 AND 1000) THEN '0-1000'
        WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
        WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
        WHEN (SALES > 300) THEN '>3000'
        END SALES_RANGE
FROM STORE_INFORMATION
ORDER BY SALES;

-- 運用CASE WHEN查詢每間營業額的所屬數字範圍區間
-- GROUP BY來計算各「數字範圍區間」的資料個數
SELECT S.SALES_RANGE, COUNT(S.STORE_ID)
FROM (
	SELECT STORE_ID, STORE_NAME, SALES,
		CASE
			WHEN (SALES BETWEEN 0 AND 1000) THEN '0-1000'
			WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
			WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
			WHEN (SALES > 300) THEN '>3000'
			END SALES_RANGE
	FROM STORE_INFORMATION
	ORDER BY SALES
)S GROUP BY S.SALES_RANGE;


-- 自我連結 (self join)
-- 算出有多少筆資料 Sales 欄位的值是比自己本身的值高或是相等。
SELECT S1.*, S2.* 
FROM STORE_INFORMATION S1, STORE_INFORMATION S2
WHERE S2.SALES >= S1.SALES
ORDER BY S1.SALES, S2.SALES;


SELECT S1.STORE_ID, S1.STORE_NAME, S1.SALES, COUNT(S2.STORE_ID)
FROM STORE_INFORMATION S1, STORE_INFORMATION S2
WHERE S2.SALES >= S1.SALES
GROUP BY S1.STORE_ID, S1.STORE_NAME, S1.SALES
ORDER BY S1.SALES DESC, S2.SALES;
