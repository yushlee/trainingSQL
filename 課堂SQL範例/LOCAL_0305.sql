-- SQL UNION 聯集(不包含重覆值)
SELECT GEOGRAPHY_ID FROM geography 
UNION
SELECT GEOGRAPHY_ID FROM store_information;

SELECT * FROM geography;
SELECT * FROM store_information;

SELECT G.*, S.* 
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.*, S.* 
FROM geography G 
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- FULL JOIN = LEFT JOIN + RIGHT JOIN
/*
SELECT G.*, S.* 
FROM geography G 
FULL JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;
*/

-- SQL UNION ALL 聯集(包含重覆值)
SELECT GEOGRAPHY_ID FROM geography
UNION ALL
SELECT GEOGRAPHY_ID FROM store_information;

-- 1.SQL子句之間欄位"個數"必須一致
-- 2.SQL子句之間欄位"類型"必須一致(MySQL不須一致)
-- 3.不須相同的欄位名稱
SELECT GEOGRAPHY_ID FROM geography
UNION
SELECT STORE_ID FROM store_information;

-- SQL INTERSECT 交集
-- MySQL不支援
-- Oracle、MS SQL:INTERSECT
/*
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
INTERSECT
-- NULL,1,2
SELECT GEOGRAPHY_ID FROM store_information;
*/

-- MySQL INTERSECT替代方案
-- INNER JOIN + DISTINCT = INTERSECT 查詢交集結果
-- 1,2,3
SELECT DISTINCT G.GEOGRAPHY_ID 
FROM geography G 
JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- SQL MINUS(Oracle)
-- 請注意，在 MINUS 指令下，不同的值只會被列出一次。
/*
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
MINUS
-- NULL,1,2
SELECT GEOGRAPHY_ID FROM store_information;
*/

-- SQL MINUS(MS SQL)
/*
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
EXCEPT
-- NULL,1,2
SELECT GEOGRAPHY_ID FROM store_information;
*/

-- SQL MINUS 排除(不包含重覆值) 
-- MySQL不支援(替代方案)
-- LEFT JOIN + table2.id IS NULL = MINUS
SELECT G.GEOGRAPHY_ID
FROM geography G  -- 1,2,3
LEFT JOIN store_information S -- NULL,1,2
ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
WHERE S.GEOGRAPHY_ID IS NULL;

-- SQL SubQuery 子查詢
SELECT * FROM store_information
WHERE SALES = (
	-- 子查詢
	SELECT MAX(SALES) FROM store_information
);


SELECT * FROM store_information
WHERE STORE_ID IN (
	SELECT STORE_ID FROM store_information WHERE SALES > 1000
);

-- 『簡單子查詢』 (Simple Subquery)
SELECT * FROM store_information
WHERE STORE_ID NOT IN (
	SELECT STORE_ID FROM store_information WHERE SALES > 1000
);

-- 『相關子查詢』(Correlated Subquery)
-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE GEOGRAPHY_ID = (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM geography G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);

-- 將每一個查詢的結果視為一張資料表
SELECT G.*, S.*
FROM (
	SELECT * FROM STORE_INFORMATION
) S, (
	SELECT * FROM geography
) G
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- SQL EXISTS 存在式關聯查詢
-- EXISTS 是用來測試「內查詢」有沒有產生任何結果。
-- 如果有的話，系統就會執行「外查詢」中的 SQL。
-- 若是沒有的話，那整個 SQL 語句就不會產生任何結果。
-- EXISTS有測試的意圖，但非條件過濾限刷
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography 
    WHERE GEOGRAPHY_ID = 2
);

SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE NOT EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography 
    WHERE GEOGRAPHY_ID = 2
);

SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM geography G
    WHERE GEOGRAPHY_ID = 2
    AND S.GEOGRAPHY_ID = G.GEOGRAPHY_ID
);

-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE EXISTS (
	-- 內查詢
	SELECT EMPLOYEE_ID, FIRST_NAME FROM employees
);

