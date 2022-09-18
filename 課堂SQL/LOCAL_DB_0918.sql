-- SQL UNION 聯集(不包含重覆值)
-- 1.查詢「欄位個數」必須要一致
-- 2.查詢「欄位型態」必須要一致
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
UNION
-- null,1,2
SELECT GEOGRAPHY_ID FROM store_information;

-- 可以透過 UNION(聯集) 將 LEFT JOIN + RIGHT JOIN = FULL JOIN
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME
FROM geography G 
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


--   SQL UNION ALL 聯集(包含重覆值)
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
UNION ALL
-- null,1,2
SELECT GEOGRAPHY_ID FROM store_information;

--  SQL INTERSECT 交集
--  MySQL不支援INTERSECT
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
INTERSECT
-- null,1,2
SELECT GEOGRAPHY_ID FROM store_information;


-- MySQL INTERSECT交集查詢替代方案
-- https://www.yiibai.com/mysql/sql-union-mysql.html
-- INNER JOIN + DISTINCT = INTERSECT 查詢交集結果
SELECT DISTINCT G.GEOGRAPHY_ID
FROM geography G
JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


--   SQL MINUS 排除(不包含重覆值) 
--  MySQL不支援 MINUS

-- MINUS(Oracle)
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
MINUS
-- null,1,2
SELECT GEOGRAPHY_ID FROM store_information;

-- EXCEPT(MS SQL)
SELECT GEOGRAPHY_ID FROM geography
EXCEPT
SELECT GEOGRAPHY_ID FROM store_information;

-- LEFT JOIN + table2.id IS NULL = MINUS
SELECT G.GEOGRAPHY_ID
FROM geography G
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID IS NULL;


--   SQL SubQuery 子查詢
-- 「最高營業額」的「商店資料」

-- 內部查詢本身與外部查詢沒有關係。這一類的子查詢稱為『簡單子查詢』 (Simple Subquery)
-- 外查詢
SELECT * 
FROM store_information
WHERE SALES = ( 
	-- 內查詢
	SELECT MAX(SALES) FROM store_information
);

-- 內部查詢是要利用到外部查詢提到的表格中的欄位，
-- 那這個字查詢就被稱為『相關子查詢』(Correlated Subquery)
-- 外查詢
SELECT S.STORE_ID, S.STORE_NAME, S.SALES, S.GEOGRAPHY_ID
FROM store_information S
WHERE S.GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT G.GEOGRAPHY_ID FROM geography G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);

-- SQL子查詢
-- 把一個查詢都當做是一張暫存表
SELECT S.*, G.*
FROM (
	SELECT * FROM store_information
) S, (
 SELECT * FROM geography
) G
WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID;

-- HR DB 資料查詢
-- 查詢每個部門高於平均部門薪資的員工
-- 1.部門平均薪資
-- 2.高於平均部門薪資的員工
-- (結果依部門平均薪資降冪排序)

-- Step1:尋找資料表、資料欄
-- employees(EMPLOYEE_ID,FIRST_NAME,SALARY)
-- departments(DEPARTMENT_ID,DEPARTMENT_NAME)
 
-- Step2:尋找資料表與資料表之間的關聯欄位
-- employees(DEPARTMENT_ID)departments




--   SQL EXISTS 存在式關聯查詢
--   SQL CASE WHEN 條件查詢
