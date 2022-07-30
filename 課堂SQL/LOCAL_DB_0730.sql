

-- SQL CASE WHEN 條件查詢


-- SQL UNION 聯集(不包含重覆值)
-- JOIN 連接兩張"資料表"關聯查詢
-- UNION 合併兩個"SQL"查詢結果
-- 1.查sql欄位個數必須一致
-- 2.查sql欄位型態必須一致
SELECT STORE_ID, STORE_NAME FROM store_information
UNION
SELECT GEOGRAPHY_ID, REGION_NAME FROM geography;

SELECT STORE_NAME FROM store_information
UNION
SELECT STORE_NAME FROM store_information;

-- LEFT JOIN + RIGHT JOIN = FULL JOIN
SELECT G.*, S.*
FROM  GEOGRAPHY G
LEFT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.*, S.*
FROM  GEOGRAPHY G
RIGHT JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

--   SQL UNION ALL 聯集(包含重覆值)
SELECT STORE_NAME FROM store_information
UNION ALL
SELECT STORE_NAME FROM store_information;


-- SQL INTERSECT 交集(不包含重覆值)(MySQL不支援)
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
INTERSECT
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;

-- MySQL替代方案
-- 查詢交集結果
-- INNER JOIN + DISTINCT = INTERSECT
SELECT DISTINCT G.GEOGRAPHY_ID 
FROM GEOGRAPHY G
JOIN STORE_INFORMATION S ON G.GEOGRAPHY_ID  = S.GEOGRAPHY_ID;


-- SQL MINUS 排除(不包含重覆值)(MySQL不支援)
-- MINUS(Oracle)
-- 1,2,3
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
MINUS
-- 1,2,null
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;

-- EXCEPT (MS SQL Server)
SELECT GEOGRAPHY_ID FROM GEOGRAPHY
EXCEPT
SELECT GEOGRAPHY_ID FROM STORE_INFORMATION;

-- MySQL替代方案
-- LEFT JOIN + table2.id IS NULL = MINUS
SELECT G.GEOGRAPHY_ID, S.GEOGRAPHY_ID
FROM geography G
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID IS NULL;

-- SQL SubQuery 子查詢
-- 找出"最高"營業額的商店資料

-- 外查詢
SELECT * FROM STORE_INFORMATION
WHERE SALES = (
	-- 內查詢
	SELECT MAX(SALES) FROM STORE_INFORMATION
);

-- 『簡單子查詢』 (Simple Subquery)
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE STORE_ID IN (
	SELECT STORE_ID FROM STORE_INFORMATION WHERE GEOGRAPHY_ID = 2
);

-- 『相關子查詢』(Correlated Subquery)
-- 10,250
SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE GEOGRAPHY_ID IN (
	SELECT GEOGRAPHY_ID FROM GEOGRAPHY G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);

-- 13,250
SELECT SUM(SALES) FROM STORE_INFORMATION;

SELECT G.*, S.*
FROM (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
) G,
(
   SELECT GEOGRAPHY_ID, STORE_NAME FROM STORE_INFORMATION
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 查詢每個部門高於平均部門薪資的員工
-- (結果依部門平均薪資降冪排序)
-- 1.先算出各部門的"平均薪資"
-- 2.查詢高於平均部門薪資的員工
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.SALARY, E.DEPARTMENT_ID, 
	D.DEPARTMENT_NAME, D_AVG_SALARY.DEP_AVG_SALARY
FROM (
	SELECT DEPARTMENT_ID, FLOOR(AVG(SALARY)) DEP_AVG_SALARY
	FROM EMPLOYEES
	GROUP BY DEPARTMENT_ID
) D_AVG_SALARY, EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D_AVG_SALARY.DEPARTMENT_ID
AND E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND E.SALARY > D_AVG_SALARY.DEP_AVG_SALARY
ORDER BY D_AVG_SALARY.DEP_AVG_SALARY DESC, E.SALARY DESC;

-- 簡單子查詢
-- 查詢與查詢之間彼此獨立"不能互相使用"對方的欄位
SELECT G.*, S.*
FROM (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
) G,
(
   SELECT GEOGRAPHY_ID, STORE_NAME
   FROM STORE_INFORMATION S, G
   WHERE S.GEOGRAPHY_ID = G.GEOGRAPHY_ID
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- WITH (Common Table Expressions)
-- 關聯式子查詢
-- 查詢與查詢之間可以相互使用欄位做關聯式查詢
WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
),
S AS (
   SELECT GEOGRAPHY_ID, STORE_NAME FROM STORE_INFORMATION
)
SELECT G.*, S.* FROM G, S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
),
S AS (
   SELECT G.*,  STORE.STORE_ID, STORE.STORE_NAME 
   FROM STORE_INFORMATION STORE, G
   WHERE STORE.GEOGRAPHY_ID = G.GEOGRAPHY_ID
)
SELECT S.* FROM S;

