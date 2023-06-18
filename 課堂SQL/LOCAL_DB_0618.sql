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
-- 9筆
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION ALL
-- 3筆
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;


--   SQL INTERSECT 交集(MySQL不支援)
/*
-- null,1,2
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
INTERSECT
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;
*/

-- MySQL達成INTERSECT語法替代方案
-- INNER JOIN + DISTINCT = INTERSECT
SELECT DISTINCT G.GEOGRAPHY_ID
FROM GEOGRAPHY G
JOIN STORE_INFORMATION S ON  G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

--   SQL MINUS 排除(不包含重覆值) 
-- MINUS (Oracle)、EXCEPT (MS SQL)指令是運用在兩個 SQL 語句上
-- 它先找出第一個 SQL 語句所產生的結果，
-- 然後看這些結果「有沒有在第二個 SQL 語句的結果中」。
-- 如果「有」的話，那這一筆資料就被「去除」，而不會在最後的結果中出現。
-- 如果「沒有」的話，那這一筆資料就被「保留」，而就會在最後的結果中出現。
/*
-- MINUS(Oracle)
-- 查詢結果:3
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
MINUS
-- null,1,2
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;

-- EXCEPT(MS SQL)
-- 查詢結果:3
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
EXCEPT
-- null,1,2
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;
*/

-- MySQL MINUS替代方案
-- LEFT JOIN + table2.id IS NULL = MINUS
SELECT G.GEOGRAPHY_ID
FROM GEOGRAPHY G
LEFT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID IS NULL;


--   SQL SubQuery 子查詢

-- 『簡單子查詢』 (Simple Subquery)
-- 外查詢
SELECT S.* 
FROM STORE_INFORMATION S
-- [比較運算素] 可以是相等的運算素，例如 =, >, <, >=, <=
WHERE S.SALES = (
	-- 內查詢
	SELECT MAX(S.SALES)
	FROM STORE_INFORMATION S
);

-- 外查詢
SELECT G.*
FROM GEOGRAPHY G
WHERE G.GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT S.GEOGRAPHY_ID
	FROM STORE_INFORMATION S
	WHERE S.SALES < 2000
);

-- 『相關子查詢』(Correlated Subquery)
-- 外查詢
SELECT SUM(S.SALES)
FROM STORE_INFORMATION S
WHERE S.GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT G.GEOGRAPHY_ID
	FROM GEOGRAPHY G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);

-- 查詢與查詢之間彼此獨立不能互相使用對方的欄位
SELECT S.*, G.*
FROM (
	SELECT S.* FROM STORE_INFORMATION S
) S, 
(
	SELECT G.* FROM GEOGRAPHY G
) G
WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID;


-- WITH (Common Table Expressions)
-- 且查詢與查詢之間可以相互使用欄位做關聯式查詢
WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
),
S AS (
	SELECT STORE_ID, STORE_NAME, SALES, STORE_DATE, GEOGRAPHY_ID FROM STORE_INFORMATION
)
SELECT G.*, S.* 
FROM G
JOIN S  ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- SQL EXISTS 存在式關聯查詢
-- EXISTS 是用來"測試"「內查詢」有沒有產生任何結果。
-- 如果有的話，系統就會執行「外查詢」中的 SQL。
-- 若是沒有的話，那整個 SQL 語句就不會產生任何結果。

-- 外查詢(商店)
SELECT S.* 
FROM STORE_INFORMATION S
WHERE EXISTS (
	-- 內查詢(區域)
    SELECT G.* FROM GEOGRAPHY G
);

-- EXISTS 存在式關聯式子查詢
-- 外查詢(商店)
SELECT S.* 
FROM STORE_INFORMATION S
WHERE EXISTS (
	-- 內查詢(區域)
    SELECT G.* FROM GEOGRAPHY G 
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
    AND G.GEOGRAPHY_ID = 1
);

--   SQL CASE WHEN 條件查詢
-- CASE後面「接欄位」
SELECT STORE_ID, STORE_NAME, SALES,
	CASE STORE_NAME
		WHEN 'Los Angeles' THEN SALES * 2
        WHEN 'San Diego' THEN  SALES * 1.5
        ELSE SALES
	END "NEW_SALES"
FROM STORE_INFORMATION;

-- CASE後面「不接欄位」只有WHEN條件
SELECT STORE_ID, STORE_NAME, SALES,
	CASE 
		WHEN (SALES BETWEEN 0 AND 1000) THEN '0-1000'
        WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
        WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
        WHEN SALES > 3000 THEN '>3000'
	END "SALES_RANGE"
FROM STORE_INFORMATION
ORDER BY SALES;


SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
  CASE GEOGRAPHY_ID
    WHEN 1 THEN '東區'
    WHEN 2 THEN '西區'
    WHEN 3 THEN '北區'
    WHEN 4 THEN '南區'
  ELSE '不分區'
  END "區域名稱"
FROM STORE_INFORMATION;

-- Oracle DECODE
/*
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
  DECODE(GEOGRAPHY_ID, 1, '東區', 2, '西區', 3, '北區',4, '南區', '不分區') "區域名稱"
FROM STORE_INFORMATION;
*/

-- SQL當然也支援排名的函數，讓你可以更方便的達成一
-- 些排名上的需求議題(例:分組排名、現實中的名次規則)

-- 全商店營業額排名
SELECT STORE_ID, STORE_NAME, SALES,
	RANK() OVER (ORDER BY SALES DESC) "STORE_RANK"
FROM STORE_INFORMATION;

-- Analytic Functions with OVER Clause (分析函數)
-- 資料分群排名劃分欄位
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	RANK() OVER (
		PARTITION BY GEOGRAPHY_ID ORDER BY SALES DESC
	) "GEOGRAPHY_STORE_RANK"
FROM STORE_INFORMATION;


-- DENSE_RANK (  )：當有同名次時(排名结果是連續的)
-- PERCENT_RANK (  )：名次所佔的百分比
-- 公式：(RANK() - 1)  /  (總資料列筆數 - 1)
-- (8-1) / (9-1) = 0.875
SELECT STORE_ID, STORE_NAME, SALES,
	RANK() OVER (ORDER BY SALES DESC) "STORE_RANK",
    DENSE_RANK() OVER (ORDER BY SALES DESC) "STORE_DENSE_RANK",
    PERCENT_RANK() OVER (ORDER BY SALES DESC) "STORE_PERCENT_RANK",
    ROW_NUMBER() OVER (ORDER BY SALES DESC) "STORE_ROW_NUMBER"
FROM STORE_INFORMATION;

-- CEIL(x)：返回大於或等於x的最大整數值(無條件進位)
-- FLOOR( x)：返回小於或等於x的最小整數值(無條件捨去)
-- ROUND(x ,[y])：
-- 返回(四捨五入)到小數點右邊y位的x值,y預設值為0
-- 如果y是負數，則捨入到小數點左邊相應的整數位上
SELECT CEIL(123.1), FLOOR(123.9),
	ROUND(123.4), ROUND(123.5), ROUND(123.15, 1), ROUND(123456, -2);

-- TRUNC(x ,[y])：返回截尾到Y位小數的X值，不做捨入處理,Y預設值為0,將X截尾為一個整數值,如果Y是負數則結尾到小數點左邊相應的位上
-- ORACLE
-- SELECT TRUNC(123.129, 2) FROM DUAL;
