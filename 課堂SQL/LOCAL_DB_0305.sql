
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
-- 簡單子查詢
-- 查詢與查詢之間彼此獨立不能互相使用對方的欄位
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

SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY, E.DEPARTMENT_ID, D.DEPARTMENT_NAME , DEP.DEP_AVG
FROM (
	-- 1.平均部門薪資
	SELECT DEPARTMENT_ID, FLOOR(AVG(SALARY)) DEP_AVG
	FROM EMPLOYEES GROUP BY DEPARTMENT_ID
) DEP, EMPLOYEES E, DEPARTMENTS D
WHERE DEP.DEPARTMENT_ID = E.DEPARTMENT_ID
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
-- 2.高於"平均部門薪資"的員工資料
AND E.SALARY > DEP.DEP_AVG
ORDER BY DEP.DEP_AVG DESC, E.SALARY DESC;

-- 關聯式子查詢
-- WITH (Common Table Expressions)
-- 查詢與查詢之間可以相互使用欄位做關聯式查詢
WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography
),
S AS (
	SELECT store_id, store_name, sales, geography_id FROM store_information
)
SELECT G.*, S.* 
FROM G,S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography
),
S AS (
	SELECT store_id, store_name, sales, geography_id FROM store_information
)
SELECT G.*, S.* 
FROM G LEFT JOIN S
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- 東西區加總:$13,250
-- 外查詢
SELECT SUM(SALES) FROM store_information
WHERE EXISTS (
   -- 測試「內查詢」有沒有產生任何結果
	SELECT * FROM geography WHERE REGION_NAME = 'West'
);

-- EXISTS 關聯式子查詢
-- 外查詢
SELECT SUM(SALES) FROM store_information S
WHERE EXISTS (
   -- 測試「內查詢」有沒有產生任何結果
	SELECT * FROM geography G 
    WHERE REGION_NAME = 'West' AND G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);

-- SQL CASE WHEN 條件查詢
SELECT S.store_id, S.store_name, S.sales,
	CASE S.store_name
		WHEN 'Los Angeles' THEN S.sales * 2
		WHEN 'San Diego' THEN S.sales * 1.5
	ELSE S.sales END NEW_SALES
FROM store_information S;

-- 查詢各個營業區間的資料個數
-- 0 ~ 1000 3個
-- 1001 ~ 2000 3個
-- 2001 ~ 3000 3個
-- > 3000 0個
SELECT RANGE_SALES, COUNT(store_id)
FROM (
	SELECT S.store_id, S.store_name, S.sales,
		CASE
			WHEN (S.sales BETWEEN 0 AND 1000)  THEN '0-1000'
			WHEN (S.sales BETWEEN 1001 AND 2000)  THEN '1001-2000'
			WHEN (S.sales BETWEEN 2001 AND 3000)  THEN '2001-3000'
			WHEN (S.sales > 3000) THEN '> 3000'
		END RANGE_SALES
	FROM store_information S
) STORE_RANGE
GROUP BY RANGE_SALES
ORDER BY RANGE_SALES;

-- 做一個表格自我連結 (self join)，將結果依序列出，然後算出每一行之前(包含那一行本身)有多少行數。
SELECT S1.store_id, S1.store_name, S1.sales,
	S2.store_id, S2.store_name, S2.sales
FROM store_information S1, store_information S2
WHERE S2.sales >= S1.SALES
ORDER BY S1.SALES;

SELECT S1.store_id, S1.store_name, S1.SALES, COUNT(S2.store_id) SALES_RANK
FROM store_information S1, store_information S2
WHERE S2.sales >= S1.SALES
GROUP BY S1.store_id, S1.store_name, S1.SALES
ORDER BY SALES_RANK;

-- 全部商店排序
-- Analytic Functions with OVER Clause (分析函數)
SELECT store_id, store_name, SALES, geography_id,
	RANK() OVER(ORDER BY SALES DESC) STORE_RANK,
    DENSE_RANK() OVER(ORDER BY SALES DESC) DENSE_STORE_RANK,
    PERCENT_RANK() OVER (ORDER BY SALES DESC) PERCENT_STORE_RANK,
    ROW_NUMBER() OVER(ORDER BY SALES DESC) ROW_NUMBER_STORE_RANK
FROM store_information;


-- 商店依照各別"區域排名"
SELECT store_id, store_name, SALES, geography_id,
	RANK() OVER(PARTITION BY geography_id ORDER BY SALES DESC) STORE_RANK
FROM store_information;


SELECT * FROM store_information
ORDER BY geography_id, sales DESC;

-- Aggregate Functions with OVER Clause (聚合函數)
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
    -- 依「區域劃分」取營業額"最小值"
    MIN(SALES) OVER (PARTITION BY GEOGRAPHY_ID) MIN_SALES,
    -- 依「區域劃分」取營業額"最大值"
    MAX(SALES) OVER (PARTITION BY GEOGRAPHY_ID) MAX_SALES,
    -- 依「區域劃分」取商店"數量"
    COUNT(STORE_ID) OVER (PARTITION BY GEOGRAPHY_ID) COUNT_STORE_ID,
    -- 依「區域劃分」取營業額"總和"
    SUM(SALES) OVER (PARTITION BY GEOGRAPHY_ID) SUM_SALES,
    -- 依「區域劃分」取營業額"平均"
    AVG(SALES) OVER (PARTITION BY GEOGRAPHY_ID) AVG_SALES
FROM STORE_INFORMATION
ORDER BY GEOGRAPHY_ID, SALES;


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


-- 自我連結 (self join)，然後將結果依序列出。
-- 在做列出排名時，我們算出每一行之前 (包含那一行本身) 有多少行數；
-- 而在做累積總計時，我們則是算出每一行之前 (包含那一行本身) 的總合。 
SELECT S1.store_id, S1.store_name, S1.SALES, SUM(S2.SALES) Running_Total
FROM store_information S1, store_information S2
WHERE S2.sales >= S1.SALES
GROUP BY S1.store_id, S1.store_name, S1.SALES
ORDER BY S1.SALES DESC;


-- MySQL
-- MySQL：YEAR(date)取年、MONTH(date)取月份、DAY(date)取日
-- HOUR(date)取小時、MINUTE(date)取分鐘、SECOND(date)取秒 
SELECT SYSDATE(), YEAR(SYSDATE()), MONTH(SYSDATE()), DAY(SYSDATE()),
HOUR(SYSDATE()), MINUTE(SYSDATE()), SECOND(SYSDATE());



--  MySQL日期算術:
-- MINUTE、HOUR、DAY、WEEK、MONTH、YEAR
SELECT SYSDATE(), 
DATE_SUB(SYSDATE(), INTERVAL 2 DAY),
DATE_ADD('2021-08-15', INTERVAL 1 DAY),
DATE_ADD('2021-08-15', INTERVAL 1 MINUTE);

SELECT store_id, store_name, store_date, 
	DATE_ADD(store_date, INTERVAL 1 DAY)
FROM store_information;


-- MySQL轉換函數：
-- 1.DATE_FORMAT(date,format):日期轉字串
SELECT DATE_FORMAT(SYSDATE(), '%Y-%m-%d %T'),
-- 2.STR_TO_DATE(str,format):字串轉日期
STR_TO_DATE('2021-08-15 00:00:00', "%Y-%m-%d %T");