-- SQL EXISTS 存在式關聯查詢
-- EXISTS 是用來測試「內查詢」有沒有產生任何結果。
-- 如果有的話，系統就會執行「外查詢」中的 SQL。
-- 若是沒有的話，那整個 SQL 語句就不會產生任何結果。

-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION
-- EXISTS 是用來測試「內查詢」有沒有產生任何結果
WHERE EXISTS (
	-- 內查詢
	SELECT * FROM STORE_INFORMATION
	WHERE GEOGRAPHY_ID = 2
);


-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S1
-- EXISTS 是用來測試「內查詢」有沒有產生任何結果
WHERE EXISTS (
	-- 內查詢
	SELECT * FROM STORE_INFORMATION S2
	WHERE S2.GEOGRAPHY_ID = S1.GEOGRAPHY_ID
    AND S2.GEOGRAPHY_ID = 2
);

-- 'Los Angeles' 的 Sales 數值乘以2
-- 'San Diego' 的 Sales 數值乘以1.5
SELECT STORE_ID, STORE_NAME, SALES,
	CASE STORE_NAME
		WHEN 'Los Angeles' THEN SALES * 2
        WHEN 'San Diego'  THEN SALES * 1.5
		ELSE SALES END NEW_SALES
FROM STORE_INFORMATION;

-- 查詢每個商店營業額落在哪一個數值區間(1000)
SELECT STORE_ID, STORE_NAME, SALES,
	CASE 
		WHEN (SALES BETWEEN 0 AND 1000) THEN '0-1000'
        WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
        WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
        WHEN (SALES > 3000) THEN '> 3000'
		END RANGE_SALES
FROM STORE_INFORMATION
ORDER BY SALES;

-- 自我連結 (self join)
SELECT S1.*, S2.* 
FROM STORE_INFORMATION S1, STORE_INFORMATION S2
WHERE S2.SALES >= S1.SALES
ORDER BY S1.SALES, S2.SALES;


SELECT S1.STORE_ID, S1.STORE_NAME, COUNT(S2.STORE_ID) "STORE_RANK"
FROM STORE_INFORMATION S1, STORE_INFORMATION S2
WHERE S2.SALES >= S1.SALES
GROUP BY S1.STORE_ID, S1.STORE_NAME
ORDER BY S1.SALES DESC;


-- RANK( ) OVER ( [query_partition_clause ] order_by_clause)
-- RANK(必填)：排名函數,當有同名次時(排名结果是不連續的)
-- EX:雙冠軍就不會有亞軍
-- query_partition_clause(選填)：資料分群排名劃分欄位
-- order_by_clause (必填)：資料排序欄位
SELECT STORE_ID, STORE_NAME, SALES,
	RANK() OVER (ORDER BY SALES DESC) "RANK_STORE"
FROM STORE_INFORMATION;

-- Analytic Functions with OVER Clause (分析函數)
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	RANK() OVER (PARTITION BY GEOGRAPHY_ID  ORDER BY SALES DESC) "RANK_STORE"
FROM STORE_INFORMATION
ORDER BY GEOGRAPHY_ID, SALES DESC;