-- SQL CASE WHEN 條件查詢
SELECT  STORE_ID, STORE_NAME, SALES,
	CASE STORE_NAME
		WHEN 'Boston' THEN SALES * 2
        WHEN 'Los Angeles' THEN SALES * 1.5
        ELSE SALES
	END "NEW_SALES"
FROM store_information;

SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	CASE GEOGRAPHY_ID
		WHEN 1 THEN '東區'
    WHEN 2 THEN '西區'
    ELSE '不分區'
	END "GEOGRAPHY_TEXT"
FROM store_information;

-- Oracle DECODE
/*
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	 DECODE(GEOGRAPHY_ID, 1, '東區', 2, '西區', '不分區') "GEOGRAPHY_TEXT"
FROM store_information;
*/

SELECT STORE_ID, STORE_NAME, SALES,
	CASE
		WHEN (SALES BETWEEN 0 AND 500) THEN '0-500'
        WHEN (SALES BETWEEN 501 AND 1000) THEN '501-1000'
        WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
        WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
        WHEN SALES > 3000 THEN ' > 3000'
	END "SALES_RANGE"
FROM store_information
ORDER BY SALES;

SELECT SALES_RANGE, COUNT(STORE_ID) 
FROM (
	SELECT STORE_ID, STORE_NAME, SALES,
		CASE
			WHEN (SALES BETWEEN 0 AND 500) THEN '0-500'
			WHEN (SALES BETWEEN 501 AND 1000) THEN '501-1000'
			WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
			WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
			WHEN SALES > 3000 THEN ' > 3000'
		END "SALES_RANGE"
	FROM store_information
	ORDER BY SALES
) SR
GROUP BY SALES_RANGE
ORDER BY SALES_RANGE;


-- Rank (排名函數) 
SELECT STORE_ID, STORE_NAME, SALES,
	RANK()OVER(ORDER BY SALES DESC) "STORE_RANK"
FROM store_information;


SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	RANK()OVER(PARTITION BY GEOGRAPHY_ID ORDER BY SALES DESC) "GEOGRAPHY_RANK" 
FROM store_information
ORDER BY GEOGRAPHY_ID, SALES DESC;

-- PERCENT_RANK ()：名次所佔的百分比
-- ROW_NUMBER () ：依序編號
SELECT STORE_ID, STORE_NAME, SALES,
	RANK()OVER(ORDER BY SALES DESC) "STORE_RANK",
    DENSE_RANK()OVER(ORDER BY SALES DESC) "STORE_DENSE_RANK",
    PERCENT_RANK()OVER(ORDER BY SALES DESC) "STORE_PERCENT_RANK",
    ROW_NUMBER()OVER(ORDER BY SALES DESC) "STORE_ROW_NUMBER"
FROM store_information;

-- Aggregate Functions with OVER clause
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


-- Analytic Functions with OVER clause
SELECT STORE_ID, STORE_NAME,
    ROW_NUMBER( ) OVER (ORDER BY SALES) ROWNO_STORE,
    SALES,
    -- 依「營業額」排序取"上一個"營業額
    LAG(SALES) OVER (ORDER BY SALES) PREV_SALES,
    -- 依「營業額」排序取"下一個"營業額
    LEAD(SALES) OVER (ORDER BY SALES) NEXT_SALES
FROM STORE_INFORMATION
ORDER BY SALES;



-- MySQL
SELECT SYSDATE(), YEAR(SYSDATE()), MONTH(SYSDATE()), DAY(SYSDATE()),
HOUR(SYSDATE()), MINUTE(SYSDATE()), SECOND(SYSDATE());

SELECT STORE_ID, STORE_NAME, STORE_DATE, YEAR(STORE_DATE), MONTH(STORE_DATE)
FROM STORE_INFORMATION
WHERE YEAR(STORE_DATE) = 2018
AND MONTH(STORE_DATE) BETWEEN 2 AND 3;

-- Oracle
-- TRUNC(date, [format])：對日期作無條件捨去運算(oracle)
-- MONTH(月捨去)、YEAR(年捨去)、不帶FORMAT(日捨去)
/*
SELECT * FROM DUAL;
SELECT SYSDATE, TRUNC(SYSDATE), TRUNC(SYSDATE, 'MONTH'), TRUNC(SYSDATE, 'YEAR')
FROM DUAL;
*/

