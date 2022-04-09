
-- UNION 聯集(不包含重覆值)
-- 1.UNION 跟 JOIN(需要下表格連結欄位 JOIN...ON...) 有些許類似
-- 2.查詢結果不包含重覆值
-- 3.查詢之間欄位必須相同(欄位型態) MySQL無此限制
-- 4.查詢之間欄位必須相同(欄位個數)
SELECT STORE_NAME FROM store_information
UNION
SELECT REGION_NAME FROM geography;

SELECT STORE_NAME FROM store_information
UNION
SELECT GEOGRAPHY_ID FROM geography;


SELECT STORE_ID, STORE_NAME FROM store_information
UNION
SELECT GEOGRAPHY_ID FROM geography;


SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME, S.SALES
FROM geography G 
LEFT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
UNION
SELECT G.GEOGRAPHY_ID, G.REGION_NAME, S.STORE_ID, S.STORE_NAME, S.SALES
FROM geography G 
RIGHT JOIN store_information S ON G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- SQL UNION ALL 聯集(包含重覆值)
SELECT STORE_NAME FROM store_information
UNION ALL
SELECT STORE_NAME FROM store_information;


-- SQL INTERSECT 交集 (MySQL沒支援)
-- 結果結果:1,2
-- 1,2,null
SELECT GEOGRAPHY_ID FROM store_information
INTERSECT
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography;


-- SQL MINUS 排除(不包含重覆值) (MySQL沒支援)
-- MINUS (Oracle)、EXCEPT (MS SQL)
-- 結果結果:3
-- 1,2,3
SELECT GEOGRAPHY_ID FROM geography
MINUS
-- 1,2,null
SELECT GEOGRAPHY_ID FROM store_information;

-- 子查詢 Sub Query
-- 外查詢
SELECT * FROM STORE_INFORMATION
WHERE SALES = (
	-- 內查詢
	SELECT MAX(SALES) FROM STORE_INFORMATION
);


SELECT SUM(SALES) FROM STORE_INFORMATION 
WHERE GEOGRAPHY_ID IN (
	SELECT GEOGRAPHY_ID FROM GEOGRAPHY WHERE REGION_NAME = 'West'
);

-- 『相關子查詢』(Correlated Subquery
-- "內查詢"使用"外查詢"欄位做關聯查詢
-- 10250
-- 外查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE GEOGRAPHY_ID IN (
	-- 內查詢
	SELECT GEOGRAPHY_ID FROM GEOGRAPHY G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
);

-- 13250
SELECT SUM(SALES) FROM STORE_INFORMATION;

SELECT * FROM STORE_INFORMATION;

-- 簡單子查詢
SELECT G.*, S.* FROM (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
) G, 
(
	SELECT GEOGRAPHY_ID, STORE_ID, STORE_NAME FROM STORE_INFORMATION
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 查詢與查詢之間彼此獨立不能互相使用對方的欄位做關聯查詢
SELECT G.*, S.* 
FROM (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
) G, 
(
	SELECT STORE.GEOGRAPHY_ID, STORE.STORE_ID, STORE.STORE_NAME 
    FROM STORE_INFORMATION STORE, G
    WHERE STORE.GEOGRAPHY_ID = G.GEOGRAPHY_ID
) S
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;


-- Common Table Expressions
-- 相關子查詢
WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
),
S AS (
	SELECT GEOGRAPHY_ID, STORE_ID, STORE_NAME FROM STORE_INFORMATION
)
SELECT * FROM G,S 
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- 查詢與查詢之間可以相互使用欄位做關聯式查詢
-- PS：注意只能下面的查詢使用上面查詢的欄位
WITH G AS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
),
S AS (
	SELECT STORE.GEOGRAPHY_ID, STORE.STORE_ID, STORE.STORE_NAME 
    FROM STORE_INFORMATION STORE, G
    WHERE STORE.GEOGRAPHY_ID = G.GEOGRAPHY_ID
)
SELECT * FROM G,S 
WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID;

-- SQL 子查詢相關應用(分頁功能)
SELECT S.* FROM (
	SELECT ROW_NUMBER() OVER() ROW_NUM, STORE_ID, STORE_NAME,SALES, STORE_DATE 
	FROM store_information
) S
WHERE S.ROW_NUM BETWEEN 4 AND 6;

-- 13,250
SELECT SUM(SALES) FROM STORE_INFORMATION
WHERE EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME FROM GEOGRAPHY
    WHERE REGION_NAME = 'West'
);

-- 存在式關聯子查詢
SELECT SUM(SALES) FROM STORE_INFORMATION S
WHERE EXISTS (
	SELECT GEOGRAPHY_ID, REGION_NAME 
    FROM GEOGRAPHY G
    WHERE G.GEOGRAPHY_ID = S.GEOGRAPHY_ID
    AND REGION_NAME = 'West'
);

-- CASE 接之後的"欄位"
SELECT STORE_ID, STORE_NAME, SALES,
	CASE STORE_NAME
		WHEN 'Los Angeles' THEN  SALES * 2
        WHEN 'San Diego' THEN  SALES * 1.5
        ELSE SALES END NEW_SALES
