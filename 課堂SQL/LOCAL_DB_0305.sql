
-- SQL UNION 聯集(不包含重覆值)
-- 1.UNION 可下多次
-- 2.UNION SQL之間欄位"型態"必須一致
-- 3.UNION SQL之間欄位資料個數必須一致
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.store_id, S.store_name 
FROM geography G
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.store_id, S.store_name 
FROM geography G
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.geography_id;

SELECT STORE_ID, STORE_NAME FROM store_information
UNION
SELECT GEOGRAPHY_ID, REGION_NAME FROM geography;


-- SQL UNION ALL 聯集(包含重覆值)
SELECT REGION_NAME FROM geography
UNION ALL
SELECT REGION_NAME FROM geography;


-- INTERSECT 交集(MySQL不支援)
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
INTERSECT
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;


-- SQL1: A、B、C、D
-- MINUS
-- SQL2: C、D、E、F
-- 查詢結果:A、B

-- 請注意，在 MINUS 指令下，不同的值只會被列出一次。 
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
MINUS
-- 1,2,null
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;
-- 查詢結果:3

-- 1,2,null
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION
MINUS
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY;
-- 查詢結果:null

-- 營業額最高的商店資料
-- 1.最高的營業額
-- 2.商店資料
-- Sub Query(子查詢) 查詢之中有查詢

-- 外查詢
SELECT * 
FROM store_information
WHERE SALES = (
	-- 內查詢
	SELECT MAX(SALES) FROM store_information
);

-- 簡單子查詢(內部查詢本身與外部查詢沒有關係)
-- 外查詢
SELECT SUM(SALES) FROM store_information
WHERE GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM geography WHERE REGION_NAME = 'West'
);


-- 相關子查詢(內部查詢是要利用到外部查詢提到的表格中的欄位)
-- 東西區所有商店營業額加總($10250)
--  外查詢
SELECT SUM(SALES) FROM store_information S
WHERE S.GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM geography G WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);

-- Temp暫存表
SELECT G.*, S.*
FROM (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography
) G,
(
	SELECT store_id, store_name, sales, geography_id FROM store_information
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- 查詢每個部門高於平均部門薪資的員工
-- 1.平均部門薪資
-- 2.高於"平均部門薪資"的員工資料
-- (結果依部門平均薪資降冪排序)
SELECT * FROM EMPLOYEES ORDER BY DEPARTMENT_ID;






























