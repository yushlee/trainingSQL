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
-- 簡單子查詢
-- 查詢與查詢之間彼此獨立不能互相使用對方的欄位
SELECT S.*, G.*
FROM (
	SELECT * FROM store_information
) S, (
 SELECT * FROM geography
) G
WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID;

-- WITH (Common Table Expressions)
-- 相關子查詢
-- 查詢與查詢之間可以相互使用欄位做關聯式查詢
WITH S AS (
	SELECT * FROM store_information
), G AS (
	SELECT * FROM geography
)
SELECT G.*, S.* 
FROM S,G
WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID;

-- HR DB 資料查詢
-- 查詢每個部門高於平均部門薪資的員工
-- 1.部門平均薪資
-- 2.高於平均部門薪資的員工
-- (結果依部門平均薪資降冪排序)

-- Step1:尋找資料表、資料欄
-- EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,SALARY)
-- DEPARTMENTS(DEPARTMENT_ID,DEPARTMENT_NAME)
 
-- Step2:尋找資料表與資料表之間的關聯欄位
-- EMPLOYEES(DEPARTMENT_ID)DEPARTMENTS


SELECT E.DEPARTMENT_ID, E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY , 
	D.DEPARTMENT_NAME, DEP_SALARY.DEP_AVG_SALARY
FROM (
	-- 1.部門平均薪資
	SELECT E.DEPARTMENT_ID, FLOOR(AVG(E.SALARY)) "DEP_AVG_SALARY"
	FROM EMPLOYEES E
	GROUP BY E.DEPARTMENT_ID
) DEP_SALARY, EMPLOYEES E, DEPARTMENTS D
WHERE DEP_SALARY.DEPARTMENT_ID = E.DEPARTMENT_ID
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
-- 2.高於平均部門薪資的員工
AND E.SALARY > DEP_SALARY.DEP_AVG_SALARY
ORDER BY DEP_SALARY.DEP_AVG_SALARY DESC, E.SALARY DESC;

WITH DEP_SALARY AS (
	-- 1.部門平均薪資
	SELECT E.DEPARTMENT_ID, FLOOR(AVG(E.SALARY)) "DEP_AVG_SALARY"
	FROM EMPLOYEES E
	GROUP BY E.DEPARTMENT_ID
)
SELECT E.DEPARTMENT_ID, E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY , 
	D.DEPARTMENT_NAME, DEP_SALARY.DEP_AVG_SALARY
FROM DEP_SALARY, EMPLOYEES E, DEPARTMENTS D
WHERE DEP_SALARY.DEPARTMENT_ID = E.DEPARTMENT_ID
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
-- 2.高於平均部門薪資的員工
AND E.SALARY > DEP_SALARY.DEP_AVG_SALARY
ORDER BY DEP_SALARY.DEP_AVG_SALARY DESC, E.SALARY DESC;


WITH DEP_SALARY AS (
	-- 1.部門平均薪資
	SELECT E.DEPARTMENT_ID, FLOOR(AVG(E.SALARY)) "DEP_AVG_SALARY"
	FROM EMPLOYEES E
	GROUP BY E.DEPARTMENT_ID
),
DEP_EMP AS (
	SELECT E.*, D.DEP_AVG_SALARY
    FROM EMPLOYEES E , DEP_SALARY D
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
    AND E.SALARY > D.DEP_AVG_SALARY
)
SELECT E.DEPARTMENT_ID, E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY , 
	D.DEPARTMENT_NAME, E.DEP_AVG_SALARY
FROM DEP_EMP E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY E.DEP_AVG_SALARY DESC, E.SALARY;

-- 運用子查詢來達成資料分頁功能
SELECT * FROM (
	SELECT ROW_NUMBER()OVER(ORDER BY STORE_ID) ROW_NO, 
	S.* FROM store_information S
) S
WHERE ROW_NO BETWEEN 4 AND 6;


--   SQL EXISTS 存在式關聯查詢
-- EXISTS 是用來測試「內查詢」有沒有產生任何結果。
-- 如果有的話，系統就會執行「外查詢」中的 SQL。
-- 若是沒有的話，那整個 SQL 語句就不會產生任何結果。
-- 13,250
-- 外查詢
SELECT SUM(SALES) 
FROM store_information
WHERE EXISTS (
	-- 內查詢
	SELECT * FROM geography WHERE REGION_NAME = 'West'
);

-- EXISTS可搭配關聯式查詢就可達成資料條件限縮
-- 外查詢
SELECT SUM(SALES) 
FROM store_information S
WHERE EXISTS (
	-- 內查詢
	SELECT * FROM geography G 
    WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID
    AND G.REGION_NAME = 'West'
);

-- NOT EXISTS(是否不存在)
-- 外查詢
SELECT S.*
FROM store_information S
WHERE NOT EXISTS (
	-- 內查詢
	SELECT * FROM geography G 
);


-- SQL CASE WHEN 條件查詢
-- 1.CASE 後面接欄位
SELECT STORE_ID, STORE_NAME, SALES,
	CASE STORE_NAME
		WHEN 'Boston' THEN SALES * 2
        WHEN 'Los Angeles' THEN SALES * 1.5
        ELSE SALES
	END NEW_SALES
FROM store_information
ORDER BY STORE_NAME;

-- 2.CASE 後面不接欄位
SELECT STORE_ID, STORE_NAME, SALES,
	CASE
		WHEN (SALES BETWEEN 0 AND 1000) THEN '0-1000'
        WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
        WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
        WHEN (SALES > 300) THEN '>3000'
	END SALES_RANGE
FROM store_information
ORDER BY SALES;

-- 運用SELF JOIN 找出比自已營業額大於等於的商店資料,經由個數來計算排名
SELECT S1.STORE_ID, S1.STORE_NAME, S1.SALES,
	S2.STORE_ID, S2.STORE_NAME, S2.SALES
FROM store_information S1, store_information S2
WHERE S2.SALES >= S1.SALES
ORDER BY S1.SALES ASC, S2.SALES ASC;


SELECT S1.STORE_ID, S1.STORE_NAME, S1.SALES,
	COUNT(S2.STORE_ID) STORE_RANK
FROM store_information S1, store_information S2
WHERE S2.SALES >= S1.SALES
GROUP BY S1.STORE_ID, S1.STORE_NAME, S1.SALES
ORDER BY S1.SALES DESC;


-- 查詢各部門薪資排名前三名的員工
SELECT * FROM employees;

