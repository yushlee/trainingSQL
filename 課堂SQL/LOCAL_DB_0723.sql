-- 欄位別名
-- 1.AS 可以省略不寫
-- 2.別名須用雙引號包起來
-- 3.雙引號可省略(旦書:不可有空白)
SELECT STORE_NAME, SUM(SALES) AS "總合營業額", 
	COUNT(STORE_ID) AS "COUNT_STORE",
	GROUP_CONCAT(SALES ORDER BY SALES DESC SEPARATOR '/') "LIST SALES"
FROM STORE_INFORMATION
GROUP BY STORE_NAME
ORDER BY STORE_NAME;

-- 表格別名
SELECT G.*, S.* 
FROM geography G, store_information S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 內部連結
-- INNER JOIN ... ON
SELECT G.*, S.* 
FROM geography G INNER JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


SELECT G.*, S.* 
FROM geography G JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 外部連結
-- OUTER JOIN ... ON
-- 所有"區域"皆須全部查尋,不論該區域底下是否有從屬商店
SELECT G.*, S.* 
FROM geography G  LEFT OUTER JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 所有"商店"皆須全部查尋,不論該商店底下是否有所屬區域
SELECT G.*, S.* 
FROM geography G RIGHT JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- MySQL不支援 FULL JOIN
SELECT G.*, S.* 
FROM geography G  FULL OUTER JOIN store_information S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;