-- MS SQL
/*
SELECT GETDATE(), YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE());

SELECT GETDATE() 'Today',
DATEPART(year,GETDATE()) 'Year Part',
DATEPART(month,GETDATE()) 'Month Part',
DATEPART(day,GETDATE()) 'Day Part',
DATEPART(hour,GETDATE()) 'Hour Part',
DATEPART(minute,GETDATE()) 'Minute Part',
DATEPART(second,GETDATE()) 'Second Part',
DATEPART(millisecond,GETDATE()) 'MilliSecond Part';
*/



--  MySQL日期算術:
SELECT SYSDATE(),
DATE_ADD( SYSDATE(), INTERVAL 1 DAY), 
DATE_ADD( SYSDATE(), INTERVAL -1 DAY), 
DATE_ADD('2021-08-15', INTERVAL 1 DAY),
DATE_ADD('2021-08-15', INTERVAL 1 MINUTE);


-- Oracle INTERVAL 日期計算
SELECT SYSDATE,
SYSDATE - INTERVAL '1' YEAR,
SYSDATE - INTERVAL '1' MONTH,
SYSDATE - INTERVAL '1' DAY,
SYSDATE - INTERVAL '1' HOUR,
SYSDATE - INTERVAL '1' MINUTE,
SYSDATE - INTERVAL '1' SECOND
FROM DUAL;

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



-- MySQL轉換函數：
-- 1.DATE_FORMAT(date,format):日期轉字串
SELECT DATE_FORMAT(SYSDATE(), '%Y/%m/%d %T'),
-- 2.STR_TO_DATE(str,format):字串轉日期
STR_TO_DATE('2021-08-15 00:00:00', "%Y-%m-%d %T"),
DATE_ADD(STR_TO_DATE('2021-08-15 00:00:00', "%Y-%m-%d %T"), INTERVAL 5 DAY);


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


-- MS SQL
/*
-- 1.日期轉字串
SELECT convert(varchar, getdate(), 100) 'mon dd yyyy hh:mmAM (or PM)';
SELECT convert(varchar, getdate(), 101) 'mm/dd/yyyy';
SELECT convert(varchar, getdate(), 102) 'yyyy.mm.dd';
SELECT convert(varchar, getdate(), 103) 'dd/mm/yyyy';
SELECT convert(varchar, getdate(), 104) 'dd.mm.yyyy';
SELECT convert(varchar, getdate(), 105) 'dd-mm-yyyy';
SELECT convert(varchar, getdate(), 106) 'dd mon yyyy';
SELECT convert(varchar, getdate(), 107) 'mon dd, yyyy';
SELECT convert(varchar, getdate(), 108) 'hh:mm:ss';
SELECT convert(varchar, getdate(), 109) 'mon dd yyyy hh:mm:ss:mmmAM (or PM)';
SELECT convert(varchar, getdate(), 110) 'mm-dd-yyyy';
SELECT convert(varchar, getdate(), 111) 'yyyy/mm/dd';
SELECT convert(varchar, getdate(), 112) 'yyyymmdd';
SELECT convert(varchar, getdate(), 113) 'dd mon yyyy hh:mm:ss:mmm';
SELECT convert(varchar, getdate(), 114) 'hh:mm:ss:mmm(24h)';
SELECT convert(varchar, getdate(), 120) 'yyyy-mm-dd hh:mm:ss(24h)';
SELECT convert(varchar, getdate(), 121) 'yyyy-mm-dd hh:mm:ss.mmm';
SELECT convert(varchar, getdate(), 126) 'yyyy-mm-ddThh:mm:ss.mmm';

-- 2.字串轉日期
SELECT convert(datetime, '2021-08-16 21:52:22', 120)　'yyyy-mm-dd hh:mm:ss(24h)';
SELECT DATEADD(DAY, 1, convert(datetime, '2021-08-16 21:52:22', 120) );
*/