-- 當有同名次時(排名结果是連續的)
SELECT STORE_ID, STORE_NAME, SALES,
	RANK () OVER (ORDER BY SALES DESC) "RANK_STORE",
    DENSE_RANK () OVER (ORDER BY SALES DESC) "DENSE_RANK_STORE",
    -- 公式：(RANK(  ) - 1)  /  (總資料列筆數 - 1
    PERCENT_RANK () OVER (ORDER BY SALES DESC) "PERCENT_RANK_STORE",
    -- 依序編號
    ROW_NUMBER () OVER (ORDER BY SALES DESC) "ROW_NUMBER_STORE"
FROM STORE_INFORMATION;

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


SELECT STORE_ID, STORE_NAME,
    ROW_NUMBER( ) OVER (ORDER BY SALES) ROWNO_STORE,
    SALES,
    -- 依「營業額」排序取"上一個"營業額
    LAG(SALES) OVER (ORDER BY SALES) PREV_SALES,
    -- 依「營業額」排序取"下一個"營業額
    LEAD(SALES) OVER (ORDER BY SALES) NEXT_SALES
FROM STORE_INFORMATION
ORDER BY SALES;

-- CEIL(x)：返回大於或等於x的最大整數值(無條件進位)
-- FLOOR(x)：返回小於或等於x的最小整數值(無條件捨去)
-- ROUND(x ,[y])：返回(四捨五入)到小數點右邊y位的x值,y預設值為0
SELECT CEIL(1.1), FLOOR(1.9), ROUND(1.125, 2);

-- MySQL
SELECT SYSDATE(), YEAR(SYSDATE()), MONTH(SYSDATE()), DAY(SYSDATE()),
HOUR(SYSDATE()), MINUTE(SYSDATE()), SECOND(SYSDATE());

SELECT STORE_DATE, YEAR(STORE_DATE) 
FROM STORE_INFORMATION
ORDER BY STORE_DATE;

SELECT STORE_DATE, MONTH(STORE_DATE)
FROM STORE_INFORMATION
WHERE MONTH(STORE_DATE) = 03
ORDER BY STORE_DATE;


-- MS SQL
SELECT GETDATE(), YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE());
SELECT GETDATE() 'Today',
DATEPART(year,GETDATE()) 'Year Part',
DATEPART(month,GETDATE()) 'Month Part',
DATEPART(day,GETDATE()) 'Day Part',
DATEPART(hour,GETDATE()) 'Hour Part',
DATEPART(minute,GETDATE()) 'Minute Part',
DATEPART(second,GETDATE()) 'Second Part',
DATEPART(millisecond,GETDATE()) 'MilliSecond Part';

-- Oracle
-- 1.ADD_MONTHS(d,x)：返回日期d加上x個月的結果
SELECT ADD_MONTHS(TO_DATE('2018/08/15', 'YYYY/mm/DD'), 3),
-- 2.LAST_DAY(D)：返回日期D的月份的最後一天的日期
LAST_DAY(TO_DATE('2008/02/01', 'YYYY/mm/DD')),
-- 3.MONTHS_BETWEEN(date1,date2)：返回在 date1 和 date2 相差的月份數.
MONTHS_BETWEEN(
  TO_DATE('2008/04/01', 'YYYY/mm/DD'), TO_DATE('2008/02/01', 'YYYY/mm/DD')
) MONTHS_BETWEEN,
-- 如果‘日’相同或 date1 和 date2 都是所在月最后一天，則返回整數
-- 否則返回的結果將包含一個小數點部分(Oracle以每月31天為計算結果的小數部分)
MONTHS_BETWEEN(
  -- 15.5/31 = 0.5
  TO_DATE('2018/02/16 12:00', 'YYYY/mm/DD HH24:MI'), TO_DATE('2018/02/01', 'YYYY/mm/DD')
) MONTHS_BETWEEN_DIFF,
-- 4.SYSDATE：返回當前的日期和時間
TO_CHAR(SYSDATE,'YYYY-mm-DD HH24:MI:SS'),
-- 5. TRUNC(D , [FORMAT])：對日期作無條件捨去運算
-- MONTH(月捨去)、YEAR(年捨去)、不帶FORMAT(日捨去)
TRUNC(
    TO_DATE('2018/05/15', 'YYYY/mm/DD'), 'MONTH'
) TRUNC_MONTH,
TRUNC(
    TO_DATE('2018/05/15', 'YYYY/mm/DD'), 'YEAR'
) TRUNC_YEAR,
TRUNC(
    TO_DATE('2018/05/15 17:45:36', 'YYYY-mm-DD HH24:MI:SS')
) TRUNC_DAY
FROM DUAL;


--  Oracle日期算術:
-- 1.d1–d2：返回d1和d2之間相差的天數
SELECT  (TO_DATE('2018/05/15','YYYY-mm-DD') - TO_DATE('2018/05/01','YYYY-mm-DD'))  DIFF_DAY,
-- 2.d1+ n ：在d1上加上n天并作為date類型返回結果
(TO_DATE('2018/05/01','YYYY-mm-DD') +  14)  ADD_DAY,
-- 3.D1–N ：從D1上減去N天并作為DATE類型返回結果(兩個日期不能相加)
(TO_DATE('2018/05/15','YYYY-mm-DD') -  14)  SUBTRACT_DAY
FROM DUAL;