FROM STORE_INFORMATION
ORDER BY STORE_NAME;

-- CASE 接之後的"條件"
SELECT STORE_ID, STORE_NAME, SALES,
	CASE
		WHEN (SALES BETWEEN 0 AND 1000) THEN '0-1000'
        WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
        WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
        WHEN (SALES > 300) THEN '>3000'
        END SALES_RANGE
FROM STORE_INFORMATION
ORDER BY SALES;

-- 運用CASE WHEN查詢每間營業額的所屬數字範圍區間
-- GROUP BY來計算各「數字範圍區間」的資料個數
SELECT S.SALES_RANGE, COUNT(S.STORE_ID)
FROM (
	SELECT STORE_ID, STORE_NAME, SALES,
		CASE
			WHEN (SALES BETWEEN 0 AND 1000) THEN '0-1000'
			WHEN (SALES BETWEEN 1001 AND 2000) THEN '1001-2000'
			WHEN (SALES BETWEEN 2001 AND 3000) THEN '2001-3000'
			WHEN (SALES > 300) THEN '>3000'
			END SALES_RANGE
	FROM STORE_INFORMATION
	ORDER BY SALES
)S GROUP BY S.SALES_RANGE;


-- 自我連結 (self join)
-- 算出有多少筆資料 Sales 欄位的值是比自己本身的值高或是相等。
SELECT S1.*, S2.* 
FROM STORE_INFORMATION S1, STORE_INFORMATION S2
WHERE S2.SALES >= S1.SALES
ORDER BY S1.SALES, S2.SALES;


SELECT S1.STORE_ID, S1.STORE_NAME, S1.SALES, COUNT(S2.STORE_ID) STORE_RANK
FROM STORE_INFORMATION S1, STORE_INFORMATION S2
WHERE S2.SALES >= S1.SALES
GROUP BY S1.STORE_ID, S1.STORE_NAME, S1.SALES
ORDER BY S1.SALES DESC, S2.SALES;

-- Analytic Functions with OVER Clause (分析函數)
-- DENSE_RANK (  )：當有同名次時(排名结果是連續的)
-- PERCENT_RANK (  )：名次所佔的百分比
-- 公式：(RANK(  ) - 1)  /  (總資料列筆數 - 1)
-- ROW_NUMBER (  ) ：依序編號

SELECT STORE_ID, STORE_NAME, SALES,
	RANK()         OVER (ORDER BY SALES DESC) STORE_RANK,
    DENSE_RANK()   OVER (ORDER BY SALES DESC) STORE_DENSE_RANK,
    PERCENT_RANK() OVER (ORDER BY SALES DESC) STORE_PERCENT_RANK,
    ROW_NUMBER() OVER (ORDER BY SALES DESC) STORE_ROW_NUMBER
FROM STORE_INFORMATION;



-- PARTITION BY 資料劃分(分群排名)
-- 各別區域排名
SELECT STORE_ID, STORE_NAME, SALES, GEOGRAPHY_ID,
	RANK() OVER (PARTITION BY GEOGRAPHY_ID ORDER BY SALES DESC) GEOGRAPHY_STORE_RANK
FROM STORE_INFORMATION
ORDER BY GEOGRAPHY_ID;

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


-- MySQL：YEAR(date)取年、MONTH(date)取月份、DAY(date)取日
--  HOUR(date)取小時、MINUTE(date)取分鐘、SECOND(date)取秒
-- MySQL
SELECT SYSDATE(), YEAR(SYSDATE()), MONTH(SYSDATE()), DAY(SYSDATE()),
HOUR(SYSDATE()), MINUTE(SYSDATE()), SECOND(SYSDATE());

SELECT YEAR(STORE_DATE), MONTH(STORE_DATE) 
FROM store_information
WHERE MONTH(STORE_DATE) = 2;


-- Oracle
-- TRUNC(date, [format])：對日期作無條件捨去運算(oracle)
-- MONTH(月捨去)、YEAR(年捨去)、不帶FORMAT(日捨去)
SELECT SYSDATE, TRUNC(SYSDATE, 'YEAR'), TRUNC(SYSDATE, 'MONTH'), TRUNC(SYSDATE)
FROM DUAL;

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
SYSDATE + INTERVAL '1' YEAR,
SYSDATE - INTERVAL '1' MONTH,
SYSDATE - INTERVAL '1' DAY,
SYSDATE - INTERVAL '1' HOUR,
SYSDATE - INTERVAL '1' MINUTE,
SYSDATE - INTERVAL '1' SECOND
FROM DUAL;

--  MySQL日期算術:
-- MINUTE、HOUR、DAY、WEEK、MONTH、YEAR
SELECT SYSDATE(), 
DATE_ADD(SYSDATE(), INTERVAL 1 MONTH),
DATE_SUB(SYSDATE(), INTERVAL 1 MONTH),
DATE_ADD(SYSDATE(), INTERVAL 1 DAY),
DATE_ADD(SYSDATE(), INTERVAL 1 MINUTE);


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



