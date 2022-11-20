-- Ctrl + /

-- SQL SubQuery 子查詢
-- SQL EXISTS 存在式關聯查詢
-- SQL CASE WHEN 條件查詢

-- SQL UNION 聯集(不包含重覆值)
-- 1.各查詢之間所查詢的欄位"個數"必須一致!
-- 2.各查詢之間所查詢的欄位"型別"必須一致!
-- 1,2,3,null
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION
-- 1,2,3
SELECT GEOGRAPHY_ID  FROM GEOGRAPHY;

-- MySQL無此限制
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION
-- 1,2,3
SELECT REGION_NAME FROM GEOGRAPHY;


-- SQL UNION ALL 聯集(包含重覆值)
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION ALL
SELECT GEOGRAPHY_ID  FROM GEOGRAPHY;


-- SQL INTERSECT 交集
-- 1,2,3,null
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
INTERSECT
-- 1,2,3
SELECT GEOGRAPHY_ID  FROM GEOGRAPHY;


-- MySQL沒有支援INTERSECT(替代方案)
-- https://www.yiibai.com/mysql/sql-union-mysql.html
-- INNER JOIN + DISTINCT = INTERSECT查詢交集結果
SELECT DISTINCT G.GEOGRAPHY_ID 
FROM GEOGRAPHY G
JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID  = S.GEOGRAPHY_ID;


-- 在 MINUS 指令下，不同的值只會被列出一次。 
-- SQL MINUS 排除(不包含重覆值) 
--  MINUS (Oracle)、EXCEPT (MS SQL)指令是運用在兩個 SQL 語句上
-- 它先找出第一個 SQL 語句所產生的結果，
-- 然後看這些結果「有沒有在第二個 SQL 語句的結果中」。
-- 如果「有」的話，那這一筆資料就被「去除」，而不會在最後的結果中出現。
-- 如果「沒有」的話，那這一筆資料就被「保留」，而就會在最後的結果中出現。


-- 1,2,3
SELECT GEOGRAPHY_ID  FROM GEOGRAPHY
MINUS
-- 1,2,null
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;
-- 查詢結果:3

-- MySQL沒有支援 MINUS(替代方案)
-- https://www.yiibai.com/mysql/minus.html
-- LEFT JOIN + table2.id IS NULL = MINUS
-- LEFT JOIN - INNER JOIN = MINUS
SELECT G.GEOGRAPHY_ID 
FROM geography G
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID IS NULL;

-- 查詢"最高營業額"的"商店資料"
-- 外查詢
SELECT * FROM STORE_INFORMATION
WHERE SALES = (
	-- 內查詢
	SELECT MAX(SALES) FROM STORE_INFORMATION
);


-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM geography WHERE REGION_NAME = 'West'
);


-- 內部查詢本身與外部查詢沒有關係。這一類的子查詢稱為『簡單子查詢』 (Simple Subquery)
-- 部查詢是要利用到外部查詢提到的表格中的欄位，那這個字查詢就被稱為『相關子查詢』(Correlated Subquery)
-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S 
WHERE GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM GEOGRAPHY G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);