-- Oracle INTERVAL 日期計算
SELECT SYSDATE,
SYSDATE - INTERVAL '1' YEAR,
SYSDATE - INTERVAL '1' MONTH,
SYSDATE - INTERVAL '1' DAY,
SYSDATE - INTERVAL '1' HOUR,
SYSDATE - INTERVAL '1' MINUTE,
SYSDATE - INTERVAL '1' SECOND
FROM DUAL;

--  MySQL日期算術:
SELECT SYSDATE(), 
DATE_ADD('2021-08-15', INTERVAL -1 DAY),
DATE_ADD('2021-08-15', INTERVAL 1 MINUTE);


-- MS SQL
SELECT GETDATE(),
DATEADD(YEAR, 1, GETDATE()) "DATEADD_YEAR",
DATEADD(MONTH, 1, GETDATE()) "DATEADD_MONTH",
DATEADD(DAY, 1, GETDATE()) "DATEADD_DAY",
DATEADD(HOUR, 1, GETDATE()) "DATEADD_HOUR",
DATEADD(MINUTE, 1, GETDATE()) "DATEADD_MINUTE",
DATEADD(SECOND, 1, GETDATE()) "DATEADD_SECOND";

SELECT GETDATE(),
DATEADD(YEAR, -1, GETDATE()) "DATESUB_YEAR";



-- Oracle 轉換函數：
-- 1.TO_CHAR(d , format)：日期轉字串
SELECT TO_CHAR(sysdate,'YYYY-mm-DD HH24:MI:SS'),
  -- 2.TO_DATE(string ,format)：字串轉日期
  TO_DATE('2018-05-15 12:30:23','YYYY-mm-DD HH24:MI:SS'),
  -- 3.TO_TIMESTAMP(string,  [format])：字串轉日期
  TO_TIMESTAMP( '2011-12-23 12:30:23.999', 'YYYY-MM-DD HH24:MI:SS.FF3'),
  -- 4.TO_NUMBER(STRING)：字串轉數字
  TO_NUMBER('3') + TO_NUMBER('2')
FROM DUAL;


-- MySQL轉換函數：
-- 1.DATE_FORMAT(date,format):日期轉字串
SELECT DATE_FORMAT(SYSDATE(), '%Y-%m-%d %T'),
-- 2.STR_TO_DATE(str,format):字串轉日期
STR_TO_DATE('2021-08-15 00:00:00', "%Y-%m-%d %T"),
DATE_ADD(STR_TO_DATE('2021-08-15 00:00:00', "%Y-%m-%d %T"), INTERVAL 5 DAY);

SELECT CONVERT(150, CHAR);
SELECT CONVERT('150', UNSIGNED INTEGER);


-- MS SQL
-- 1.日期轉字串
SELECT convert(varchar, getdate(), 100) 'mon dd yyyy hh:mmAM (or PM)'
SELECT convert(varchar, getdate(), 101) 'mm/dd/yyyy'
SELECT convert(varchar, getdate(), 102) 'yyyy.mm.dd'
SELECT convert(varchar, getdate(), 103) 'dd/mm/yyyy'
SELECT convert(varchar, getdate(), 104) 'dd.mm.yyyy'
SELECT convert(varchar, getdate(), 105) 'dd-mm-yyyy'
SELECT convert(varchar, getdate(), 106) 'dd mon yyyy'
SELECT convert(varchar, getdate(), 107) 'mon dd, yyyy'
SELECT convert(varchar, getdate(), 108) 'hh:mm:ss'
SELECT convert(varchar, getdate(), 109) 'mon dd yyyy hh:mm:ss:mmmAM (or PM)'
SELECT convert(varchar, getdate(), 110) 'mm-dd-yyyy'
SELECT convert(varchar, getdate(), 111) 'yyyy/mm/dd'
SELECT convert(varchar, getdate(), 112) 'yyyymmdd'
SELECT convert(varchar, getdate(), 113) 'dd mon yyyy hh:mm:ss:mmm'
SELECT convert(varchar, getdate(), 114) 'hh:mm:ss:mmm(24h)'
SELECT convert(varchar, getdate(), 120) 'yyyy-mm-dd hh:mm:ss(24h)'
SELECT convert(varchar, getdate(), 121) 'yyyy-mm-dd hh:mm:ss.mmm'
SELECT convert(varchar, getdate(), 126) 'yyyy-mm-ddThh:mm:ss.mmm'

-- 2.字串轉日期
SELECT convert(datetime, '2021-08-16 21:52:22', 120)　'yyyy-mm-dd hh:mm:ss(24h)'


