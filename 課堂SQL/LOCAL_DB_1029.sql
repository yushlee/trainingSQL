
--   SQL SubQuery 子查詢
--   SQL EXISTS 存在式關聯查詢
--   SQL CASE WHEN 條件查詢


-- SQL UNION 聯集(不包含重覆值)
-- 1.查詢欄位個數必須相同
-- 2.查詢欄位型別必須相同(MySQL無此限制)
-- 1,2,NULL
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;
-- 結果：NULL,1,2,3

-- MySQL FULL JOIN 替代方案使用 UNION 將 LEFT JOIN + RIGHT JOIN
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM GEOGRAPHY G 
LEFT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM GEOGRAPHY G 
RIGHT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


--   SQL UNION ALL 聯集(包含重覆值)
-- 1,2,NULL
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
UNION ALL
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;


--   SQL INTERSECT 交集(不包含重覆值)(MySQL不支援)
-- 1,2,NULL
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
INTERSECT
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;
-- 結果：1,2


--   SQL INTERSECT 交集(MySQL替代寫法)
SELECT DISTINCT G.GEOGRAPHY_ID 
FROM GEOGRAPHY G
JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- SQL MINUS 排除(不包含重覆值) (MySQL不支援)
-- Oracle MINUS
-- 1,2,NULL
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
MINUS
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;
-- 結果：NULL

-- MS SQL:EXCEPT
-- 1,2,NULL
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
EXCEPT
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;

-- SQL MINUS 排除(MySQL替代寫法)
-- LEFT JOIN + table2.id IS NULL = MINUS

SELECT S.GEOGRAPHY_ID, G.GEOGRAPHY_ID
FROM STORE_INFORMATION S
LEFT JOIN GEOGRAPHY G ON S.GEOGRAPHY_ID  = G.GEOGRAPHY_ID 
WHERE G.GEOGRAPHY_ID IS NULL;

-- G:1,2,3
-- MINUS
-- S:1,2,NULL
SELECT G.GEOGRAPHY_ID, S.GEOGRAPHY_ID
FROM GEOGRAPHY G
LEFT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID IS NULL;

-- "最高營業額"的"商店資料"
-- "商店資料"
SELECT * FROM STORE_INFORMATION
WHERE SALES = (
	-- subquery子查詢
	-- "最高營業額"
	SELECT MAX(SALES) FROM STORE_INFORMATION
);

-- 『簡單子查詢』 (Simple Subquery)
-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM GEOGRAPHY WHERE REGION_NAME = 'West'
);


-- 『相關子查詢』(Correlated Subquery)
-- 10,250(扣掉join不到的6號商店營業額)
-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM GEOGRAPHY G WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID
);

-- 13,250
SELECT SUM(SALES) FROM STORE_INFORMATION;


SELECT G.*, S.*
FROM (
	SELECT * FROM GEOGRAPHY
) G,
(
	SELECT * FROM STORE_INFORMATION
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- WITH (Common Table Expressions)
-- 相關子查詢
WITH G AS (
	SELECT * FROM GEOGRAPHY
),
S AS (
	SELECT * FROM STORE_INFORMATION
)
SELECT G.*, S.*
FROM G, S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


WITH G AS (
	SELECT * FROM GEOGRAPHY
),
S AS (
	SELECT G.GEOGRAPHY_ID, G.REGION_NAME, STORE.STORE_ID, STORE.STORE_NAME
    FROM G, STORE_INFORMATION STORE
    WHERE STORE.GEOGRAPHY_ID = G.GEOGRAPHY_ID
)
SELECT * FROM S;








